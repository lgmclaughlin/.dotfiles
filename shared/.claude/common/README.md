# Common Standards

Shared documentation that defines how we build software. These files are referenced by skills, project CLAUDE.md files, and developer onboarding, not tied to any single repository.

## Structure

```
common/
  devops/           # shipping and operations: CI/CD, ticketing, deployment
  infra/            # provisioning and config: cloud services, secrets, IAM
  patterns/         # recurring design solutions with reference implementations
  code/             # style, error handling, testing (planned)
  project/          # repo structure, naming, tooling (planned)
  languages/        # language-specific conventions (planned)
```

## Current

### devops/

How code moves from repo to running. CI/CD pipelines, ticketing, deployment strategies, monitoring, incident response.

- `ticket-standard.md`: how to write tickets (tone, structure, constraints). Tool-agnostic.
- `ticket-management.md`: Jira-specific API reference, field mappings, operations.

### infra/

What we provision and how it's configured. Cloud services, networking, databases, secret storage, IAM, environment topology.

- `secrets-standard.md`: secret naming, grouping, retrieval patterns, IAM scoping.

### patterns/

Recurring design solutions for specific classes of problems. Each doc describes the problem, the approach, when it applies, and a reference implementation. See `patterns/README.md` for loading guidance.

- `etl-column-contracts.md`: single model class per table as the schema contract between API source and database target. Applies to 1:1 ETL pipelines.

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

- **Tool-agnostic where possible**: separate the "what" from the "how." Writing standards don't reference Jira; secret naming doesn't reference boto3. Tool-specific details go in a companion doc (e.g. `ticket-management.md` pairs with `ticket-standard.md`).
- **Prescriptive, not exhaustive**: document the chosen approach and why, not every alternative considered. These are decisions, not surveys.
- **Living documents**: update when conventions change. Stale standards are worse than no standards.
- **Referenced, not duplicated**: project CLAUDE.md files and skills point here rather than copying content. One source of truth.
