# Post-Mortem Standard

This document defines the required structure, sections, and detail level for production post-mortem documents.

## Goal

A document that a future engineer with no conversation context can read and fully understand: what happened, how it was debugged, and how it was fixed.

## Required Sections

Every section below is mandatory. Do not omit any, even if the content is "None."

---

### `# YYYY-MM-DD: Title`

One-line heading with the date and a human-readable title describing the incident.

---

### `## Symptoms`

What users or systems experienced. Be specific:
- Which feature or endpoint was affected
- What the user saw (error message, loading state, silent failure)
- Timestamps from logs if available
- How many users or systems were impacted

Do not explain the cause here. Describe only what was observable before any investigation.

---

### `## Root Cause`

The technical explanation of why the failure happened. This should include:
- The exact chain of events that led to the failure
- Which specific file, config, or infrastructure component was wrong and why
- What triggered the issue (a deploy, a config change, a timing condition)
- Why it wasn't caught earlier (if relevant)

If there were multiple issues (related or unrelated), give each its own subsection with a clear heading. State explicitly whether issues are related or independent.

---

### `## Troubleshooting Steps`

A numbered, chronological walkthrough of the debugging process. For each step:
- What you checked and why
- The **exact command** you ran (formatted as a code block)
- What the result was and what it told you
- What it ruled in or out

This section should be detailed enough that someone could reproduce the investigation. Include both the steps that found the answer and the steps that ruled out wrong theories. Label dead ends clearly so future readers don't repeat them.

---

### `## Red Herrings`

Any issues that initially appeared related but turned out to be separate, or any investigation paths that looked promising but led nowhere. For each:
- What it looked like and why it seemed connected
- What investigation proved it was unrelated
- What the actual explanation was (if known)

If there were no red herrings, include the section with "None." Do not omit it.

---

### `## Fix Applied`

What was changed to resolve the issue. For each fix:
- What was modified (file paths, config, infrastructure)
- The specific change (show the diff, the command, or describe the edit)
- The exact deploy/publish command used
- How the fix was verified
- Whether the fix is deployed or pending deploy

Separate immediate hotfixes from longer-term code changes. If a fix addresses a symptom but not the root cause, say so.

---

### `## Confirmed Safe`

A checklist of things verified after the fix to confirm no collateral damage:
- Services or rules that should NOT have been affected (and were confirmed unaffected)
- Related systems checked for side effects
- Any manual state (disabled rules, pinned versions) that must remain as-is

---

### `## Lessons`

Numbered takeaways. Each should be:
- A concrete observation about what went wrong in the process, tooling, or architecture
- Actionable: it should point toward a specific improvement, not just "be more careful"
- Scoped: don't generalize beyond what this incident actually revealed

Good example: "The deploy script doesn't scope terraform apply per-env, so a dev-only change republished the shared Lambda layer to prod."
Bad example: "We should test more."

---

## Style Rules

- Use colons, commas, or rephrasing instead of em dashes
- Include timestamps in UTC or local with timezone noted
- Use fenced code blocks for all commands, SQL, and log output
- Keep the tone factual and direct: no hedging, no filler
- Reference file paths relative to the repo root
