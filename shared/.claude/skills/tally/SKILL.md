---
description: Summarize git commits, manual tasks, and inferred achievements across all projects for a date range, formatted for a weekly Tally check-in.
---

## Summarize weekly work for Tally check-in

**Arguments:** `[Start Date] - [End Date]` (e.g. `Jun 13 - Jun 19`, `2026-06-13 - 2026-06-19`)

Parse the start and end dates from the arguments. Infer the year from the current date if not provided. Convert to ISO format (YYYY-MM-DD) for git commands.

### 1. Understand the Tally format

Read the Tally project README and documentation to understand what Tally is and how check-ins work:

- `~/projects/tally/README.md`
- All files in `~/projects/tally/docs/`

Use this context to inform the tone and structure of the summary. Tally check-ins are project-based, capturing meaningful work, progress, and achievements.

### 2. Collect git history

Scan every subdirectory under `~/Documents/projects/` and `~/projects/` for git repositories. For each repo, run:

```
git log --after="[day before start]" --before="[day after end]" --format="%h %ad %s" --date=short
```

Do NOT filter by author. Collect results from all repos that have commits in the range.

**Important:** Verify commit dates fall within the requested range. Git's `--after`/`--before` flags can include boundary commits due to timezone offsets. Exclude any commits whose displayed date falls outside the requested range.

### 3. Read the manual task list

Read `~/Documents/projects/.priority/manual.md`. This file contains:

- A **Projects** section with per-project deadlines and upcoming tasks
- A **Plan** section with day-by-day tasks and checkboxes (`[x]` = done, `[ ]` = not done)

Extract all checked-off (`[x]`) tasks whose dates fall within the requested range. Also note any unchecked tasks for context.

### 4. Build three output sections

The output has three sections: **Git**, **Management**, and **Inferred**. Each section uses the same per-project layout. Projects can appear in multiple sections.

---

#### Section 1: Git

Summarize the git commits grouped by project.

- **Every project** with commits in the range gets its own entry. Use the project directory name as the heading.
- Order projects by volume of work (most commits first).
- Within each project, group related commits into concise bullet points. Combine commits that are part of the same feature or effort into a single bullet.
- **Smooth the language for a stakeholder audience.** Describe the impact of changes from the perspective of an end user or decision-maker, not the implementation details. For example: "Added holiday awareness so employees are not prompted on company holidays" rather than "Add holidays table and skip check-ins if a holiday, only say Happy Friday if it's Friday." Technical detail is fine when it is the impact (e.g. infrastructure, deploy pipeline changes), but default to plainer terms.
- Include meaningful detail about what was built, fixed, or improved. Do not flatten important work into vague summaries.
- For projects with only 1-2 minor commits, a single bullet is fine.

#### Section 2: Management

Surface completed tasks from `manual.md` that are NOT already covered by the Git section. This section captures work that does not produce code: meetings, communications, submissions, coordination, planning, and preparation.

- Only include `[x]` (checked-off) tasks from the Plan section whose dates fall within the requested range.
- Cross-reference each checked task against the Git section. If a manual task is clearly the same work as a git bullet (e.g. "Finish OneLogin integration" matches git commits about OneLogin), skip it here.
- What remains are management, coordination, and non-code tasks. Group them by project when a project is identifiable, or under a "General" heading if not.
- Write each bullet as a completed action: "Submitted external spend request for Otterly.ai", not "Submit external spend request."
- Also include unchecked tasks from dates within the range, clearly marked as incomplete, only if they seem important enough to note as carryover.

#### Section 3: Inferred

This section is used sparingly. It suggests big-picture goals and achievements, whether tied to a specific project or cross-cutting. These are suggestions for the user to accept, edit, or discard.

Look across the Git and Management sections for patterns that suggest:

- **Milestones reached**: a project going from zero to deployed, a major feature shipping, a first PR merged
- **Goals met**: completing a hackathon project, finishing a planned integration, hitting a deadline
- **Cross-project themes**: a week heavily focused on reliability/monitoring, a push to ship multiple projects, ramping up a new initiative

Write these as 2-5 short suggestions, each prefixed with "(Suggested)" so the user knows they are proposals. Keep them high-level, one sentence each. If nothing meaningful can be inferred beyond what the other sections already say, output "No suggestions this week." and move on.

---

### Output format

```
## Git

**[Project Name]**
- [Stakeholder-friendly description of work]
- ...

**[Project Name]**
- ...

## Management

**[Project Name]**
- [Completed non-code task]
- ...

**General**
- ...

## Inferred

- (Suggested) [Big-picture goal or achievement]
- ...
```

No preamble or closing remarks. Just the three sections.
