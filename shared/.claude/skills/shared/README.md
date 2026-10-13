# Shared Standards

Standards used by more than one skill or project CLAUDE.md. This folder has no `SKILL.md`, so Claude Code does not load it as a skill.

A file used by only one skill belongs in that skill's `references/` folder instead (for example `post-mortem/references/standard.md` and `tickets/references/`). Move a file here only when a second consumer needs it.

## Structure

```
shared/
  infra/            # provisioning and config: cloud services, secrets, IAM
  patterns/         # recurring design solutions with reference implementations
  code/             # style, error handling, testing (planned)
  project/          # repo structure, naming, tooling (planned)
  languages/        # language-specific conventions (planned)
```

## Current

### infra/

What we provision and how it's configured. Cloud services, networking, databases, secret storage, IAM, environment topology.

- `secrets-standard.md`: secret naming, grouping, retrieval patterns, IAM scoping.

### patterns/

Recurring design solutions for specific classes of problems. Each doc describes the problem, the approach, when it applies, and a reference implementation. See `patterns/README.md` for loading guidance.

- `etl-column-contracts.md`: single model class per table as the schema contract between API source and database target. Applies to 1:1 ETL pipelines.

### Code principles (moved)

The code principles now live in engineering-docs, at `standards/code-principles.md`, with the shared agent instructions and lint configs beside them. Adopting repos sync them to `.engineering-docs/standards/`; `/make-a-plan` reads them from there, or from `~/Documents/projects/engineering-docs/standards/` for repos that haven't adopted them.

## Planned

### code/

Language-agnostic code standards: error handling philosophy, logging conventions, configuration patterns, testing expectations, documentation requirements.

### project/

Repository structure conventions: directory layouts, CI/CD patterns, dependency management, monorepo vs. polyrepo guidance, README expectations.

### languages/

Language-specific preferences layered on top of the general code standards. One file per language:

- `python.md`: formatting (ruff/black), type hints, dependency management (poetry vs. uv), project layout
- `typescript.md`: runtime (Node vs. Bun), framework preferences, module patterns
- Additional languages as adopted

## Design Principles

- **Tool-agnostic where possible**: separate the "what" from the "how." Writing standards don't reference Jira; secret naming doesn't reference boto3. Tool-specific details go in a companion doc (e.g. `tickets/references/ticket-management.md` pairs with `ticket-standard.md`).
- **Prescriptive, not exhaustive**: document the chosen approach and why, not every alternative considered. These are decisions, not surveys.
- **Living documents**: update when conventions change. Stale standards are worse than no standards.
- **Referenced, not duplicated**: project CLAUDE.md files and skills point here rather than copying content. One source of truth.
