---
nanobot:
  name: browser-use
  description: |
    Use this skill for AI-powered browser automation that is hard to detect.
    Triggers for: grabbing tickets, automating web tasks, filling forms automatically,
    web scraping with anti-detection, logging into websites, clicking buttons,
    navigating complex websites, automated purchasing.
    Keywords: "grab ticket", "搶票", "automate browser", "fill form", "login to",
    "buy ticket", "purchase", "click", "navigate website", "web automation".
  bins:
    - python3
  env:
    - ANTHROPIC_API_KEY
---

# Browser-Use: AI Browser Automation

browser-use 是一個 AI 瀏覽器代理，可以用自然語言控制真實瀏覽器，且難以被偵測。

## 環境設置

此 skill 使用獨立的 Python 虛擬環境：

```bash
# 啟動虛擬環境
source ~/.nanobot/workspace/skills/browser-use/.venv/bin/activate

# 設置 API Key（使用其中一個）
export ANTHROPIC_API_KEY="your-key"    # Claude
export OPENAI_API_KEY="your-key"       # OpenAI
export GEMINI_API_KEY="your-key"       # Gemini
```

## 基本使用

### 簡單任務
```python
from browser_use import Agent
import asyncio

async def main():
    agent = Agent(
        task="Go to google.com and search for 'weather in Taipei'",
    )
    result = await agent.run()
    print(result)

asyncio.run(main())
```

### 執行腳本
```bash
source ~/.nanobot/workspace/skills/browser-use/.venv/bin/activate
python3 script.py
```

## 搶票範例

### 基本搶票腳本
```python
from browser_use import Agent, Browser, BrowserConfig
import asyncio
from datetime import datetime

async def grab_ticket():
    # 設定瀏覽器（非 headless 方便觀察）
    browser = Browser(
        config=BrowserConfig(
            headless=False,
            disable_security=True,
        )
    )

    agent = Agent(
        task="""
        1. 前往 https://tixcraft.com（或你的售票網站）
        2. 等待頁面載入完成
        3. 找到目標演唱會/活動
        4. 選擇想要的場次日期
        5. 選擇票價區域
        6. 選擇 2 張票
        7. 點擊「立即購票」或類似按鈕
        8. 如果需要驗證碼，等待我手動輸入
        9. 確認訂單資訊
        """,
        browser=browser,
    )

    result = await agent.run()
    print(result)

    # 保持瀏覽器開啟讓你完成後續操作
    input("按 Enter 關閉瀏覽器...")

asyncio.run(grab_ticket())
```

### 定時搶票（等待開賣）
```python
from browser_use import Agent, Browser, BrowserConfig
import asyncio
from datetime import datetime
import time

TARGET_TIME = datetime(2024, 3, 15, 12, 0, 0)  # 開賣時間
TICKET_URL = "https://tixcraft.com/activity/detail/xxx"

async def timed_grab():
    browser = Browser(
        config=BrowserConfig(
            headless=False,
            disable_security=True,
        )
    )

    # 提前打開頁面並登入
    agent = Agent(
        task=f"""
        1. 前往 {TICKET_URL}
        2. 如果有登入按鈕，點擊登入
        3. 等待我手動登入完成
        4. 完成後告訴我已準備好
        """,
        browser=browser,
    )
    await agent.run()

    # 等待開賣時間
    print(f"等待開賣時間: {TARGET_TIME}")
    while datetime.now() < TARGET_TIME:
        remaining = (TARGET_TIME - datetime.now()).total_seconds()
        print(f"\r剩餘 {remaining:.1f} 秒...", end="", flush=True)
        time.sleep(0.1)

    print("\n開搶！")

    # 開始搶票
    grab_agent = Agent(
        task="""
        快速執行以下步驟：
        1. 立即點擊購票按鈕
        2. 選擇第一個可用的場次
        3. 選擇最好的座位區域
        4. 選擇 2 張票
        5. 點擊下一步/確認
        6. 盡快完成所有步驟
        """,
        browser=browser,
    )

    result = await grab_agent.run()
    print(result)

    input("按 Enter 關閉...")

asyncio.run(timed_grab())
```

## 針對不同售票平台

### 拓元 Tixcraft
```python
task="""
1. 前往 tixcraft.com
2. 搜尋「周杰倫」演唱會
3. 選擇台北場次
4. 選擇 2024/05/01 的場次
5. 選擇 $3800 票價區域
6. 選擇 2 張票
7. 快速點擊購買
8. 處理驗證碼（如果出現等我輸入）
"""
```

### KKTIX
```python
task="""
1. 前往 kktix.com
2. 找到目標活動
3. 點擊「立即購票」
4. 選擇票種和數量
5. 填寫購票人資訊
6. 確認訂單
"""
```

### ibon 售票
```python
task="""
1. 前往 ticket.ibon.com.tw
2. 搜尋活動
3. 選擇場次
4. 選擇座位區域
5. 選擇數量
6. 加入購物車
7. 結帳
"""
```

## 進階設定

### 使用自己的 Chrome Profile（保留登入狀態）
```python
browser = Browser(
    config=BrowserConfig(
        headless=False,
        chrome_instance_path="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome",
        extra_chromium_args=[
            f"--user-data-dir=/Users/YOUR_USER/Library/Application Support/Google/Chrome",
            "--profile-directory=Default",
        ],
    )
)
```

### 設定更快的操作
```python
agent = Agent(
    task="...",
    browser=browser,
    use_vision=True,        # 用視覺理解頁面
    max_actions_per_step=5, # 每步最多動作數
)
```

## 執行方式

### 方法 1：直接執行 Python
```bash
cd ~/.nanobot/workspace/skills/browser-use
source .venv/bin/activate
export ANTHROPIC_API_KEY="your-key"
python3 grab_ticket.py
```

### 方法 2：使用提供的腳本
```bash
~/.nanobot/workspace/skills/browser-use/scripts/run.sh grab_ticket.py
```

## 注意事項

1. **需要 API Key**：browser-use 使用 AI 來理解和操作網頁
2. **驗證碼**：複雜驗證碼可能需要手動輸入
3. **網路速度**：搶票時網路要快
4. **提前準備**：登入帳號、填好個人資料
5. **多開**：可以開多個視窗同時搶

## Troubleshooting

### 瀏覽器打不開
```bash
~/.nanobot/workspace/skills/browser-use/.venv/bin/playwright install chromium
```

### API Key 錯誤
確保設置了環境變數：
```bash
export ANTHROPIC_API_KEY="sk-ant-..."
```

### 動作太慢
使用 vision 模式會更快：
```python
agent = Agent(task="...", use_vision=True)
```
