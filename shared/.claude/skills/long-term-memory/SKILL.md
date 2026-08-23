# Long-Term Memory

Save durable project knowledge to the memory system. The user will supply what they want remembered. This skill writes individual memory files that persist across sessions, not just compaction.

Only save information that will remain true for weeks or longer. If the detail is about current working state, use `/short-term-memory` instead.

## Good candidates for long-term memory

- Project conventions and patterns (naming, file layout, architecture decisions)
- Deploy processes and infrastructure details
- Credentials flows and how to access services
- Tool usage (CLI commands, scripts, build systems)
- User preferences and working style
- Team structure, ownership, and project goals
- External system locations (dashboards, ticket trackers, docs)

## Bad candidates (use short-term-memory instead)

- Current debugging state or investigation progress
- Files being actively edited right now
- Temporary workarounds that will be removed soon
- Task lists or in-progress checklists

## Steps

### 1. Understand what to save

Read the user's request. If they provided specific details, use those directly. If they gave a general topic ("remember the deploy steps"), gather the relevant details from the conversation context.

### 2. Check for existing memories

Read `MEMORY.md` in the project memory directory (`~/.claude/projects/<project-key>/memory/`). Check if a memory on this topic already exists. If so, read the existing file and update it rather than creating a duplicate.

### 3. Write the memory file

Create or update a memory file using the standard format:

```markdown
---
name: short-kebab-case-slug
description: one-line summary specific enough to judge relevance later
metadata:
  type: (user | feedback | project | reference)
---

(memory content)
```

Choose the type that fits:
- **user**: about the person (role, preferences, expertise)
- **feedback**: guidance on how Claude should work (corrections, confirmed approaches)
- **project**: ongoing work, goals, decisions, team context
- **reference**: pointers to external systems (dashboards, ticket trackers, docs)

Use `[[other-memory-name]]` links to connect related memories.

### 4. Update MEMORY.md

Add or update a one-line entry in `MEMORY.md` pointing to the file. Keep entries under 150 characters. Do not write memory content directly into `MEMORY.md`.

When adding entries, place them in a logical position near related memories rather than always appending to the bottom.

### 5. Confirm

Tell the user what was saved and where, in one sentence.
