# Clean Stale Memories

Audit all memory files for the current project. Remove stale information, clarify ambiguous entries, consolidate redundant files, and verify that referenced paths and resources still exist.

## Steps

### 1. Read the memory index

Read `MEMORY.md` from the project memory directory (`~/.claude/projects/<project-key>/memory/`). If it does not exist or is empty, report that there are no memories to audit and stop.

### 2. Read all memory files

Read every file referenced in `MEMORY.md`. Also scan the memory directory for any orphaned files not listed in the index.

### 3. Verify each memory

For each memory file, check:

- **Path references**: if the memory mentions specific file paths, verify they still exist. Flag any that don't.
- **Function/symbol references**: if the memory names specific functions, classes, or config keys, grep for them. Flag any that are missing.
- **Command references**: if the memory includes CLI commands or tool invocations, check that the tools are still installed or the scripts still exist where referenced.
- **Temporal relevance**: if the memory describes a decision, initiative, or project state, assess whether it reads as current or historical. Deadlines in the past, completed migrations, and resolved incidents are candidates for removal.
- **Redundancy**: if two memories cover the same topic, consolidate into one and delete the other.

### 4. Handle short-term.md

If `short-term.md` exists, read it. If its content clearly relates to work that is no longer active (different task, old dates, files that have since changed), wipe it. Do not delete the file itself or its entry in `MEMORY.md`, just clear its content.

### 5. Propose changes

Before making any changes, present a summary to the user:

- **Delete**: memories that are clearly stale or redundant (explain why for each)
- **Update**: memories with partially stale content (show what would change)
- **Keep**: memories that are still valid
- **Clarify**: memories where staleness is ambiguous (ask the user)

Wait for user confirmation before proceeding with deletions or updates.

### 6. Apply changes

Delete confirmed stale files, update confirmed partial edits, consolidate confirmed redundancies. Update `MEMORY.md` to reflect all changes (remove deleted entries, update descriptions if content changed).

Do not remove the `short-term.md` entry from `MEMORY.md` even if the file was wiped.

### 7. Report

Summarize what was done: files deleted, files updated, files kept, and any entries the user should revisit later.
