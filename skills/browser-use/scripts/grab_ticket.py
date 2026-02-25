#!/usr/bin/env python3
"""
搶票腳本 - 使用 browser-use AI 代理
用法: python3 grab_ticket.py

設置環境變數:
  export ANTHROPIC_API_KEY="your-key"   # 或
  export OPENAI_API_KEY="your-key"      # 或
  export GEMINI_API_KEY="your-key"
"""

from browser_use import Agent, Browser, BrowserConfig
import asyncio
from datetime import datetime
import time
import os
import sys

# ============== 配置區域 ==============

# 開賣時間（修改為你的開賣時間）
TARGET_TIME = datetime(2024, 12, 31, 12, 0, 0)

# 售票網站 URL
TICKET_URL = "https://tixcraft.com"

# 搶票任務描述（根據你的需求修改）
TICKET_TASK = """
你是一個搶票助手，請快速執行以下步驟：

1. 前往售票頁面
2. 找到目標演唱會/活動
3. 選擇想要的場次日期
4. 選擇票價區域（優先選擇較好的位置）
5. 選擇 2 張票
6. 點擊購買/下一步按鈕
7. 如果出現驗證碼，暫停並通知我手動輸入
8. 確認訂單資訊

重要：
- 動作要快，不要猶豫
- 如果某個選項不可用，立即選擇下一個
- 遇到錯誤時自動重試
"""

# =====================================


async def prepare_browser():
    """準備瀏覽器並登入"""
    print("🌐 啟動瀏覽器...")

    browser = Browser(
        config=BrowserConfig(
            headless=False,  # 顯示瀏覽器視窗
            disable_security=True,
        )
    )

    print(f"📍 前往 {TICKET_URL}")
    print("⏳ 請手動登入你的帳號...")

    agent = Agent(
        task=f"""
        1. 前往 {TICKET_URL}
        2. 如果有登入按鈕，點擊它
        3. 等待用戶登入
        4. 登入完成後，回報「已準備好」
        """,
        browser=browser,
    )

    await agent.run()
    return browser


async def wait_for_sale():
    """等待開賣時間"""
    print(f"\n🕐 目標時間: {TARGET_TIME}")

    while datetime.now() < TARGET_TIME:
        remaining = (TARGET_TIME - datetime.now()).total_seconds()
        mins, secs = divmod(int(remaining), 60)
        print(f"\r⏳ 距離開賣: {mins:02d}:{secs:02d}", end="", flush=True)
        time.sleep(0.1)

    print("\n\n🚀 開搶！！！")


async def grab_tickets(browser):
    """執行搶票"""
    agent = Agent(
        task=TICKET_TASK,
        browser=browser,
        use_vision=True,  # 使用視覺模式，更快更準確
    )

    print("🎫 開始搶票...")
    result = await agent.run()
    print(f"\n✅ 結果: {result}")
    return result


async def main():
    # 檢查 API Key
    if not any([
        os.getenv("ANTHROPIC_API_KEY"),
        os.getenv("OPENAI_API_KEY"),
        os.getenv("GEMINI_API_KEY"),
    ]):
        print("❌ 錯誤: 請設置 API Key")
        print("   export ANTHROPIC_API_KEY='your-key'")
        sys.exit(1)

    print("=" * 50)
    print("🎫 搶票助手 - Powered by browser-use")
    print("=" * 50)

    # 步驟 1: 準備瀏覽器
    browser = await prepare_browser()

    input("\n✅ 登入完成後按 Enter 繼續...")

    # 步驟 2: 等待開賣
    await wait_for_sale()

    # 步驟 3: 搶票
    await grab_tickets(browser)

    # 保持瀏覽器開啟
    input("\n🎉 按 Enter 關閉瀏覽器...")


if __name__ == "__main__":
    asyncio.run(main())
