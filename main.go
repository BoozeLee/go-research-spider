package main

import (
	"context"
	"fmt"
	"log"
	"os"
	"time"

	"github.com/chromedp/chromedp"
	"github.com/gocolly/colly/v2"
)

// JazzyJellyfishSpider - Advanced research spider for AI/security content
type JazzyJellyfishSpider struct {
	Name        string
	Version     string
	TargetURLs  []string
	OutputDir   string
	UserAgent   string
	Delay       time.Duration
	MaxDepth    int
	Concurrency int
}

func NewJazzyJellyfishSpider() *JazzyJellyfishSpider {
	return &JazzyJellyfishSpider{
		Name:        "JazzyJellyfish-Research-Spider",
		Version:     "0.1.0",
		TargetURLs:  []string{},
		OutputDir:   "./output",
		UserAgent:   "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
		Delay:       time.Millisecond * 500,
		MaxDepth:    3,
		Concurrency: 8,
	}
}

// RunCollySpider - Basic HTTP spider using Colly
func (s *JazzyJellyfishSpider) RunCollySpider(startURL string) error {
	c := colly.NewCollector(
		colly.UserAgent(s.UserAgent),
		colly.MaxDepth(s.MaxDepth),
	)

	c.Limit(&colly.LimitRule{
		DomainGlob:  "*",
		Parallelism: s.Concurrency,
		Delay:       s.Delay,
	})

	c.OnHTML("html", func(e *colly.HTMLElement) {
		title := e.ChildText("title")
		log.Printf("Visited: %s - Title: %s", e.Request.URL, title)
		
		// Save content
		filename := fmt.Sprintf("%s/%s.txt", s.OutputDir, e.Request.URL.Path)
		os.WriteFile(filename, []byte(e.Text), 0644)
	})

	c.OnHTML("a[href]", func(e *colly.HTMLElement) {
		link := e.Attr("href")
		log.Printf("Found link: %s", link)
	})

	c.OnRequest(func(r *colly.Request) {
		log.Printf("Visiting: %s", r.URL.String())
	})

	c.OnError(func(r *colly.Response, err error) {
		log.Printf("Error: %s - %v", r.Request.URL, err)
	})

	log.Printf("Starting Colly spider from: %s", startURL)
	return c.Visit(startURL)
}

// RunChromeDP - Headless browser automation (Selenium alternative)
func (s *JazzyJellyfishSpider) RunChromeDP(ctx context.Context, url string) error {
	opts := append(chromedp.DefaultExecAllocatorOptions[:],
		chromedp.Flag("headless", true),
		chromedp.Flag("disable-gpu", true),
		chromedp.Flag("no-sandbox", true),
		chromedp.Flag("disable-dev-shm-usage", true),
		chromedp.UserAgent(s.UserAgent),
	)

	allocCtx, cancel := chromedp.NewExecAllocator(ctx, opts...)
	defer cancel()

	taskCtx, cancel := chromedp.NewContext(allocCtx)
	defer cancel()

	var title string
	var content string

	err := chromedp.Run(taskCtx,
		chromedp.Navigate(url),
		chromedp.Title(&title),
		chromedp.OuterText("html", &content, chromedp.NodeVisible),
	)

	if err != nil {
		return fmt.Errorf("ChromeDP error: %w", err)
	}

	log.Printf("Page Title: %s", title)
	log.Printf("Content Length: %d", len(content))
	return nil
}

func main() {
	log.SetFlags(log.LstdFlags | log.Lmicroseconds)
	
	spider := NewJazzyJellyfishSpider()
	
	log.Printf("🪼 %s v%s initialized", spider.Name, spider.Version)
	log.Printf("🕷️  Starting AI Research Spider for Jazzy Jellyfish OS")

	// Target URLs for AI/Security research
	targetURLs := []string{
		"https://wiki.archlinux.org/title/Security",
		"https://wiki.archlinux.org/title/Artificial_intelligence",
		"https://github.com/topics/machine-learning",
		"https://huggingface.co/models",
		"https://groq.com",
	}

	// Create output directory
	os.MkdirAll(spider.OutputDir, 0755)

	ctx := context.Background()

	for _, url := range targetURLs {
		log.Printf("🔍 Processing: %s", url)
		
		// Try ChromeDP first for JavaScript-heavy sites
		if err := spider.RunChromeDP(ctx, url); err != nil {
			log.Printf("ChromeDP failed, falling back to Colly: %v", err)
			if err := spider.RunCollySpider(url); err != nil {
				log.Printf("Colly also failed: %v", err)
			}
		}
		
		time.Sleep(time.Second * 2)
	}

	log.Printf("✅ Spider completed successfully!")
}
