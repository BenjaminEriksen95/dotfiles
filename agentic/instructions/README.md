# instructions — XML instruction compiler

Single source of truth for the agent system prompt. One `base.xml` compiles
to `~/.omp/agent/AGENTS.md`. The compiler still supports multiple platforms
(head/section/fork tags carry a `platform` attribute) in case another AI tool
needs a divergent copy later; today only `omp` is wired up.

## Files

| File | Description |
|------|-------------|
| `base.xml` | The canonical source of all instruction content |
| `README.md` | This file |

## Compilation

`instructions-build` (in `bin/`) reads `base.xml` and writes:

| Platform | Target |
|----------|--------|
| `omp` | `~/.omp/agent/AGENTS.md` |

Called automatically by `skills-stow`. Run manually:

```bash
instructions-build              # write the target (idempotent)
instructions-build --check      # dry-run diff; exit 1 if the target would change
instructions-build --stdout omp # print compiled output to stdout
```

## XML format

`base.xml` uses five compiler tags. All other XML-like tags in the content
(e.g. `<rules>`, `<context>`, `<workflow>`) are treated as opaque text and
passed through verbatim.

### `<head platform="...">`

Rendered once, at the top of the output file. Only the first matching head is
used.

```xml
<head platform="omp">
# Agent Instructions
</head>
```

### `<section name="..." platform="...">`

A block of instruction content. Sections are emitted in declaration order,
separated by blank lines.

```xml
<section name="code-rules" platform="omp">
<rules>

## Code Changes

- Make **surgical, minimal changes** ...

</rules>
</section>
```

### `<fork platform="...">`

Inline platform switch within a section body. Use when most content is shared
but a few lines differ across platforms.

```xml
<fork platform="omp">task(...)</fork>
<fork platform="other-tool">Agent({...})</fork>
```

### `<tail platform="...">`

Like `<head>` but appended at the end. Useful for footers.

### Platform values

| Value | Included in |
|-------|-------------|
| `all` | Every wired-up platform (currently just `omp`) |
| `omp` | OMP only |

Comma-separated values are also accepted: `platform="omp,other-tool"` (same
effect as `all` while only `omp` is wired up).

## Adding/modifying content

1. Edit `base.xml` directly.
2. Run `instructions-build --check` to preview the diff.
3. Run `instructions-build` (or `skills-stow`) to apply.
4. Commit and push.

## Fragment XMLs

Additional `*.xml` files in a skill's root are automatically loaded as fragments
(sections only, no `<head>` or `<tail>` allowed). They are appended after
`base.xml` sections, in lexicographic order per source directory.
