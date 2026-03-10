"""
Jazzy Jellyfish Research Spider - Python Version
Uses Playwright and Selenium for advanced web scraping
"""

import asyncio
import json
import logging
from pathlib import Path
from datetime import datetime
from typing import List, Optional

from playwright.async_api import async_playwright, Page, Browser
import requests
from bs4 import BeautifulSoup

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)


class JazzyJellyfishSpider:
    """Advanced research spider for AI/security content aggregation"""
    
    def __init__(self, output_dir: str = "./output", headless: bool = True):
        self.output_dir = Path(output_dir)
        self.output_dir.mkdir(parents=True, exist_ok=True)
        self.headless = headless
        self.session = requests.Session()
        self.session.headers.update({
            'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36'
        })
        
    async def scrape_with_playwright(self, url: str, wait_selector: Optional[str] = None) -> dict:
        """Scrape a page using Playwright (headless Chrome)"""
        logger.info(f"Playwright scraping: {url}")
        
        async with async_playwright() as p:
            browser: Browser = await p.chromium.launch(
                headless=self.headless,
                args=['--no-sandbox', '--disable-dev-shm-usage']
            )
            
            page: Page = await browser.new_page()
            await page.set_viewport_size({"width": 1920, "height": 1080})
            
            try:
                await page.goto(url, wait_until="networkidle", timeout=30000)
                
                # Wait for specific element if provided
                if wait_selector:
                    await page.wait_for_selector(wait_selector)
                
                # Extract data
                title = await page.title()
                content = await page.content()
                html = await page.inner_html("html")
                
                # Take screenshot
                screenshot_path = self.output_dir / f"{self._sanitize_url(url)}.png"
                await page.screenshot(path=str(screenshot_path), full_page=True)
                
                # Extract all links
                links = await page.eval_on_selector_all("a[href]", "elements => elements.map(e => e.href)")
                
                result = {
                    "url": url,
                    "title": title,
                    "timestamp": datetime.now().isoformat(),
                    "links_count": len(links),
                    "links": links[:50],  # Limit to first 50
                    "screenshot": str(screenshot_path),
                    "content_length": len(content)
                }
                
                # Save HTML
                html_path = self.output_dir / f"{self._sanitize_url(url)}.html"
                html_path.write_text(html)
                
                # Save metadata
                meta_path = self.output_dir / f"{self._sanitize_url(url)}.json"
                meta_path.write_text(json.dumps(result, indent=2))
                
                logger.info(f"✓ Scraped: {title}")
                return result
                
            except Exception as e:
                logger.error(f"Error scraping {url}: {e}")
                return {"error": str(e), "url": url}
            finally:
                await browser.close()
    
    def scrape_with_requests(self, url: str) -> dict:
        """Fast HTTP scraping using requests + BeautifulSoup"""
        logger.info(f"Requests scraping: {url}")
        
        try:
            response = self.session.get(url, timeout=30)
            response.raise_for_status()
            
            soup = BeautifulSoup(response.text, 'lxml')
            
            # Extract data
            title = soup.title.string if soup.title else "No title"
            
            # Get all text
            text = soup.get_text(separator=' ', strip=True)
            
            # Get all links
            links = []
            for a in soup.find_all('a', href=True):
                links.append(a['href'])
            
            # Get images
            images = [img.get('src') for img in soup.find_all('img', src=True)]
            
            result = {
                "url": url,
                "title": title,
                "timestamp": datetime.now().isoformat(),
                "links_count": len(links),
                "links": links[:50],
                "images_count": len(images),
                "text_length": len(text),
                "status_code": response.status_code
            }
            
            # Save content
            content_path = self.output_dir / f"{self._sanitize_url(url)}.txt"
            content_path.write_text(text[:100000])  # Limit size
            
            # Save metadata
            meta_path = self.output_dir / f"{self._sanitize_url(url)}.json"
            meta_path.write_text(json.dumps(result, indent=2))
            
            logger.info(f"✓ Scraped: {title}")
            return result
            
        except Exception as e:
            logger.error(f"Error scraping {url}: {e}")
            return {"error": str(e), "url": url}
    
    def _sanitize_url(self, url: str) -> str:
        """Convert URL to safe filename"""
        return url.replace('https://', '').replace('http://', '').replace('/', '_').replace('.', '_')[:100]
    
    async def run_batch(self, urls: List[str], use_playwright: bool = True) -> List[dict]:
        """Scrape multiple URLs concurrently"""
        if use_playwright:
            tasks = [self.scrape_with_playwright(url) for url in urls]
            return await asyncio.gather(*tasks)
        else:
            return [self.scrape_with_requests(url) for url in urls]


async def main():
    """Main entry point"""
    spider = JazzyJellyfishSpider()
    
    # Target URLs for AI/Security research
    target_urls = [
        "https://wiki.archlinux.org/title/Security",
        "https://github.com/topics/machine-learning",
        "https://huggingface.co/models",
        "https://groq.com",
        "https://ollama.com",
        "https://langchain.com",
    ]
    
    logger.info("🪼 Starting Jazzy Jellyfish Research Spider")
    logger.info(f"Target URLs: {len(target_urls)}")
    
    # Run with Playwright (JavaScript rendering)
    results = await spider.run_batch(target_urls, use_playwright=True)
    
    # Summary
    successful = sum(1 for r in results if "error" not in r)
    logger.info(f"✅ Completed: {successful}/{len(results)} successful")
    
    # Save summary
    summary_path = spider.output_dir / "summary.json"
    summary_path.write_text(json.dumps({
        "timestamp": datetime.now().isoformat(),
        "total": len(results),
        "successful": successful,
        "results": results
    }, indent=2))


if __name__ == "__main__":
    asyncio.run(main())
