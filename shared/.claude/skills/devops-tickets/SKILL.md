# DevOps Tickets

Generate and create issue tracker tickets from the current phase plan.

## Inputs

Read the following files in order:

1. `.claude/current-phase.md` in the current project - the active phase plan with tasks
2. `.claude/overview.md` in the current project - project overview (used for initiative ticket description)
3. `~/.claude/common/devops/ticket-standard.md` - writing style, constraints, and ticket structure
4. `~/.claude/common/devops/ticket-management.md` - issue tracker tooling and API reference
5. `.devops/tickets.md` in the current project root - project-specific config (project key, epic, repo URL, assignees)

If `.devops/tickets.md` does not exist, stop and tell the user to create one (or run `cframe add --devops` if using cframe).

If `current-phase.md` is empty or has no tasks, stop and tell the user there is nothing to ticket.

## Steps

### 1. Check Epic

Read the current epic key from `.devops/tickets.md`.

If no epic is configured:
- Propose an epic to the user (title and short description) based on the project context
- Keep the description at the capability level: what the system does, not implementation details like vendor names, brand names, schema locations, or current scope. These rot quickly. Prefer durable language that stays accurate as the project evolves. See the Detail Sensitivity section in ticket-standard.md.
- Wait for the user to confirm or adjust
- Create the epic in the issue tracker
- Update `.devops/tickets.md` with the new epic key

### 2. Derive Phase Label

Extract the phase heading from `current-phase.md` (e.g. `## Phase 3: Data Pipeline`).

Build the label: `{PROJECT_KEY}-{phase-name}` in lowercase-dash, dropping the phase number (e.g. `SENS-data-pipeline`).

### 3. Propose Tickets

Analyze the tasks in `current-phase.md` and produce a ticket proposal in markdown. Follow the ticket-standard.md for structure, tone, and constraints.

For each proposed story, include:
- Title
- Description with checklist of granular tasks
- Acceptance criteria
- Dependencies (blocks/blocked by) if any
- Assignee (from `.devops/tickets.md` defaults)

Also note:
- All stories will be linked with `relates to`
- The phase label that will be applied
- The epic they will be linked to

Present the full proposal to the user and wait for edits or approval.

### 4. Create Tickets

After the user confirms:

1. Detect the active sprint (see Sprint Assignment in ticket-management.md). Extract the board ID from the Jira Project URL in `.devops/tickets.md`. Query for the active sprint and capture its ID. If no active sprint is found, proceed without one and note it in the summary.
2. Create each story in the issue tracker, assigning the active sprint via `customfield_10020`
3. Link all stories with `relates to`
4. Apply `blocks` links where dependencies were identified
5. Report the created ticket keys and URLs

### 5. Annotate current-phase.md

After all tickets are created, update `.claude/current-phase.md` to link task groups to their ticket keys. Add the ticket key in parentheses after each task group heading that maps to a created story.

For example, if task group `#### 3. Update NK themes node` maps to `SCALE-29`, update the heading to:

```
#### 3. Update NK themes node (SCALE-29)
```

This creates a two-way link: the ticket description contains the granular checklist, and the phase plan references the ticket key. During execution, use these annotations to transition tickets (see Lifecycle in ticket-standard.md).

### 6. Summary

Print a summary:
- Stories created (with keys and URLs)
- Epic linked to
- Phase label applied
- Dependencies set up
- Task groups annotated in current-phase.md
