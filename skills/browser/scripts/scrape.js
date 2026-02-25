#!/usr/bin/env node
/**
 * scrape.js - Extract content from a webpage
 * Usage: node scrape.js <url> [selector]
 *
 * Examples:
 *   node scrape.js https://example.com                    # Get page title and text
 *   node scrape.js https://example.com "h1"               # Get all h1 elements
 *   node scrape.js https://example.com ".article-title"   # Get elements by class
 */

const { chromium } = require('playwright');

async function scrape(url, selector) {
  const browser = await chromium.launch({ headless: true });
  const page = await browser.newPage();

  try {
    await page.goto(url, { waitUntil: 'networkidle', timeout: 30000 });

    let result;

    if (selector) {
      // Extract specific elements
      result = await page.$$eval(selector, elements =>
        elements.map(el => ({
          text: el.textContent?.trim(),
          html: el.outerHTML,
          href: el.href || null
        }))
      );
    } else {
      // Extract general page info
      result = {
        title: await page.title(),
        url: page.url(),
        text: await page.textContent('body'),
        links: await page.$$eval('a[href]', links =>
          links.slice(0, 50).map(a => ({
            text: a.textContent?.trim(),
            href: a.href
          }))
        )
      };
    }

    console.log(JSON.stringify(result, null, 2));

  } catch (error) {
    console.error('Error:', error.message);
    process.exit(1);
  } finally {
    await browser.close();
  }
}

const [,, url, selector] = process.argv;

if (!url) {
  console.error('Usage: node scrape.js <url> [selector]');
  process.exit(1);
}

scrape(url, selector);
