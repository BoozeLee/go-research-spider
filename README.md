# 🕷️ Jazzy Jellyfish Research Spider

> **Advanced dual-engine web crawler for AI research, security analysis & content aggregation**
> Built in Go + Python · Part of the [Bakertreet Labs](https://github.com/Bakery-street-project) ecosystem

[![Go Version](https://img.shields.io/badge/Go-1.21+-00ADD8?style=for-the-badge&logo=go&logoColor=white)](https://golang.org)
[![Python](https://img.shields.io/badge/Python-3.10+-3776AB?style=for-the-badge&logo=python&logoColor=white)](https://python.org)
[![License: MIT](https://img.shields.io/badge/License-MIT-22c55e?style=for-the-badge)](LICENSE)
[![CI](https://github.com/BoozeLee/go-research-spider/actions/workflows/ci.yml/badge.svg)](https://github.com/BoozeLee/go-research-spider/actions/workflows/ci.yml)
[![Security Scan](https://github.com/BoozeLee/go-research-spider/actions/workflows/security.yml/badge.svg)](https://github.com/BoozeLee/go-research-spider/actions/workflows/security.yml)
[![Bakertreet Labs](https://img.shields.io/badge/Bakertreet_Labs-🧪-6366f1?style=for-the-badge)](https://github.com/Bakery-street-project)

---

## 🎯 What It Does

The **Jazzy Jellyfish Research Spider** is a production-grade web crawling engine that powers AI data pipelines. It uses **two complementary crawling strategies** to handle any website — from static HTML pages to fully JavaScript-rendered SPAs.

| Engine | Best For | Technology |
|--------|----------|------------|
| **ChromeDP** | JS-heavy SPAs, dynamic content, authenticated pages | Headless Chrome |
| **Colly** | High-speed static crawls, APIs, structured data | Pure HTTP |

Feed your RAG pipelines, build security intelligence feeds, or aggregate research data at scale.

---

## ✨ Features

- 🦀 **Dual-engine crawling** — ChromeDP for JS-heavy sites, Colly for fast HTTP crawling
- 🔒 **Security-focused** — Designed for security research, privacy analysis, and threat intelligence
- 🤖 **AI-ready output** — Structured JSON/Markdown output optimized for LLM/RAG ingestion
- 📊 **Structured output** — Saves crawled content in organized, queryable formats
- ⚡ **Concurrent** — High-performance parallel crawling with configurable rate limits
- 🛡️ **Ethical defaults** — Respects `robots.txt`, configurable politeness delays
- 🐍 **Python bridge** — `python_spider.py` for Playwright/Selenium-style dynamic tasks

---

## 🏗️ Architecture

```
┌──────────────────────────────────────────────────────────┐
│                  go-research-spider                      │
│                                                          │
│  ┌─────────────────────┐    ┌────────────────────────┐  │
│  │     Go Engine       │    │    Python Bridge       │  │
│  │                     │    │                        │  │
│  │  ChromeDP           │    │  python_spider.py      │  │
│  │  (JS-rendered sites)│    │  (Playwright / Selenium│  │
│  │        +            │    │   style crawling)      │  │
│  │  Colly              │    │                        │  │
│  │  (fast HTTP crawls) │    │                        │  │
│  └──────────┬──────────┘    └───────────┬────────────┘  │
│             │                           │               │
│             └──────────┬────────────────┘               │
│                        ▼                                │
│              ┌──────────────────────┐                   │
│              │   Structured Output  │                   │
│              │  JSON · Markdown     │                   │
│              │  RAG-ready chunks    │                   │
│              └──────────────────────┘                   │
└──────────────────────────────────────────────────────────┘
```

---

## 🚀 Quick Start

### Prerequisites

- Go 1.21+
- Chrome/Chromium (for ChromeDP engine)
- Python 3.10+ (optional, for `python_spider.py`)

### Installation

```bash
# Clone the repository
git clone https://github.com/BoozeLee/go-research-spider.git
cd go-research-spider

# Install Go dependencies
go mod tidy

# Build the binary
go build -o spider .

# Run
./spider --url https://arxiv.org/search/?query=LLM+agents
```

### Python Bridge (Optional)

```bash
pip install playwright selenium beautifulsoup4 requests lxml
playwright install chromium

python python_spider.py --url https://example.com --output output/
```

---

## 🔧 Usage

### Go API

```go
// Initialize the spider
spider := NewJazzyJellyfishSpider()

// ChromeDP engine — for JavaScript-rendered pages
spider.RunChromeDPSpider(ctx, "https://example.com")

// Colly engine — fast HTTP crawling
spider.RunCollySpider("https://example.com")
```

### Use Cases

```bash
# Feed a RAG pipeline — crawl AI research papers
./spider --url https://arxiv.org/search/?query=retrieval+augmented+generation --output json

# Security intelligence — scan a target (authorized use only)
./spider --url https://target.example.com --engine chromedp --depth 3

# Content aggregation — structured markdown output
./spider --url https://docs.example.com --output markdown --recursive
```

---

## 📁 Project Structure

```
go-research-spider/
├── main.go                  # Go entry point — dual-engine orchestrator
├── python_spider.py         # Python bridge (Playwright/Selenium)
├── go.mod                   # Go module dependencies
├── .gitignore               # Secrets & build artifacts excluded
├── .github/
│   ├── workflows/
│   │   ├── ci.yml           # Build · lint · test pipeline
│   │   └── security.yml     # gosec · govulncheck · CodeQL
│   └── dependabot.yml       # Automated dependency updates
├── docs/                    # Extended documentation
└── scripts/                 # Build and utility scripts
```

---

## 🔒 Security

We take security seriously. This tool is designed for **ethical research and authorized use only**.

- ✅ Respects `robots.txt` by default
- ✅ Configurable rate limits to prevent abuse
- ✅ No credentials are ever logged or stored
- ✅ All external URLs validated before crawling
- ✅ Automated security scanning via GitHub Actions (gosec, govulncheck)

> ⚠️ **Authorized use only.** You are responsible for ensuring you have permission to crawl any target.

To report a security vulnerability, see [SECURITY.md](SECURITY.md).

---

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feat/my-feature`
3. Commit with [Conventional Commits](https://www.conventionalcommits.org/): `git commit -m "feat: add concurrent rate limiter"`
4. Push and open a Pull Request against `main`

Please read [SECURITY.md](SECURITY.md) before submitting security-related PRs.

---

## 📄 License

MIT — see [LICENSE](LICENSE) for details.

---

<div align="center">

**[Bakertreet Labs](https://github.com/Bakery-street-project)** · Building the future, one agent at a time 🧪

*Production-ready AI infrastructure · Open-Source · Built with Go*

</div>
