# 🕷️ Go Research Spider

[![Go](https://img.shields.io/badge/Go-1.21+-00ADD8.svg)](https://golang.org)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Bakerstreet Labs](https://img.shields.io/badge/Bakerstreet-Labs-black.svg)](https://github.com/Bakery-street-project)

> **High-performance concurrent web crawler purpose-built for AI/RAG research pipelines.**

Part of the [Bakerstreet Labs](https://github.com/Bakery-street-project) ecosystem — the data ingestion layer.

---

## ⚡ What It Does

Go Research Spider crawls the web concurrently, structures the output for RAG ingestion, and fires the data downstream to Baker Street Laboratory and BeeAI Hive. It's the **sensory system** of the Bakerstreet Labs AI brain.

```
[Web Sources] → Go Research Spider → [Structured Data] → [RAG Pipeline]
                  (concurrent)          (JSON/MD)        Baker Street Lab
                                                         BeeAI Hive
```

---

## 🚀 Quick Start

```bash
git clone https://github.com/BoozeLee/go-research-spider.git
cd go-research-spider

go mod download
go run main.go --url https://example.com --depth 3 --concurrent 10
```

---

## 🔗 Ecosystem Integration

Go Research Spider is the **data layer** that feeds the entire ecosystem:

```yaml
# On crawl complete → triggers:
repository_dispatch:
  event_type: research_data_ready
  targets:
    - BoozeLee/Baker-Street-Laboratory-1
    - BoozeLee/beeai-hive-999
```

Raw web data flows into Baker Street Laboratory's RAG pipeline, where the embed model indexes it for semantic search by any of the 8 specialist models.

---

## 🏗️ Architecture

```
go-research-spider/
├── crawler/         # Concurrent HTTP crawler
├── parser/          # HTML → structured data
├── pipeline/        # RAG-ready output formatting
├── dispatch/        # GitHub repository_dispatch sender
└── main.go          # Entry point
```

---

## 📄 License

MIT · [Bakerstreet Labs](https://github.com/Bakery-street-project)
