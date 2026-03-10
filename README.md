# 🪼 Jazzy Jellyfish Research Spider

Advanced Go web spider with ChromeDP (headless Chrome) and Colly for AI research, security analysis, and content aggregation.

## Features

- 🕷️ **Dual-engine crawling**: ChromeDP for JavaScript-heavy sites, Colly for fast HTTP crawling
- 🔒 **Security-focused**: Designed for security research and privacy analysis
- 🤖 **AI-ready**: Optimized for collecting AI/ML research data
- 📊 **Structured output**: Saves crawled content in organized format
- ⚡ **Concurrent**: High-performance parallel crawling

## Installation

```bash
# Install Go dependencies
go mod tidy

# Build
go build -o spider .

# Run
./spider
```

## Requirements

- Go 1.21+
- Chrome/Chromium (for ChromeDP)
- Internet connection

## Usage

```go
spider := NewJazzyJellyfishSpider()
spider.RunChromeDP(ctx, "https://example.com")
spider.RunCollySpider("https://example.com")
```

## Part of Jazzy Jellyfish OS

This spider is part of the [Jazzy Jellyfish](https://github.com/BoozeLee/jazzy-jellyfish-omni) ecosystem for AI research and automation.

## License

MIT
