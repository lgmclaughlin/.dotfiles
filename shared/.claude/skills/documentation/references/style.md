# Documentation Standard

A living standard for project documentation. The `/documentation` skill reads this file and `types.md`, compares them against the current state of a project, and produces a plan to close the gaps. If the skill discovers a doc type that belongs in the standard, it appends it to the Niche Documents section of `types.md` and notes why.

---

## Principles

- **README is an entry, not an encyclopedia.** Hook the reader with one punchy line that captures the project's purpose ("talk to your org chart," "weekly pulse checks via Slack"). Follow with just enough to orient: what it does, how pieces connect, how to get started. Link out for depth.
- **development.md is the new-developer contract.** A developer who just cloned the repo should be able to go from zero to running locally, running tests, and deploying, without Slacking anyone. If they have to ask a question, the doc failed.
- **Commands over descriptions.** "You need AWS credentials" is not documentation. The exact `aws secretsmanager get-secret-value --secret-id <id>` command with the real secret ID: that is documentation.
- **Update over rewrite.** If a doc is 80% good, fill the gaps. Do not rewrite from scratch unless the structure is unsalvageable.
- **Inspect the codebase, not just existing docs.** Scripts, env vars in code, Dockerfiles, Terraform files, CI configs, and Makefiles are all sources of truth. A script that exists but is not documented is a gap.
- **Ask when you do not know.** Secrets, deployment targets, credentials, third-party service setup: if the codebase does not contain the answer, ask the user rather than guessing or omitting.

---

## Naming and Location

- `README.md` stays uppercase at the project root (GitHub/GitLab renders it automatically).
- All other documentation files use **lowercase** names: `development.md`, `architecture.md`, `database.md`, etc.
- If the project already has a `docs/` folder, put docs there. Otherwise, check whether docs live at the root and match the existing convention. When creating docs for a new project, prefer `docs/`.
- Cross-doc links should use relative paths from the linking file: `[development.md](docs/development.md)` from the README, `[database.md](database.md)` between docs in the same folder.

---

---

## Style Rules

These apply to all documentation in the standard:

- No em dashes. Use colons, commas, or rephrase.
- No arrow symbols. Use `->` instead.
- Avoid complex ASCII graphs when you can, although simple ones are acceptable.
- Code blocks for every command or file path the reader might need to copy.
- Table format for lists of more than 3-4 items with shared attributes (env vars, scripts, resources).
- Relative links between docs (`[development.md](docs/development.md)`), not absolute paths.
- Keep each doc focused. If a section grows past what the doc's purpose covers, split it into its own file and link to it.
