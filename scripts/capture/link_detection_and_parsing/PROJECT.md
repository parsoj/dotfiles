# PROJECT.md - Link Detection and Parsing

## Project Context
Building a Go-based tool that reads from stdin, detects URLs, and formats them as markdown links with proper titles.

## Current Status
- ✅ Basic URL detection implemented
- ✅ Markdown formatting working
- ✅ Test suite created
- 🔄 URLs currently use the URL itself as the title

## Architecture
- `main.go`: Core implementation with modular functions
  - `detectURL()`: Regex-based URL detection
  - `isYouTubeURL()`: YouTube URL pattern matching (stub)
  - `getYouTubeTitle()`: YouTube oEmbed API integration (stub)
  - `getPageTitle()`: HTML parsing for title extraction (stub)
  - `formatAsMarkdownLink()`: Markdown formatting
  - `processLine()`: Line-by-line processing logic

## Todo List
- [ ] Implement YouTube URL detection
- [ ] Implement YouTube oEmbed API integration
- [ ] Implement HTML title parsing (Open Graph and <title> tags)
- [ ] Add proper error handling for network requests
- [ ] Add timeout handling for HTTP requests
- [ ] Build and test as standalone binary
- [ ] Add support for multiple URLs per line (stretch goal)

## Build & Test Commands
```bash
# Run tests
go test -v

# Run specific test
go test -v -run TestDetectURL

# Build binary
go build -o link-parser

# Test with stdin
echo "Check out https://example.com" | go run main.go
```

## Implementation Notes
- Using Go's standard library where possible
- Will need to add HTML parsing package for title extraction
- YouTube oEmbed endpoint: https://www.youtube.com/oembed?url=VIDEO_URL&format=json