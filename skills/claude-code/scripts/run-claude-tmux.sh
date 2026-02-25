#!/bin/bash
# run-claude-tmux.sh - Run Claude Code in a tmux session for long-running tasks
# Usage: run-claude-tmux.sh <session_name> <project_dir> <prompt>

set -e

SESSION_NAME="${1:-claude-task}"
PROJECT_DIR="${2:-.}"
PROMPT="${3:-}"

if [ -z "$PROMPT" ]; then
    echo "Error: No prompt provided"
    echo "Usage: run-claude-tmux.sh <session_name> <project_dir> <prompt>"
    exit 1
fi

if [ ! -d "$PROJECT_DIR" ]; then
    echo "Error: Directory does not exist: $PROJECT_DIR"
    exit 1
fi

# Setup tmux socket
SOCKET_DIR="${NANOBOT_TMUX_SOCKET_DIR:-/tmp/nanobot-tmux-sockets}"
mkdir -p "$SOCKET_DIR"
SOCKET="$SOCKET_DIR/claude.sock"

# Kill existing session if exists
tmux -L nanobot -S "$SOCKET" kill-session -t "$SESSION_NAME" 2>/dev/null || true

# Create new session
tmux -L nanobot -S "$SOCKET" new-session -d -s "$SESSION_NAME" -c "$PROJECT_DIR"

# Send claude command
tmux -L nanobot -S "$SOCKET" send-keys -t "$SESSION_NAME" "claude -p '$PROMPT'" Enter

echo "Started Claude Code in tmux session: $SESSION_NAME"
echo "Monitor with: tmux -L nanobot -S $SOCKET capture-pane -t $SESSION_NAME -p -S -200"
