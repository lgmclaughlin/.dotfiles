# Ticket Management

## Issue Tracker

Jira Cloud is the issue tracker for engineering projects.

- **Instance**: https://scale-engineering.atlassian.net/
- **Auth**: assume environment variables `JIRA_URL`, `JIRA_EMAIL`, and `JIRA_API_TOKEN` are set

## Type Mapping

The ticket standard defines generic ticket types. In Jira, they map to:

- **Initiative ticket** -> Epic
- **Work item** -> Story

## Available Tools

### Jira MCP Server (preferred when available)

If the Jira MCP server is connected, use its tools directly for creating and managing tickets. Check for available `mcp__jira__*` tools via ToolSearch.

### REST API (fallback)

When MCP is unavailable, use the Jira REST API via curl:

```bash
curl -s -u "$JIRA_EMAIL:$JIRA_API_TOKEN" \
  -H "Content-Type: application/json" \
  "$JIRA_URL/rest/api/3/issue" \
  -d '{ ... }'
```

Key endpoints:
- `POST /rest/api/3/issue` - create an issue
- `GET /rest/api/3/issue/{key}` - get issue details
- `PUT /rest/api/3/issue/{key}` - update an issue
- `POST /rest/api/3/issueLink` - link two issues
- `GET /rest/api/3/project/{key}` - get project details
- `GET /rest/api/3/search?jql={query}` - search issues

### Description Format

#### MCP (preferred)

When using the Jira MCP tools, set `contentFormat: "markdown"` and write descriptions in standard markdown. URLs must use markdown link syntax to render as clickable links: `[display text](url)`. A bare URL will render as plain text, not a link.

When including a repository link or other URL reference, put it on its own line separated by a blank line from the body text:

```markdown
Description body text here.

Repository:
[github.com/org/repo](https://github.com/org/repo)
```

#### REST API (ADF)

When using the REST API fallback, use Atlassian Document Format (ADF) for descriptions. Use ADF marks for links:

```json
{"type": "text", "text": "display text", "marks": [{"type": "link", "attrs": {"href": "URL"}}]}
```

When including a repository link or other URL reference, put it on its own line:

```json
{"type": "paragraph", "content": [{"type": "text", "text": "Repository:"}]},
{"type": "paragraph", "content": [{"type": "text", "text": "https://github.com/org/repo", "marks": [{"type": "link", "attrs": {"href": "https://github.com/org/repo"}}]}]}
```

### Creating an Epic (initiative ticket)

```json
{
  "fields": {
    "project": { "key": "PROJECT_KEY" },
    "summary": "Epic title",
    "description": { "type": "doc", "version": 1, "content": [...] },
    "issuetype": { "name": "Epic" }
  }
}
```

### Creating a Story (work item) linked to an Epic

```json
{
  "fields": {
    "project": { "key": "PROJECT_KEY" },
    "summary": "Story title",
    "description": { "type": "doc", "version": 1, "content": [...] },
    "issuetype": { "name": "Story" },
    "parent": { "key": "EPIC_KEY" },
    "labels": ["project-phase-name"]
  }
}
```

### Time Estimates

The "Story point estimate" field (`customfield_10016`, type: number) is used as estimated hours, per team convention. Set it on every story at creation time with the numeric hours value from the time estimate in ticket-standard.md (e.g. `2` for a 2h estimate, `0.5` for 30 minutes).

When using MCP, pass `customfield_10016` as an additional field. When using REST API:

```json
{
  "fields": {
    ...
    "customfield_10016": 2
  }
}
```

### Linking Issues

```json
{
  "type": { "name": "Blocks" },
  "inwardIssue": { "key": "STORY-1" },
  "outwardIssue": { "key": "STORY-2" }
}
```

Link type names:
- `"Blocks"` (inward blocks outward)
- `"Relates"` (bidirectional)

## Sprint Assignment

New work items should be assigned to the currently active sprint at creation time.

### Detection

Query the active sprint for the board. Use MCP or REST:

- **MCP**: search with JQL `project = {PROJECT_KEY} AND sprint in openSprints()` and extract the sprint from the first result's `customfield_10020` field. Or use the `fetch` tool to call the agile endpoint directly.
- **REST API**: `GET /rest/agile/1.0/board/{boardId}/sprint?state=active`

The board ID is derived from the Jira Project URL in `.devops/tickets.md` (the number after `/boards/`).

### Applying

The sprint field is `customfield_10020`. When creating a story, include:

```json
{
  "fields": {
    ...
    "customfield_10020": { "id": SPRINT_ID }
  }
}
```

When using MCP with `createJiraIssue`, pass `customfield_10020` as an additional field.

If sprint detection fails (no active sprint, API error), create the tickets without a sprint and note it in the summary.

## Operations

### Assignee Resolution

The default assignee email is in `.devops/tickets.md`. If an account ID is already present (in parentheses after the email), use it directly. Otherwise, look up the account ID via `lookupJiraAccountId` (MCP) or the REST API, then save it back to `tickets.md` so future runs skip the lookup.

Always pass the assignee when creating tickets. Use `assignee_account_id` (MCP) or `"assignee": {"accountId": "..."}` (REST API).

### Before Creating Tickets

1. If no initiative ticket is configured, propose and create one first

### Creating a Batch

1. Create all work items sequentially (need keys for linking)
2. Apply `relates to` links between all items in the batch
3. Apply `blocks` links where dependencies were identified
4. Report created ticket keys and URLs

### Error Handling

- If auth fails, check that `JIRA_URL`, `JIRA_EMAIL`, and `JIRA_API_TOKEN` are set and non-empty. If any are missing, tell the user to source their shell config (`source ~/.bashrc`)
- If the project key is invalid, prompt the user to check `.devops/tickets.md`
- If an issue creation fails, report the error and continue with remaining items
