# My Nanobot Configuration

Personal nanobot skills and configuration.

## Structure

```
.
├── config.example.json    # Example configuration (copy to ~/.nanobot/config.json)
└── skills/
    └── claude-code/       # Claude Code integration skill
        ├── SKILL.md
        └── scripts/
            ├── run-claude.sh
            ├── run-claude-tmux.sh
            └── check-claude-output.sh
```

## Installation

1. Copy `config.example.json` to `~/.nanobot/config.json` and fill in your API keys
2. Copy `skills/` directory to `~/.nanobot/workspace/skills/`

```bash
cp config.example.json ~/.nanobot/config.json
cp -r skills/* ~/.nanobot/workspace/skills/
```

## Skills

### claude-code

Integrates Claude Code CLI with nanobot for advanced software engineering tasks.

**Triggers:** code generation, debugging, refactoring, multi-file edits, codebase analysis

**Requirements:**
- `claude` CLI installed
- `tmux` (for long-running tasks)

## License

MIT
