package main

import (
	"net/http"
	"net/http/httptest"
	"testing"
)

func TestDetectURL(t *testing.T) {
	tests := []struct {
		name     string
		input    string
		expected string
	}{
		{
			name:     "HTTPS URL",
			input:    "Check out https://example.com",
			expected: "https://example.com",
		},
		{
			name:     "HTTP URL",
			input:    "Visit http://test.org for more",
			expected: "http://test.org",
		},
		{
			name:     "URL with path and query",
			input:    "Link: https://example.com/path?param=value",
			expected: "https://example.com/path?param=value",
		},
		{
			name:     "URL with www prefix",
			input:    "Go to www.example.com",
			expected: "www.example.com",
		},
		{
			name:     "No URL",
			input:    "Just plain text",
			expected: "",
		},
		{
			name:     "Empty string",
			input:    "",
			expected: "",
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			result := detectURL(tt.input)
			if result != tt.expected {
				t.Errorf("detectURL(%q) = %q, want %q", tt.input, result, tt.expected)
			}
		})
	}
}

func TestIsYouTubeURL(t *testing.T) {
	tests := []struct {
		name     string
		url      string
		expected bool
	}{
		{
			name:     "Standard YouTube URL",
			url:      "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
			expected: true,
		},
		{
			name:     "YouTube URL without www",
			url:      "http://youtube.com/watch?v=dQw4w9WgXcQ",
			expected: true,
		},
		{
			name:     "YouTube short URL",
			url:      "https://youtu.be/dQw4w9WgXcQ",
			expected: true,
		},
		{
			name:     "YouTube mobile URL",
			url:      "https://m.youtube.com/watch?v=dQw4w9WgXcQ",
			expected: true,
		},
		{
			name:     "Non-YouTube URL",
			url:      "https://example.com",
			expected: false,
		},
		{
			name:     "Vimeo URL",
			url:      "https://vimeo.com/123456",
			expected: false,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			result := isYouTubeURL(tt.url)
			if result != tt.expected {
				t.Errorf("isYouTubeURL(%q) = %v, want %v", tt.url, result, tt.expected)
			}
		})
	}
}

func TestGetYouTubeTitle(t *testing.T) {
	// Create a test server that mimics YouTube oEmbed API
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if r.URL.Path == "/oembed" {
			w.Header().Set("Content-Type", "application/json")
			w.Write([]byte(`{"title": "Test Video Title"}`))
		} else {
			w.WriteHeader(http.StatusNotFound)
		}
	}))
	defer server.Close()

	// For actual implementation, you'd use the real YouTube API
	// This is just a placeholder test
	t.Skip("Skipping until implementation is complete")
}

func TestGetPageTitle(t *testing.T) {
	tests := []struct {
		name        string
		html        string
		expected    string
		expectError bool
	}{
		{
			name:     "Regular title tag",
			html:     `<html><head><title>Example Page</title></head></html>`,
			expected: "Example Page",
		},
		{
			name:     "Open Graph title",
			html:     `<html><head><meta property="og:title" content="OG Title"/></head></html>`,
			expected: "OG Title",
		},
		{
			name:     "Both title and OG title (OG should win)",
			html:     `<html><head><title>Regular Title</title><meta property="og:title" content="OG Title"/></head></html>`,
			expected: "OG Title",
		},
		{
			name:        "No title",
			html:        `<html><head></head></html>`,
			expected:    "",
			expectError: true,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			// Create test server
			server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
				w.Write([]byte(tt.html))
			}))
			defer server.Close()

			// Call getPageTitle with test server URL
			title, err := getPageTitle(server.URL)
			
			if tt.expectError {
				if err == nil {
					t.Errorf("Expected error but got none")
				}
			} else {
				if err != nil {
					t.Errorf("Unexpected error: %v", err)
				}
				if title != tt.expected {
					t.Errorf("getPageTitle() = %q, want %q", title, tt.expected)
				}
			}
		})
	}
}

func TestFormatAsMarkdownLink(t *testing.T) {
	tests := []struct {
		name     string
		title    string
		url      string
		expected string
	}{
		{
			name:     "Simple title and URL",
			title:    "Example Title",
			url:      "https://example.com",
			expected: "[Example Title](https://example.com)",
		},
		{
			name:     "Title with spaces",
			title:    "Title with spaces",
			url:      "https://test.org",
			expected: "[Title with spaces](https://test.org)",
		},
		{
			name:     "Title with special characters",
			title:    "Title [with] (special) chars",
			url:      "https://example.com",
			expected: "[Title [with] (special) chars](https://example.com)",
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			result := formatAsMarkdownLink(tt.title, tt.url)
			if result != tt.expected {
				t.Errorf("formatAsMarkdownLink(%q, %q) = %q, want %q", tt.title, tt.url, result, tt.expected)
			}
		})
	}
}

func TestProcessLine(t *testing.T) {
	tests := []struct {
		name     string
		input    string
		expected string
	}{
		{
			name:     "Plain text without URL",
			input:    "Just plain text",
			expected: "Just plain text",
		},
		{
			name:     "Empty line",
			input:    "",
			expected: "",
		},
		// More tests will be added once URL detection is implemented
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			result := processLine(tt.input)
			if result != tt.expected {
				t.Errorf("processLine(%q) = %q, want %q", tt.input, result, tt.expected)
			}
		})
	}
}