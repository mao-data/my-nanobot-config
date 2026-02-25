#!/usr/bin/env python3
"""
簡單任務範例 - 測試 browser-use 是否正常運作
用法: python3 simple_task.py "你的任務描述"
"""

from browser_use import Agent
import asyncio
import sys

async def main():
    task = sys.argv[1] if len(sys.argv) > 1 else "Go to google.com and search for 'hello world'"

    print(f"🎯 任務: {task}")
    print("🌐 啟動瀏覽器...")

    agent = Agent(task=task)
    result = await agent.run()

    print(f"\n✅ 完成: {result}")

if __name__ == "__main__":
    asyncio.run(main())
