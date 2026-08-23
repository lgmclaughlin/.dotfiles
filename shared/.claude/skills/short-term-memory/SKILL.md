# Short-Term Memory

Save working context to a single `short-term.md` file in the project memory directory so it survives compaction. This file is wiped and rewritten each time, not appended to.

The user may provide specific details to save, or may invoke this without args to have Claude capture the current working state.

## Steps

### 1. Locate the memory directory

Find the project memory directory at `~/.claude/projects/<project-key>/memory/`. The project key is derived from the current working directory path (slashes replaced with dashes). If the directory does not exist, create it.

### 2. Read existing short-term.md (if present)

Check if `short-term.md` already exists. If it does, read it to understand what was previously saved. Do not preserve old content by default. Only carry forward information that is still relevant to the current working context.

### 3. Gather context

If the user provided specific details, use those. Otherwise, distill the current conversation into the most operationally useful information:

- **What is being worked on**: the current task, goal, or investigation
- **Key files and paths**: specific files being edited, referenced, or created
- **Commands and tools**: any commands, credentials flows, API calls, or tool invocations needed to continue the work
- **Current state**: what's done, what's in progress, what's next
- **Decisions made**: choices or approaches that were decided on and why
- **Blockers or gotchas**: anything that caused problems or needs to be watched for

### 4. Write short-term.md

Wipe the file and write the new content. Use a flat, scannable format. No frontmatter. Keep it concise but include enough detail that Claude can pick up exactly where it left off after compaction.

Structure:

```
# Short-Term Context

## Current Task
(one-line summary)

## Working State
(what's done, what's in progress)

## Key Files
(paths and what they're for)

## Commands & Processes
(exact commands, credentials flows, build steps, etc.)

## Decisions
(choices made and brief rationale)

## Next Steps
(what to do next, in order)

## Gotchas
(anything that caused issues or needs watching)
```

Omit any section that has nothing to say. Do not pad with generic filler.

### 5. Ensure MEMORY.md index exists

Check if `MEMORY.md` exists in the memory directory. If it does, ensure it has a line referencing `short-term.md`. If not, create `MEMORY.md` with the reference. The reference line should be:

```
- [Short-term context](short-term.md) - current working state, survives compaction
```

This line is permanent and should never be removed by cleanup skills.

### 6. Confirm

Tell the user what was saved in one or two sentences.
