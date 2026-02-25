---
nanobot:
  name: claude-code
  description: |
    Use this skill when the user needs advanced software engineering assistance.
    Triggers for: code generation, debugging, refactoring, multi-file edits,
    codebase analysis, implementing features, fixing bugs, writing tests,
    code review, or any complex programming task.
    Keywords: "help me code", "implement", "fix this bug", "refactor",
    "write a function", "create a feature", "analyze this code", "debug".
  bins:
    - claude
    - tmux
  env: []
---

# Claude Code Integration

Claude Code is Anthropic's official CLI tool for software engineering tasks. It provides an AI-powered coding assistant that can read, write, and modify code across your entire project.

## Capabilities

- **Code Generation**: Create new files, functions, components, and features
- **Debugging**: Find and fix bugs, analyze error messages
- **Refactoring**: Improve code structure, optimize performance
- **Multi-file Editing**: Make coordinated changes across multiple files
- **Codebase Analysis**: Understand project structure and architecture
- **Test Writing**: Generate unit tests, integration tests
- **Documentation**: Add comments, docstrings, README files

## Basic Usage

### Interactive Session
Start Claude Code in a project directory:
```bash
cd /path/to/project && claude
```

### Single Prompt (Non-interactive)
Execute a single task and exit:
```bash
cd /path/to/project && claude -p "your task description"
```

### Print Mode (Output Only)
Get response without interactive session:
```bash
claude -p "explain this error: ..." --print
```

## Running with Tmux (Recommended for Long Tasks)

For tasks that may take time, use tmux to run Claude Code in background:

### Create a Session and Run Task
```bash
# Set socket directory
export NANOBOT_TMUX_SOCKET_DIR="${NANOBOT_TMUX_SOCKET_DIR:-/tmp/nanobot-tmux-sockets}"
mkdir -p "$NANOBOT_TMUX_SOCKET_DIR"

# Create session
tmux -L nanobot -S "$NANOBOT_TMUX_SOCKET_DIR/claude.sock" new-session -d -s claude-task -c /path/to/project

# Send command
tmux -L nanobot -S "$NANOBOT_TMUX_SOCKET_DIR/claude.sock" send-keys -t claude-task "claude -p 'your task here'" Enter
```

### Monitor Progress
```bash
# View recent output (last 200 lines)
tmux -L nanobot -S "$NANOBOT_TMUX_SOCKET_DIR/claude.sock" capture-pane -t claude-task -p -S -200
```

### Send Additional Input
```bash
# Send text
tmux -L nanobot -S "$NANOBOT_TMUX_SOCKET_DIR/claude.sock" send-keys -t claude-task -l "additional instruction"
tmux -L nanobot -S "$NANOBOT_TMUX_SOCKET_DIR/claude.sock" send-keys -t claude-task Enter

# Send interrupt (Ctrl+C)
tmux -L nanobot -S "$NANOBOT_TMUX_SOCKET_DIR/claude.sock" send-keys -t claude-task C-c
```

### Clean Up Session
```bash
tmux -L nanobot -S "$NANOBOT_TMUX_SOCKET_DIR/claude.sock" kill-session -t claude-task
```

## Workflow Examples

### Example 1: Fix a Bug
```bash
cd ~/projects/myapp
claude -p "There's a bug where user login fails after password reset. Find and fix it."
```

### Example 2: Implement a Feature
```bash
cd ~/projects/myapp
claude -p "Add a dark mode toggle to the settings page. Save preference to localStorage."
```

### Example 3: Refactor Code
```bash
cd ~/projects/myapp
claude -p "Refactor the authentication module to use async/await instead of callbacks."
```

### Example 4: Analyze Codebase
```bash
cd ~/projects/myapp
claude -p "Explain the architecture of this project. What are the main components?" --print
```

### Example 5: Long-running Task with Tmux
```bash
# Start background session
export NANOBOT_TMUX_SOCKET_DIR="/tmp/nanobot-tmux-sockets"
mkdir -p "$NANOBOT_TMUX_SOCKET_DIR"
tmux -L nanobot -S "$NANOBOT_TMUX_SOCKET_DIR/claude.sock" new-session -d -s refactor -c ~/projects/myapp
tmux -L nanobot -S "$NANOBOT_TMUX_SOCKET_DIR/claude.sock" send-keys -t refactor "claude -p 'Migrate the entire codebase from JavaScript to TypeScript'" Enter

# Check progress periodically
tmux -L nanobot -S "$NANOBOT_TMUX_SOCKET_DIR/claude.sock" capture-pane -t refactor -p -S -100
```

## Best Practices

1. **Always specify the project directory** - `cd` to the project before running claude
2. **Be specific in prompts** - Describe exactly what you want done
3. **Use tmux for long tasks** - Prevents timeout and allows monitoring
4. **Check output regularly** - Monitor progress on complex tasks
5. **One task at a time** - Let Claude Code complete before starting another

## Common Flags

| Flag | Description |
|------|-------------|
| `-p, --prompt` | Run with a single prompt |
| `--print` | Print response and exit (no interaction) |
| `--no-input` | Disable interactive input |
| `--verbose` | Show detailed output |
| `-c, --continue` | Continue previous conversation |

## Troubleshooting

### Claude Code Not Responding
Send Ctrl+C and restart:
```bash
tmux -L nanobot -S "$NANOBOT_TMUX_SOCKET_DIR/claude.sock" send-keys -t claude-task C-c
```

### Session Stuck
Kill and recreate:
```bash
tmux -L nanobot -S "$NANOBOT_TMUX_SOCKET_DIR/claude.sock" kill-session -t claude-task
# Then create new session
```

### Check if Claude is Running
```bash
pgrep -f "claude" || echo "Claude is not running"
```
