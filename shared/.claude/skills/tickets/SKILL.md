---
description: Create issue tracker tickets from the current phase plan, or break a design spec into sprint tickets for refinement. Pass a design spec path for sprint planning; pass nothing for phase tickets.
argument-hint: "[design spec path]"
---

# Tickets

Create issue tracker tickets in one of two modes:

| Mode | When | Steps |
|---|---|---|
| Phase tickets | No argument | [references/phase-tickets.md](references/phase-tickets.md) |
| Sprint planning | A design spec path is passed as the argument | [references/sprint-planning.md](references/sprint-planning.md) |

## Inputs

Read the following files in order:

1. [references/ticket-standard.md](references/ticket-standard.md): writing style, constraints, and ticket structure
2. [references/ticket-management.md](references/ticket-management.md): issue tracker tooling and API reference
3. `.devops/tickets.md` in the current project root: project-specific config (project key, epic, repo URL, assignees)

If `.devops/tickets.md` does not exist, stop and tell the user to create one (or run `cframe add --devops` if using cframe).

Then read the steps file for the selected mode and its additional inputs.

## Steps

### 1. Check Epic

Read the current epic key from `.devops/tickets.md`.

If no epic is configured:
- Propose an epic to the user (title and short description) based on the project context
- Keep the description at the capability level: what the system does, not implementation details like vendor names, brand names, schema locations, or current scope. These rot quickly. Prefer durable language that stays accurate as the project evolves. See the Detail Sensitivity section in ticket-standard.md.
- Wait for the user to confirm or adjust
- Create the epic in the issue tracker
- Update `.devops/tickets.md` with the new epic key

### 2 onward

Continue with the steps in the selected mode's steps file.
