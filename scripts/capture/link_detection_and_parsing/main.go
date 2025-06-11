package main

import (
	"bufio"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"net/url"
	"os"
	"regexp"
	"strings"
	"time"
	
	"golang.org/x/net/html"
)

// OEmbedResponse represents the YouTube oEmbed API response
type OEmbedResponse struct {
	Title string `json:"title"`
}

// detectURL finds the first URL in the given text
func detectURL(text string) string {
	// Regular expression to match URLs
	// This regex matches:
	// - URLs starting with http:// or https://
	// - URLs starting with www.
	// - Captures the full URL including path, query params, and fragments
	urlRegex := regexp.MustCompile(`(?i)(https?://[^\s]+|www\.[^\s]+)`)
	
	matches := urlRegex.FindStringSubmatch(text)
	if len(matches) > 0 {
		return matches[0]
	}
	
	return ""
}

// isYouTubeURL checks if the URL is a YouTube video URL
func isYouTubeURL(urlStr string) bool {
	// Convert to lowercase for case-insensitive matching
	lowerURL := strings.ToLower(urlStr)
	
	// Check for various YouTube URL patterns
	youtubePatterns := []string{
		"youtube.com/watch",
		"youtu.be/",
		"m.youtube.com/watch",
		"youtube.com/embed/",
		"youtube.com/v/",
	}
	
	for _, pattern := range youtubePatterns {
		if strings.Contains(lowerURL, pattern) {
			return true
		}
	}
	
	return false
}

// getYouTubeTitle fetches the title of a YouTube video using the oEmbed API
func getYouTubeTitle(videoURL string) (string, error) {
	// Construct oEmbed API URL
	oembedURL := fmt.Sprintf("https://www.youtube.com/oembed?url=%s&format=json", url.QueryEscape(videoURL))
	
	// Create HTTP client with timeout
	client := &http.Client{
		Timeout: 5 * time.Second,
	}
	
	// Make request
	resp, err := client.Get(oembedURL)
	if err != nil {
		return "", fmt.Errorf("failed to fetch YouTube title: %w", err)
	}
	defer resp.Body.Close()
	
	// Check status code
	if resp.StatusCode != http.StatusOK {
		return "", fmt.Errorf("YouTube oEmbed API returned status %d", resp.StatusCode)
	}
	
	// Read response body
	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return "", fmt.Errorf("failed to read response: %w", err)
	}
	
	// Parse JSON response
	var oembed OEmbedResponse
	if err := json.Unmarshal(body, &oembed); err != nil {
		return "", fmt.Errorf("failed to parse JSON: %w", err)
	}
	
	if oembed.Title == "" {
		return "", fmt.Errorf("no title found in response")
	}
	
	return oembed.Title, nil
}

// getPageTitle fetches the title of a webpage by parsing HTML
func getPageTitle(pageURL string) (string, error) {
	// Create HTTP client with timeout
	client := &http.Client{
		Timeout: 5 * time.Second,
	}
	
	// Make request
	resp, err := client.Get(pageURL)
	if err != nil {
		return "", fmt.Errorf("failed to fetch page: %w", err)
	}
	defer resp.Body.Close()
	
	// Check status code
	if resp.StatusCode != http.StatusOK {
		return "", fmt.Errorf("server returned status %d", resp.StatusCode)
	}
	
	// Parse HTML
	doc, err := html.Parse(resp.Body)
	if err != nil {
		return "", fmt.Errorf("failed to parse HTML: %w", err)
	}
	
	// Look for Open Graph title first, then fall back to regular title
	ogTitle := findMetaProperty(doc, "og:title")
	if ogTitle != "" {
		return ogTitle, nil
	}
	
	// Look for regular title tag
	titleTag := findTitleTag(doc)
	if titleTag != "" {
		return titleTag, nil
	}
	
	return "", fmt.Errorf("no title found")
}

// findMetaProperty searches for a meta tag with the given property
func findMetaProperty(n *html.Node, property string) string {
	if n.Type == html.ElementNode && n.Data == "meta" {
		var propValue, contentValue string
		for _, attr := range n.Attr {
			if attr.Key == "property" && attr.Val == property {
				propValue = attr.Val
			}
			if attr.Key == "content" {
				contentValue = attr.Val
			}
		}
		if propValue == property && contentValue != "" {
			return contentValue
		}
	}
	
	// Recursively search children
	for c := n.FirstChild; c != nil; c = c.NextSibling {
		if result := findMetaProperty(c, property); result != "" {
			return result
		}
	}
	
	return ""
}

// findTitleTag searches for the title tag in the HTML
func findTitleTag(n *html.Node) string {
	if n.Type == html.ElementNode && n.Data == "title" {
		// Extract text content from title tag
		if n.FirstChild != nil && n.FirstChild.Type == html.TextNode {
			return strings.TrimSpace(n.FirstChild.Data)
		}
	}
	
	// Recursively search children
	for c := n.FirstChild; c != nil; c = c.NextSibling {
		if result := findTitleTag(c); result != "" {
			return result
		}
	}
	
	return ""
}

// formatAsMarkdownLink formats a title and URL as a markdown link
func formatAsMarkdownLink(title, url string) string {
	return fmt.Sprintf("[%s](%s)", title, url)
}

// processLine processes a single line of input
func processLine(line string) string {
	// Remove trailing newline
	line = strings.TrimRight(line, "\n\r")
	
	// Detect URL in the line
	urlStr := detectURL(line)
	
	if urlStr == "" {
		// No URL detected, pass through unchanged
		return line
	}
	
	var title string
	var err error
	
	if isYouTubeURL(urlStr) {
		// Try YouTube oEmbed API first
		title, err = getYouTubeTitle(urlStr)
		if err != nil {
			// Log error to stderr but continue
			fmt.Fprintf(os.Stderr, "Warning: %v\n", err)
		}
	}
	
	if title == "" {
		// Fall back to HTML parsing
		title, err = getPageTitle(urlStr)
		if err != nil {
			// Log error to stderr but continue
			fmt.Fprintf(os.Stderr, "Warning: %v\n", err)
			// Use URL as title if we can't fetch the page title
			title = urlStr
		}
	}
	
	return formatAsMarkdownLink(title, urlStr)
}

func main() {
	scanner := bufio.NewScanner(os.Stdin)
	
	for scanner.Scan() {
		line := scanner.Text()
		processed := processLine(line)
		fmt.Println(processed)
	}
	
	if err := scanner.Err(); err != nil {
		fmt.Fprintf(os.Stderr, "Error reading input: %v\n", err)
		os.Exit(1)
	}
}