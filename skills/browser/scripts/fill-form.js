#!/usr/bin/env node
/**
 * fill-form.js - Fill and submit a web form
 * Usage: node fill-form.js <url> <form_data_json>
 *
 * Example:
 *   node fill-form.js https://example.com/contact '{"#name":"John","#email":"john@example.com"}'
 */

const { chromium } = require('playwright');

async function fillForm(url, formData) {
  const browser = await chromium.launch({ headless: false });
  const page = await browser.newPage();

  try {
    await page.goto(url, { waitUntil: 'networkidle' });

    const data = JSON.parse(formData);

    for (const [selector, value] of Object.entries(data)) {
      const element = page.locator(selector);
      const tagName = await element.evaluate(el => el.tagName.toLowerCase());

      if (tagName === 'select') {
        await element.selectOption(value);
      } else if (tagName === 'input') {
        const type = await element.getAttribute('type');
        if (type === 'checkbox' || type === 'radio') {
          if (value) await element.check();
        } else {
          await element.fill(value);
        }
      } else {
        await element.fill(value);
      }

      console.log(`Filled ${selector} with: ${value}`);
    }

    console.log('\nForm filled. Browser will stay open for review.');
    console.log('Press Ctrl+C to close.');

    // Keep browser open for review
    await page.waitForTimeout(300000); // 5 minutes

  } catch (error) {
    console.error('Error:', error.message);
    process.exit(1);
  } finally {
    await browser.close();
  }
}

const [,, url, formData] = process.argv;

if (!url || !formData) {
  console.error('Usage: node fill-form.js <url> <form_data_json>');
  console.error('Example: node fill-form.js https://example.com/form \'{"#name":"John"}\'');
  process.exit(1);
}

fillForm(url, formData);
