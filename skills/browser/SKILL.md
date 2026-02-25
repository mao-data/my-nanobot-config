---
nanobot:
  name: browser
  description: |
    Use this skill for opening websites in the user's real browser.
    Triggers for: opening websites, browsing URLs, searching on Google,
    opening YouTube, checking social media, reading articles.
    Keywords: "open website", "browse", "go to", "open URL", "search",
    "open in browser", "show me", "look up".
  bins:
    - open
  env: []
---

# Browser Skill

Open websites in the user's real browser (Safari, Chrome, Firefox, etc.) on macOS.

## Basic Usage

### Open a URL
```bash
open "https://example.com"
```

### Open with Specific Browser
```bash
# Safari (default)
open -a Safari "https://example.com"

# Google Chrome
open -a "Google Chrome" "https://example.com"

# Firefox
open -a Firefox "https://example.com"

# Arc
open -a Arc "https://example.com"

# Brave
open -a "Brave Browser" "https://example.com"

# Microsoft Edge
open -a "Microsoft Edge" "https://example.com"
```

### Open Multiple URLs
```bash
open "https://google.com" "https://github.com" "https://twitter.com"
```

## Common Tasks

### Google Search
```bash
open "https://www.google.com/search?q=your+search+query"
```

### YouTube Search
```bash
open "https://www.youtube.com/results?search_query=your+search"
```

### Open GitHub Repository
```bash
open "https://github.com/username/repo"
```

### Open Twitter/X Profile
```bash
open "https://twitter.com/username"
```

### Open Google Maps Location
```bash
open "https://www.google.com/maps/search/taipei+101"
```

### Open Gmail
```bash
open "https://mail.google.com"
```

### Open Google Drive
```bash
open "https://drive.google.com"
```

### Open ChatGPT
```bash
open "https://chat.openai.com"
```

### Open Claude
```bash
open "https://claude.ai"
```

## URL Encoding

For search queries with special characters, encode them:

```bash
# Using Python for URL encoding
open "https://www.google.com/search?q=$(python3 -c "import urllib.parse; print(urllib.parse.quote('你好世界'))")"
```

Or use `+` for spaces:
```bash
open "https://www.google.com/search?q=hello+world"
```

## Examples

### Search Google for "weather in Tokyo"
```bash
open "https://www.google.com/search?q=weather+in+tokyo"
```

### Open YouTube video
```bash
open "https://www.youtube.com/watch?v=VIDEO_ID"
```

### Search Amazon
```bash
open "https://www.amazon.com/s?k=wireless+headphones"
```

### Open Wikipedia article
```bash
open "https://en.wikipedia.org/wiki/Artificial_intelligence"
```

### Check flight status
```bash
open "https://www.google.com/search?q=BR+123+flight+status"
```

### Open Hacker News
```bash
open "https://news.ycombinator.com"
```

### Open Reddit subreddit
```bash
open "https://www.reddit.com/r/programming"
```

## Checking Available Browsers

List installed browsers:
```bash
ls /Applications | grep -iE "(safari|chrome|firefox|brave|arc|edge|opera)"
```

## Notes

1. The `open` command uses the system default browser unless `-a` is specified
2. URLs should be quoted to handle special characters
3. The browser opens in a new tab if already running
4. This opens the REAL browser with full functionality (login sessions, extensions, etc.)
