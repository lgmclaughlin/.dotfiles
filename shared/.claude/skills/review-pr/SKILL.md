---
description: Review a PR for the soundness of its approach against the repo's engineering standards, pointing out where principles weren't upheld or the change is overengineered
argument-hint: "[PR number, URL or branch; defaults to the current branch's PR]"
---

# Review a PR

Review the approach a PR takes, not its style. The question is whether the change is sound and keeps the repo organized and maintainable. Input: $ARGUMENTS

This is not a bug hunt. For correctness bugs, the user can run `/code-review` separately.

## Stance

People work differently, and that's part of collaborating. A different way of doing something is not a finding. Raise something only when it affects how the repo holds together over time: where logic lives, how much there is of it, and how easy it will be to change or delete later.

- Judge the PR against the repo as it is, not an ideal version of it. Following an existing convention is never a finding, even if the convention is imperfect.
- Prefer a few well-argued findings over a complete list. An empty "Worth changing" section is a good outcome.
- Point toward a direction, not a rewrite. The author decides how.

## Steps

### 1. Load the PR

- `gh pr view <arg> --json number,title,body,url,baseRefName,headRefName,author,files,commits`
- `gh pr diff <arg>`
- Read the title, body and commit messages to understand what the author meant to do. Judge the change against that intent.

### 2. Load the standards

- Read the repo's `AGENTS.md`, plus `.engineering-docs/standards/code-principles.md` and `agent-instructions.md`. Project rules in `AGENTS.md` win where they conflict.
- If `.engineering-docs/` is missing but `scripts/sync_standards.py` exists, run it. If the repo doesn't use the standards at all, say so in one line and review against the conventions the scan finds.

### 3. Read beyond the diff

A diff can't show duplication, misplaced logic or a missed reuse. For each changed area:

- Read the surrounding module and its callers, enough to know what owns that domain.
- Search for the expressions the PR adds (arithmetic, thresholds, queries, format strings), not only function names, to find logic it may duplicate.
- Check what the change makes dead: functions, branches, config or tests that should have gone with it.

Use read-only Explore agents in parallel when the PR touches several areas.

### 4. Assess

Start with the approach as a whole, then look at the parts:

- **Approach:** does the overall shape fit the problem and the repo? Would a simpler approach do the same job?
- **Placement:** is new logic in its domain's owner and the right layer, or in the first file that needed it?
- **Duplication:** does it copy logic that already exists, or leave a second copy behind?
- **Overengineering:** speculative flags, hooks, config or abstractions; classes where a function would do; new modules or dependencies without a stated reason.
- **Refactor and change:** are restructuring and behavior changes in separate commits?
- **Tests:** is new behavior or a fix covered?
- **Deletion:** is code the change made dead removed?

For each candidate finding, ask: will this make the next change in this area harder or riskier? If not, drop it.

### 5. Report

```
## PR #<n>: <title>

**Verdict:** one or two sentences on whether the approach is sound and fits the repo.

### Worth changing
Issues that will cost maintainability if merged as is.
- **<short title>** (`file:line`)
  What: the issue, plainly.
  Why it matters: the concrete cost for this repo.
  Principle: the section of code-principles.md, if any.
  Direction: what a fix would look like, in a sentence or two.

### Worth considering
Judgment calls the author may reasonably decline. Same shape, shorter.

### Done well
One to three things the PR does right, named specifically.
```

- Every finding names a file and line, and is checked against the code, not inferred from the diff alone.
- Explain the reasoning in plain terms. The author may be newer to these principles, and the review is a chance for them to learn the why.
- Leave out empty sections, except "Done well".

### 6. Hand off

Present the review to the user. Never post to GitHub unless they ask. If they do, post it with `gh pr review <n> --comment --body-file <file>`, using only the findings they chose to keep.
