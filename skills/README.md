# Skills Orchestrator

Global multi-source skill manager for GitHub Copilot CLI and Claude Code.
Reads source repos from [`sources`](sources), runs conflict checks, and
stows each source's packages into the right tool directories via GNU stow.

```
sources file
  ~/git/personal/skills  ─┐
  ~/git/work/skills  ─────┼──► skills-stow ──► ~/.copilot/skills/
  ~/git/other/skills  ────┘              └──► ~/.claude/skills/
                                              ~/.copilot/agents/
```

---

## Install

Add the `bin/` directory to your PATH. In `~/.zshrc` (or wherever your shell config lives):

```zsh
export PATH="$HOME/dotfiles/skills/bin:$PATH"
```

Then reload: `source ~/.zshrc` (or open a new shell).

---

## Commands

| Command | Description |
|---|---|
| `skills-stow` | Stow all sources → targets (idempotent) |
| `skills-unstow` | Remove all managed symlinks |
| `skills-check` | Scan for conflicts, no side effects |
| `skills-adopt` | Move a tool-installed skill into a source repo |

---

## Daily use

- **Edit a skill** in any source repo → no action needed; symlinks are live.
- **Add a skill** → create it in the source repo, run `skills-stow`.
- **Add a source repo** → append its path to `sources`, run `skills-stow`.

---

## Adding a source repo

Each source must follow the stow-package convention:

```
<source>/
  shared/
    skills/      ← stowed to both ~/.copilot/skills/ and ~/.claude/skills/
  copilot/
    agents/      ← stowed to ~/.copilot/agents/
    skills/      ← stowed to ~/.copilot/skills/ (copilot-only)
  claude/
    skills/      ← stowed to ~/.claude/skills/ (claude-only)
```

1. Create / clone the repo.
2. Add its path to `~/dotfiles/skills/sources` (one path per line; `~` expands).
3. Run `skills-stow`.

---

## Conflict resolution playbook

`skills-check` reports two kinds of conflict:

**Cross-source duplicate** — same skill name in two source repos' `shared/skills/` (or both targeting the same tool):
- Rename the skill in one source, or
- Move it to `copilot/skills/` or `claude/skills/` so it only targets one tool.

**Target collision** — a real (non-symlink) directory exists at the install path:
- It was probably installed by the tool itself. Adopt it: `skills-adopt <name>`.
- Or move it aside manually: `mv ~/.claude/skills/<name> ~/.claude/skills/<name>.bak`.

---

## Backport flow (skills-adopt)

To bring a tool-installed skill under source control:

```bash
# Preview what would happen:
skills-adopt autoplan --dry-run

# Actually move it (defaults: --from both --scope shared --to first-source):
skills-adopt autoplan

# Scope to Claude-only if it's a Claude-specific skill:
skills-adopt autoplan --scope claude

# Move into a specific source repo:
skills-adopt autoplan --to ~/git/work/skills --scope shared
```

`skills-adopt` will:
1. Find the real (non-symlink) skill directory in the target(s).
2. Move it into `<source>/<scope>/skills/<name>` (via `git mv` if inside a git repo).
3. Run `skills-stow` to recreate symlinks.
4. Print a suggested `git commit` command.

---

## Sources file format

```
# Comments and blank lines are ignored.
~/git/personal/skills
~/git/work/skills
/absolute/path/also/works
```

---

## Stow package → target mapping

| Package | Target (copilot) | Target (claude) |
|---|---|---|
| `shared` | `~/.copilot` | `~/.claude` (INDEX.md and README.md excluded) |
| `copilot` | `~/.copilot` | — |
| `claude` | — | `~/.claude` |
