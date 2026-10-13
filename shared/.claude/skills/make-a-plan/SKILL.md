---
description: Enter plan mode, scan the codebase for conventions, reuse and centralization, and write a phase plan checked against the project's code principles
argument-hint: "[optional spec .md path]"
---

# Make a Plan

Plan the next piece of work. Optional input: $ARGUMENTS

## Steps

### 1. Enter plan mode

Call the `EnterPlanMode` tool before reading or scanning anything. Stay read-only until the plan is approved.

### 2. Establish the scope

- If a spec file path is given, read the whole file. It is the source of the requirements and any decisions already made.
- Otherwise, work out from the conversation which project and which work is meant. If it is still ambiguous, ask one short question before scanning.
- Read the project's `CLAUDE.md` (root and `.claude/`) for the workflow, the file rules and where plans are written (usually `.claude/current-phase.md`).
- If the planning file still holds an unarchived phase, say so and ask the user to archive it. Never archive it yourself.

### 3. Load the standards

- Read `.engineering-docs/standards/code-principles.md` and `.engineering-docs/standards/agent-instructions.md`, then the project rules in `AGENTS.md`, which add to them and win where they conflict.
- If `.engineering-docs/` is missing but `scripts/sync-engineering-docs.sh` exists, ask the user to run it before going further.
- If the repo hasn't adopted the standards, read the same two files from `~/Documents/projects/engineering-docs/standards/` and say so in one line.

### 4. Scan the codebase

Verify every claim against the code. Use read-only Explore agents in parallel for broad areas, and direct reads for known files. Cover:

- **Conventions to follow:** naming, file layout, error handling, response shapes, test patterns, UI components and styles, and how similar features were built.
- **Functions to reuse:** existing helpers, hooks, queries and components that already do part of the work. Name each with `file:line`.
- **Functions to centralize:** logic the change would duplicate a second time (the second-use rule). Plan one owner for it, and list the copies it replaces.
- **Code made redundant:** functions, branches, endpoints, tests and dialogs the change makes dead. They are deleted in the same plan.
- **Limits:** deploy surfaces, timeouts, permissions, migrations and data that the change touches.

### 5. Settle the decisions

- Ask about real product or behavior choices with `AskUserQuestion`, putting the recommendation first. Don't ask about anything the code or a sensible default already answers.
- When an answer carries a comment, discuss it, including any code findings it raises, before presenting the plan.
- Record the decisions in the spec file when there is one.

### 6. Write the plan

Use the project's phase format (Objectives, Tasks, In Progress, Blockers, or what its `CLAUDE.md` defines). Unless told otherwise, write the plan to .claude/current-phase.md with high level and granular tasks for completion. The plan:

- has 3 to 5 short objectives;
- groups tasks by area or feature, with granular checkable tasks naming exact files, functions and tests;
- puts the riskiest behavior change early;
- ends with a group for the verification gates, the deploy and smoke test steps, and the docs and progress updates;
- meets the Planning section of `agent-instructions.md`, including its principles check.

Present it with `ExitPlanMode`. Write it to the planning file only after approval.
