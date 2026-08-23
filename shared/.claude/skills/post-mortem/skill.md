---
description: Write a structured post-mortem for a production issue, saved to .claude/prod-issues/
---

## Write a Production Post-Mortem

Investigate the production issue discussed in the current conversation, then produce a detailed post-mortem document.

### Steps

1. **Read the standard.** Load `~/.claude/common/post-mortem-standard.md` for the required sections, detail level, and style rules.

2. **Gather context from the conversation.** Identify: what broke, when it was noticed, what the symptoms were, how the root cause was found, what the fix was, and any red herrings encountered along the way. If details are unclear or missing, ask before writing.

3. **Create the file.** Save to `.claude/prod-issues/YYYYMMDD_descriptive-title.md` using today's date. The title should be kebab-case, concise, and name the actual failure (e.g., `classifier-import-break`, `stale-cache-after-deploy`, `missing-env-var`). Create the `prod-issues/` directory if it does not exist.

4. **Write the post-mortem.** Follow every section and rule defined in the standard. All sections are mandatory.
