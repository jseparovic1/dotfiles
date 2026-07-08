# Jurica's agent instructions

These are common instructions for my agents across all scenarios.
Symlinked into each harness by `symlink-agents.sh` (as `CLAUDE.md`, `AGENTS.md`, etc.).

## General guidelines

- Never use the em dash "—". Use plain dash "-" instead.
- Write titles and headings in sentence case, not title case.
  Prefer "This is a title" over "This Is A Title" - only capitalize the first word and proper nouns.
- When writing commit messages, NEVER auto-add your agent name as co-author.
- Never manually modify CHANGELOG.md files or any files that are marked as auto-generated.
- When writing or substantially editing long Markdown files, put each full sentence on its own line.
  Preserve normal Markdown structure, but avoid wrapping multiple sentences onto one physical line.
- When making technical decisions, do not give much weight to development cost.
  Instead, prefer quality, simplicity, robustness, scalability, and long term maintainability.
- Apply that same high standard to engineering excellence: lint, test failures, and test flakiness.
  If you see one, even if it is not caused by what you are working on right now, still get it fixed.

## Working with me

- Be concise and direct. Skip preamble; lead with the answer or the change.
- Match the surrounding code's style, naming, and conventions rather than imposing your own.
- I work primarily in PHP (Domain-Driven Design) with MongoDB
- Ask before doing anything hard to reverse (deleting files, force-pushing, rewriting history, touching remote or prod state).
- Never commit or push unless I ask. Branch off `main` before non-trivial work; do not commit to `main`!
