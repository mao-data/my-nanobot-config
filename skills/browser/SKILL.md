---
nanobot:
  name: browser
  description: |
    Use this skill for web browser automation and interaction tasks.
    Triggers for: opening websites, clicking buttons, filling forms, taking screenshots,
    scraping web content, automating web workflows, testing websites,
    extracting data from web pages, logging into websites.
    Keywords: "open website", "browse", "click", "fill form", "screenshot",
    "scrape", "extract from page", "automate browser", "web automation".
  bins:
    - npx
  env: []
---

# Browser Automation Skill

This skill enables browser automation using Playwright. You can open websites, interact with elements, fill forms, take screenshots, and extract content.

## Prerequisites

First-time setup (installs browser binaries):
```bash
npx playwright install chromium
```

## Quick Commands

### Open a URL and Take Screenshot
```bash
npx playwright screenshot --wait-for-timeout 3000 "https://example.com" screenshot.png
```

### Open Browser for Interactive Use
```bash
npx playwright open "https://example.com"
```

### Generate Code by Recording Actions
```bash
npx playwright codegen "https://example.com"
```
This opens a browser and records your actions as code.

## Using Playwright Scripts

For complex automation, create and run JavaScript/TypeScript scripts.

### Basic Script Template
Create a file `script.js`:
```javascript
const { chromium } = require('playwright');

(async () => {
  const browser = await chromium.launch({ headless: false });
  const page = await browser.newPage();

  // Navigate to URL
  await page.goto('https://example.com');

  // Wait for page to load
  await page.waitForLoadState('networkidle');

  // Your actions here...

  await browser.close();
})();
```

Run with:
```bash
npx playwright test script.js
# or
node script.js
```

## Common Operations

### Click an Element
```javascript
// By text
await page.click('text=Submit');

// By CSS selector
await page.click('#submit-button');
await page.click('.btn-primary');

// By role
await page.getByRole('button', { name: 'Submit' }).click();
```

### Fill a Form
```javascript
// Fill input field
await page.fill('#username', 'myuser');
await page.fill('#password', 'mypassword');

// Or use locators
await page.getByLabel('Username').fill('myuser');
await page.getByPlaceholder('Enter email').fill('test@example.com');
```

### Extract Text Content
```javascript
// Get text from element
const text = await page.textContent('.article-content');

// Get all matching elements
const items = await page.$$eval('.list-item', elements =>
  elements.map(el => el.textContent)
);

// Get attribute
const href = await page.getAttribute('a.link', 'href');
```

### Take Screenshots
```javascript
// Full page
await page.screenshot({ path: 'full.png', fullPage: true });

// Specific element
await page.locator('#chart').screenshot({ path: 'chart.png' });
```

### Wait for Elements
```javascript
// Wait for element to appear
await page.waitForSelector('.loaded-content');

// Wait for navigation
await page.waitForURL('**/dashboard');

// Wait for network idle
await page.waitForLoadState('networkidle');
```

### Handle Popups and Dialogs
```javascript
// Accept dialog
page.on('dialog', dialog => dialog.accept());

// Handle new tab/popup
const [popup] = await Promise.all([
  page.waitForEvent('popup'),
  page.click('a[target="_blank"]')
]);
await popup.waitForLoadState();
```

## Example: Login and Extract Data

```javascript
const { chromium } = require('playwright');

(async () => {
  const browser = await chromium.launch({ headless: true });
  const page = await browser.newPage();

  // Go to login page
  await page.goto('https://example.com/login');

  // Fill login form
  await page.fill('#email', 'user@example.com');
  await page.fill('#password', 'password123');
  await page.click('button[type="submit"]');

  // Wait for dashboard
  await page.waitForURL('**/dashboard');

  // Extract data
  const userName = await page.textContent('.user-name');
  const notifications = await page.$$eval('.notification', els =>
    els.map(el => el.textContent)
  );

  console.log('User:', userName);
  console.log('Notifications:', notifications);

  // Take screenshot
  await page.screenshot({ path: 'dashboard.png' });

  await browser.close();
})();
```

## Example: Scrape a List of Items

```javascript
const { chromium } = require('playwright');

(async () => {
  const browser = await chromium.launch();
  const page = await browser.newPage();

  await page.goto('https://news.ycombinator.com');

  // Extract all story titles and links
  const stories = await page.$$eval('.titleline > a', links =>
    links.map(link => ({
      title: link.textContent,
      url: link.href
    }))
  );

  console.log(JSON.stringify(stories, null, 2));

  await browser.close();
})();
```

## Example: Fill and Submit a Form

```javascript
const { chromium } = require('playwright');

(async () => {
  const browser = await chromium.launch({ headless: false });
  const page = await browser.newPage();

  await page.goto('https://example.com/contact');

  // Fill form fields
  await page.getByLabel('Name').fill('John Doe');
  await page.getByLabel('Email').fill('john@example.com');
  await page.getByLabel('Message').fill('Hello, this is a test message.');

  // Select dropdown
  await page.selectOption('#subject', 'support');

  // Check checkbox
  await page.check('#agree-terms');

  // Submit
  await page.click('button[type="submit"]');

  // Wait for confirmation
  await page.waitForSelector('.success-message');

  console.log('Form submitted successfully!');

  await browser.close();
})();
```

## Running in Tmux (Long Tasks)

For browser automation that takes time:

```bash
# Set socket directory
export NANOBOT_TMUX_SOCKET_DIR="${NANOBOT_TMUX_SOCKET_DIR:-/tmp/nanobot-tmux-sockets}"
mkdir -p "$NANOBOT_TMUX_SOCKET_DIR"

# Create session
tmux -L nanobot -S "$NANOBOT_TMUX_SOCKET_DIR/browser.sock" new-session -d -s browser-task

# Run script
tmux -L nanobot -S "$NANOBOT_TMUX_SOCKET_DIR/browser.sock" send-keys -t browser-task "node /path/to/script.js" Enter

# Check output
tmux -L nanobot -S "$NANOBOT_TMUX_SOCKET_DIR/browser.sock" capture-pane -t browser-task -p -S -100
```

## Tips

1. **Use headless mode for automation**: `chromium.launch({ headless: true })`
2. **Use headed mode for debugging**: `chromium.launch({ headless: false })`
3. **Add slowMo for debugging**: `chromium.launch({ slowMo: 500 })`
4. **Always wait for elements** before interacting
5. **Handle errors gracefully** with try/catch blocks
6. **Close browser** when done to free resources

## Troubleshooting

### Browser not installed
```bash
npx playwright install chromium
```

### Element not found
- Wait for element: `await page.waitForSelector('.element')`
- Check if inside iframe: `const frame = page.frameLocator('iframe')`
- Use more specific selector

### Timeout errors
Increase timeout:
```javascript
await page.click('button', { timeout: 30000 });
```

### Page not loading
Wait for network:
```javascript
await page.waitForLoadState('networkidle');
```
