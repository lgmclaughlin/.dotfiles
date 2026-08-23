---
description: Deeply scan a codebase and its documentation, compare against the documentation standard, then create or update docs to match. Proposes new project-specific docs and can update the standard itself.
---

## Documentation Audit and Update

You are about to perform a thorough documentation audit of this project. This is a large-scale task. Be exhaustive in your scan and precise in your plan. Do not guess at details you cannot find in the codebase: ask the user.

### Phase 1: Load the Standard

1. Read `~/.claude/common/documentation-standard.md` (the living documentation standard).
2. Internalize all core documents, niche documents, principles, and style rules.

### Phase 2: Deep Codebase Scan

Scan the project thoroughly. You are building a complete picture of what the project does, how it is built, how it is deployed, and what is already documented. Do not skim: read files, follow imports, trace flows.

**Documentation inventory:**
- Find every `.md` file in the project (exclude `.claude/` management files).
- Read each one fully. Note its purpose, completeness, tone, and how it maps to the standard.

**Codebase inspection (these are sources of documentation truth):**
- `package.json` scripts, `Makefile`, `Justfile`, or equivalent task runners
- Every file in `scripts/` or `bin/` directories
- `Dockerfile`, `docker-compose.yml`, and container configs
- Terraform files (`*.tf`), CloudFormation, or other IaC definitions
- CI/CD configs (`.github/workflows/`, `buildspec.yml`, `.gitlab-ci.yml`, etc.)
- Environment variable references in code (grep for `os.environ`, `process.env`, `env.`, `os.Getenv`, etc.)
- Secret references (grep for `secretsmanager`, `vault`, `ssm`, `secret`, credential-related code)
- Database connection setup, migration files, schema definitions
- Entry points (main files, handler registrations, route definitions)
- Test configuration and fixtures
- Any `*.example`, `*.sample`, `.env.example` files
- README files in subdirectories

**What you are looking for:**
- Scripts that exist but are not documented anywhere
- Environment variables referenced in code but not in any doc
- Secrets used in code but no retrieval instructions documented
- Deployment steps that can be inferred from CI/CD but are not written down
- Infrastructure resources defined in Terraform but not described in docs
- Test fixtures and seed scripts that are not explained
- Gaps between what the codebase does and what the docs say it does

### Phase 3: Gap Analysis

Compare your findings against the standard:

**For each core document (README.md, development.md, architecture.md, database.md):**
- Does it exist?
- If yes: which sections from the standard are present, incomplete, or missing?
- If no: flag it for creation.

**For niche documents:**
- Does this project need any of the niche docs listed in the standard?
- Are there aspects of the project that need documentation but do not fit any existing standard category? If yes, propose a new niche doc with a name and purpose. Plan to append it to the standard.

**Information you cannot determine from the codebase:**
- Compile a list of questions for the user. These will typically be about:
  - Secrets: how to request access, who grants it
  - Deployment: manual steps, approval processes, environment-specific procedures
  - Third-party services: setup steps, account requirements
  - Team conventions: branching strategy, PR review process, release cadence
  - Monitoring: what dashboards exist, what pages whom, alert thresholds

### Phase 4: Enter Plan Mode and Present

Enter plan mode. Present:

1. **Current state summary:** What docs exist, their quality, what the codebase reveals.
2. **Questions for the user:** Things you cannot determine from the codebase. Group by document. Ask these BEFORE proposing changes so user answers can be incorporated into the plan.
3. **Proposed changes:** For each document:
   - **Update** (existing doc, specific sections to add/revise) or **Create** (new doc, full outline of what it will contain)
   - Which standard sections it addresses
   - What information sources you will draw from (specific files, terraform definitions, scripts, etc.)
4. **Standard updates:** If you discovered a niche doc type worth adding to the standard, include it in the plan.

Wait for the user to answer questions and approve the plan before proceeding.

### Phase 5: Execute

After plan approval:

1. Update or create each document according to the plan.
2. Incorporate all answers the user provided to your questions.
3. Follow all style rules from the standard (no em dashes, no arrow symbols, code blocks for commands, tables for lists).
4. For development.md specifically:
   - Every secret must have a retrieval command, not just a name.
   - Every script must have an example invocation.
   - Every environment variable must have its source and an example value.
   - If you do not have this information and the user did not provide it, leave a `<!-- TODO: [specific question] -->` comment so it is easy to find and fill later.
5. If the plan includes a standard update, append the new niche doc entry to `~/.claude/common/documentation-standard.md` under the Niche Documents section.
6. After all docs are written, do a final consistency pass:
   - Do cross-doc links resolve?
   - Does README's Documentation section list every doc that now exists?
   - Are there contradictions between docs?
   - Does the tone match across all documents?

### Important Rules

- **Do not fabricate deployment commands, secret IDs, or infrastructure details.** If you cannot find them in the codebase, ask the user.
- **Prefer updating existing files over creating new ones.** Only create a file when nothing suitable exists.
- **Respect existing doc structure when it works.** If a project has a `docs/` folder, put docs there. If docs live at the root, keep them at the root. Match the existing convention.
- **Infrastructure docs should reference Terraform.** If the project uses Terraform, point to the `.tf` files as source of truth and summarize key resources. Do not duplicate Terraform definitions line by line. If there is no IaC, describe infrastructure manually and note that it is not codified.
- **development.md is the priority.** If you must triage effort, this document gets the most attention. It is the one developers will use daily.
- **The standard is a living document.** If you find a genuinely new category of documentation that other projects would benefit from, append it. Do not be conservative about this: the standard should grow with real usage.
