#!/bin/bash
# run-claude.sh - Run Claude Code with a prompt in a specified directory
# Usage: run-claude.sh <project_dir> <prompt>

set -e

PROJECT_DIR="${1:-.}"
PROMPT="${2:-}"

if [ -z "$PROMPT" ]; then
    echo "Error: No prompt provided"
    echo "Usage: run-claude.sh <project_dir> <prompt>"
    exit 1
fi

if [ ! -d "$PROJECT_DIR" ]; then
    echo "Error: Directory does not exist: $PROJECT_DIR"
    exit 1
fi

cd "$PROJECT_DIR"
exec claude -p "$PROMPT"
