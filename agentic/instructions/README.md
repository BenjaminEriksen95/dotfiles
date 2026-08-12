# instructions — XML instruction compiler

Single source of truth for AI tool system prompts. One `base.xml` compiles to
platform-specific markdown for every supported tool.

## Files

| File | Description |
|------|-------------|
| `base.xml` | The canonical source of all instruction content |
| `README.md` | This file |

## Compilation

`instructions-build` (in `bin/`) reads `base.xml` and writes:

| Platform | Target |
|----------|--------|
| `copilot` | `~/.copilot/copilot-instructions.md` |
| `claude`  | `~/.claude/CLAUDE.md` |

Called automatically by `skills-stow`. Run manually:

```bash
instructions-build            # write both targets (idempotent)
instructions-build --check    # dry-run diff; exit 1 if any target would change
instructions-build --stdout copilot   # print copilot output to stdout
instructions-build --stdout claude    # print claude output to stdout
```

## XML format

`base.xml` uses five compiler tags. All other XML-like tags in the content
(e.g. `<rules>`, `<context>`, `<workflow>`) are treated as opaque text and
passed through verbatim.

### `<head platform="...">`

Rendered once, at the top of the output file. Only the first matching head is
used.

```xml
<head platform="copilot">
# Copilot Instructions
</head>
```

### `<section name="..." platform="...">`

A block of instruction content. Sections are emitted in declaration order,
separated by blank lines.

```xml
<section name="code-rules" platform="all">
<rules>

## Code Changes

- Make **surgical, minimal changes** ...

</rules>
</section>
```

### `<fork platform="...">`

Inline platform switch within a section body. Use when most content is shared
but a few lines differ.

```xml
<fork platform="copilot">task(agent_type="general-purpose", ...)</fork>
<fork platform="claude">Agent({type: "general-purpose", ...})</fork>
```

### `<tail platform="...">`

Like `<head>` but appended at the end. Useful for footers.

### Platform values

| Value | Included in |
|-------|-------------|
| `all` | Both tools |
| `copilot` | Copilot CLI only |
| `claude` | Claude Code only! |

Comma-separated values are also accepted: `platform="copilot,claude"` (same as
`all`).

## Adding/modifying content

1. Edit `base.xml` directly.
2. Run `instructions-build --check` to preview the diff.
3. Run `instructions-build` (or `skills-stow`) to apply.
4. Commit and push.

## Fragment XMLs

Additional `*.xml` files in a skill's root are automatically loaded as fragments
(sections only, no `<head>` or `<tail>` allowed). They are appended after
`base.xml` sections, in lexicographic order per source directory.
