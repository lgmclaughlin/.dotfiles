# Sprint Planning

Break a design spec into high-level sprint tickets for refinement before bulk Jira creation. Run after the shared inputs and Check Epic step in SKILL.md.

## Additional inputs

- The design spec at the path passed as the skill argument

If the design spec file does not exist or is empty, stop and tell the user.

## Steps

### 2. Analyze the Design Spec

Read the full design spec. Identify all major deliverables, components, and work streams. Look for:

- Database changes (schemas, migrations, seed data)
- Backend services and APIs
- Frontend pages and components
- Cross-cutting concerns (auth, visibility, permissions)
- External system changes
- Infrastructure additions

### 3. Group into Tickets

Break the spec into tickets grouped by related work. Each ticket should represent a coherent unit of work.

Grouping rules:
- Each ticket must be between 3 and 16 hours. If a grouping comes in under 3 hours, combine it with a related ticket. If over 16 hours, split it.
- Group by functional area, not by layer. "Build peer review flow" is better than "Add peer review API endpoints" + "Add peer review frontend."
- Shared infrastructure and engines should be their own tickets when multiple features depend on them.
- Cross-cutting concerns (visibility, permissions, anonymity) deserve their own ticket when they touch multiple features.
- External system changes (different repos, services) are always separate tickets.

### 4. Write Ticket Summaries

Each ticket gets a title and a brief summary paragraph. No checklists, no acceptance criteria, no subtasks. Those get filled in later when the phase is defined.

#### Title format
- Imperative voice: "Build X", "Create Y", "Implement Z", "Expand W"
- Under 60 characters
- Specific enough to distinguish from other tickets

#### Summary format
- 2-4 sentences of plain prose
- Describe WHAT gets built and the key deliverables
- Include specific technical decisions that are already locked in (e.g., "S3 upload with presigned URLs", "Gemini 2.5 Flash for classification")
- Include scope boundaries when helpful (e.g., "read-only for MVP, no editor")
- Do NOT include acceptance criteria, checklists, or implementation steps
- Do NOT reference other tickets by number (numbers don't exist yet)

#### Example summaries

Good:
```
Core backend for all review flows. Session CRUD (create, retrieve, resume, submit),
response auto-save per question, progress tracking (answered count vs total), question
retrieval by set. All four review types share this engine. Includes API endpoints for
session lifecycle and response persistence.
```

Good:
```
Admin page for managing peer review assignments. Target 2 reviews per employee, support
1-3 range. Assignment creation, editing, and deletion. Employee selector filtered to
active, enrolled employees. Display assignment status (pending, in progress, complete).
API endpoints for assignment CRUD and status tracking.
```

Bad (too vague):
```
Build the peer review feature.
```

Bad (too detailed, has implementation steps):
```
Build the peer review feature:
- Create PeerReviewSession model in models.py
- Add POST /api/review/peer endpoint
- Wire up React component at /reviews/peer/:id
- Add unit tests for anonymity filtering
```

### 5. Identify Dependencies

Identify hard ordering requirements between tickets:
- Schema/migration tickets typically block everything else
- Shared engines block the features that consume them
- Shared UI components block the pages that use them
- Assignment systems block the flows that depend on assignments

Note which tickets can proceed in parallel.

### 6. Estimate Hours

Assign hour estimates to each ticket. These estimates assume AI-assisted development. Every ticket must fall between 3 and 16 hours.

Guidelines:
- Database migrations and seed data: 3-4h
- Backend API/engine work: 4-8h
- Frontend pages with custom UX: 8-16h
- End-to-end flows (backend + frontend + notifications): 4-10h
- Cross-cutting concerns: 4-8h
- External system changes (small scope): combine with related work if under 3h

### 7. Write the Planning Doc

Write the output to `.claude/[project-name]-sprint-tickets.md` relative to the project directory. Derive the project name from the epic name in `.devops/tickets.md` (lowercase, hyphenated).

Format:

```markdown
# [Project Name] Sprint Planning

Epic: [EPIC-KEY] ([Epic Name])

## 1. Ticket title

**Estimate:** Xh

Summary paragraph here.

## 2. Next ticket title

**Estimate:** Xh

Summary paragraph here.

...

---

**Total estimate:** XXh

### Dependency notes

- Ticket N (short name) blocks tickets X, Y, Z
- Ticket N (short name) and ticket M (short name) can proceed in parallel
- Ticket N (short name) is independent, can be done at any time
```

### 8. Present for Refinement

Show the user:
- The full planning doc content
- Total hour estimate
- A note that this is for refinement before Jira creation

Wait for the user to review and make edits. The user may adjust estimates, rename tickets, merge or split items, or rewrite summaries. They may edit the file directly on disk.

### 9. Create Tickets in Jira

Only after the user confirms (says to create, add to Jira, etc.):

1. Read the planning doc from disk (it may have been edited since step 7)
2. Detect the target sprint. Ask the user which sprint to assign, or default to the next future sprint. Use JQL `project = {PROJECT_KEY} AND sprint in futureSprints()` to find available sprints, or `sprint in openSprints()` for the active one.
3. Resolve the assignee account ID from `.devops/tickets.md`
4. Create each story in the issue tracker:
   - Use MCP `createJiraIssue` when available, REST API as fallback
   - Link to epic via `parent` field
   - Set `customfield_10016` (story points/hours) to the estimate
   - Sprint assignment via MCP requires a separate `editJiraIssue` call with `customfield_10020` set to the sprint ID as a plain number (not an object, not an array)
5. Apply `Blocks` links where dependencies were identified
6. Apply `Relates` links for cross-cutting connections (visibility <-> flows it touches, admin pages <-> related features, external changes <-> features that need them)
7. Do NOT apply exhaustive relates links between every pair. Link only tickets with meaningful cross-references.

### 10. Update Planning Doc

After tickets are created, update the planning doc headings to include ticket keys:

```markdown
## 1. Ticket title (SCALE-237)
```

### 11. Summary

Print a summary table:
- Ticket number, key, title, and estimate for each story
- Total hours
- Sprint assigned
- Epic linked to
- Blocking dependencies set
- Relates links set
