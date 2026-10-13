# Ticket Writing Standard

## Tone and Style

- Write tickets as clear, actionable work items
- Use direct language, no filler or preamble
- Titles should be imperative: "Build X", "Set up Y", "Add Z"
- Keep titles under 80 characters
- Descriptions should be scannable, not prose-heavy

## Ticket Hierarchy

Two levels only:

- **Initiative ticket**: represents the project or large body of work. Title format is capitalize case project name (e.g. "Sentiment Tracking", "Fraud Detection"). One per project/initiative, managed manually or created by the skill when missing. Description should contain a high-level summary of the project derived from `.claude/overview.md` (what the project is and why it exists, not granular features) and a link to the repository (derive the URL from `git remote get-url origin`).
- **Work item**: an individual, assignable unit of work linked to an initiative. Contains a checklist of granular tasks in its description rather than spawning child tickets.

See `ticket-management.md` for how these map to the issue tracker's type system.

## Detail Sensitivity

Initiative ticket descriptions must be detail-agnostic: describe what the system does at a capability level, not how it's currently implemented. Avoid naming specific vendors, specific customers or brands, specific schemas or paths, or current-state scoping. These details change frequently and make the summary stale. Only include a specific name if the project is truly scoped to that element by design, not just because it's the only integration in an early stage.

Work item descriptions are less strict: stories are shorter-lived, so referencing a specific table, API, or vendor is acceptable when it's the direct target of the work.

## Work Item Structure

Each work item should contain:

### Title
Short imperative summary of the work.

### Description
- One or two sentences of context: what this achieves and why it matters
- A bullet point list of concrete deliverables or subtasks (derived from granular tasks in the plan). Use plain bullets (`-`), not checkboxes (`- [ ]`).
- Any relevant technical notes or constraints

### Time Estimate
- Each work item should represent roughly 3-4 hours of work. Smaller tickets become too granular, larger ones are hard to split across sprint days.
- These tickets are executed with AI-assisted development. Estimate for that workflow, not for a human writing every line manually.
- If a task group is under 2 hours, combine it with a related group. If it's over 5 hours, split it into separate items.
- Exception: tasks that involve significant manual work (UI design iteration, setting up external tools without APIs, manual testing workflows, etc.) may exceed the 3-4 hour target since AI assistance has less impact on those.

### Acceptance Criteria
- Verifiable conditions that define "done"
- Prefer observable outcomes over process steps ("dashboard loads in under 3s" not "optimize queries")

## Constraints

- **Maximum work items per batch**: 15. If a phase has more than 15 high-level tasks, group related work into fewer items with richer descriptions.
- **No child tickets**: granular work goes into the work item description as a checklist, not as nested tickets.
- **Initiative required**: work items must link to an initiative ticket. If none is configured in `.devops/tickets.md`, propose one (title, description) to the user and get confirmation before proceeding. Once confirmed, create the initiative ticket first and update `.devops/tickets.md` with its key.

## Dependencies

When proposing tickets, identify dependencies between work items:

- Use `blocks / is blocked by` for hard ordering requirements (B cannot start until A is done)
- Use `relates to` between all work items in the same batch (they share context)
- Do not mention dependencies in ticket descriptions. Let the issue links speak for themselves. Descriptions should only contain work-related content.

## Labels

- Each work item gets a phase label in the format `{PROJECT_KEY}-{EPIC_NUMBER}-{phase-name}` (lowercase-dash)
- The phase name is derived from the heading in `current-phase.md` (e.g. epic `SCALE-42` + `## Phase 3: Data Pipeline` becomes `SCALE-42-data-pipeline`)
- Additional labels may be specified in the project's `.devops/tickets.md`

## Lifecycle

1. Work items are created in the backlog
2. Phase label groups them for filtering
3. Items are picked up, worked, and closed individually
4. When all items for a phase label are closed, the phase is complete

### Tracking during execution

When `.claude/current-phase.md` exists and task groups have been annotated with ticket keys (e.g. `#### 3. Update NK themes node (SCALE-29)`), use those annotations to keep ticket status in sync with actual work:

- **Starting work** on a task group: transition its ticket to In Progress
- **Completing** all tasks in a task group: transition its ticket to Done
- Check off tasks in `current-phase.md` as they are completed

This keeps the issue tracker current without requiring manual status updates. The ticket key in the heading is the signal to manage transitions automatically.
