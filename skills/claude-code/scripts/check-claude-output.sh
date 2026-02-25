#!/bin/bash
# check-claude-output.sh - Check output from a Claude Code tmux session
# Usage: check-claude-output.sh [session_name] [lines]

SESSION_NAME="${1:-claude-task}"
LINES="${2:-200}"

SOCKET_DIR="${NANOBOT_TMUX_SOCKET_DIR:-/tmp/nanobot-tmux-sockets}"
SOCKET="$SOCKET_DIR/claude.sock"

if [ ! -S "$SOCKET" ]; then
    echo "Error: Tmux socket not found. No Claude Code session running."
    exit 1
fi

# Check if session exists
if ! tmux -L nanobot -S "$SOCKET" has-session -t "$SESSION_NAME" 2>/dev/null; then
    echo "Error: Session '$SESSION_NAME' not found"
    echo "Available sessions:"
    tmux -L nanobot -S "$SOCKET" list-sessions 2>/dev/null || echo "  (none)"
    exit 1
fi

# Capture and display output
tmux -L nanobot -S "$SOCKET" capture-pane -t "$SESSION_NAME" -p -S "-$LINES"
