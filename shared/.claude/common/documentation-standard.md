# Documentation Standard

A living standard for project documentation. The `/documentation` skill reads this file, compares it against the current state of a project, and produces a plan to close the gaps. If the skill discovers a doc type that belongs in this standard, it appends it to the Niche Documents section and notes why.

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

## Core Documents

Every project should have these. If one is missing, create it. If one exists but is incomplete, update it.

### 1. README.md

**Purpose:** First thing a reader sees. Sell the project in one line, orient in two minutes, link out for everything else.

**Structure:**
```
# Project Name

> One-line hook: what makes this project interesting in plain language.

## What It Does
2-3 sentences. What problem it solves, for whom, and how (at the highest level).

## Architecture
Short paragraph or simple diagram. Name the major components and how they connect.
No implementation details: just the shapes and arrows.

## Quick Start
5 commands max: clone, install, configure, run. Link to development.md for the full version.

## Project Structure
Directory tree with a one-liner per top-level folder. Keep it shallow (one level deep unless nesting is meaningful).

## Documentation
Bulleted list linking to every other doc file with a one-line description of each.
```

**Tone:** Direct and practical. No jargon without explanation. No "simply run X." Assume the reader knows the tech stack but has never seen this project.

---

### 2. development.md

**Purpose:** The full developer setup, build, test, and deploy guide. This is the most critical doc in the repo.

**Structure:**
```
# Development Guide

## Prerequisites
Exact tool versions and install instructions (links or commands).
Example: "Python 3.12+ (install via pyenv: `pyenv install 3.12.4`)"
Not: "Python 3.12+"

## First-Time Setup
Every command from clone to running. No skipped steps.
Include database setup, dependency installation, config file creation.

## Environment Variables
Table format:
| Variable | Purpose | Where to get it | Example |
Each variable referenced anywhere in the codebase must appear here.

## Secrets
How to retrieve each secret. Exact commands:
  aws secretsmanager get-secret-value --secret-id tally/dev/slack --query SecretString --output text
How to set them locally (export, .env file, config file).
If a secret requires access that must be granted, say by whom and how to request it.

## Running Locally
How to start each component (backend, frontend, workers, database, etc.).
What URLs to open. How to verify it is working.
If components depend on each other, state the startup order.

## Testing
How to run the full test suite.
How to run a single test file or test case.
What fixtures or test utilities exist and what they do.
How to set up test data (seed scripts, factories, fixtures).
How to run tests against real vs. mock services.

## Building for Deployment
Exact build commands and what artifacts they produce.
Where artifacts go (S3 bucket, container registry, build output directory).

## Deploying
Step-by-step per environment (dev, staging, prod).
Include the exact commands or scripts to run.
Include how to verify the deploy succeeded (health checks, smoke tests).
Include rollback steps.

## Scripts Reference
Table format:
| Script | Purpose | Usage | Example |
Every script in the repo: what it does, when to use it, arguments it accepts.
Include example invocations.

## Troubleshooting
Common issues and their fixes. This section grows over time.
Format: symptom -> cause -> fix.
```

**Tone:** Tutorial-style. Numbered steps where order matters. Code blocks for every command. No assumptions about what the reader already knows about this specific project.

---

### 3. architecture.md

**Purpose:** How the system works, why it was designed this way, and what conventions to follow when adding to it.

**Structure:**
```
# Architecture

## System Overview
What the system does at a technical level. Major components and their responsibilities.
Diagram if the system has more than 2-3 components.

## Request / Data Flow
How data moves through the system. Trace a typical request end-to-end.
Include async flows (queues, scheduled jobs, event-driven paths).

## Code Organization
What lives where. Map directories to responsibilities.
Explain the layering (handlers -> flows -> db, for example).

## Patterns and Conventions
Key patterns used and WHY they were chosen.
Naming conventions (table format if more than a few).
How to add a new [route / handler / feature / module]: the pattern to follow.

## Infrastructure
If the project uses Terraform: reference the Terraform definitions as the source of truth.
List cloud resources and their purpose.
Include networking, security groups, IAM roles at a level useful for debugging.
Environment differences (dev vs. prod): table format.
Monitoring: what is watched, what triggers alerts, where dashboards live.
If no Terraform: describe infrastructure manually, then ask the user if they plan to add IaC.

## Database
If complex enough for its own doc, link to database.md.
Otherwise, include here: tables, relationships, connection model, migration process.

## Security Model
Authentication and authorization flow.
How credentials are managed.
Role-based access, if applicable.
```

**Tone:** Technical reference. Explain the "why" alongside the "what." A developer should be able to read this and make architectural decisions that are consistent with the existing system.

---

### 4. database.md (if applicable)

**Purpose:** Complete schema reference. Create this when the project has more than 3-4 tables or cross-schema relationships.

**Structure:**
```
# Database

## Connection Model
How connections are configured per environment.
Roles, permissions, search_path behavior.

## Schema
For each table:
- Purpose (one sentence)
- Columns (name, type, constraints, description)
- Indexes
- Foreign keys and relationships
- Notable constraints or triggers

## Cross-Schema Access
If the project reads/writes other schemas, document which columns and why.

## Migrations
How to create a migration.
How to run migrations (exact commands).
How to roll back a migration.
Naming conventions for migration files.
```

---

## Niche Documents

These are project-specific docs that not every project needs but that recur often enough to name. When the skill encounters a project that needs one of these, it should use the name and general structure described here. If the skill discovers a doc type not listed here that seems broadly useful, it should append it to this section.

### domain-rules.md
For business-logic-heavy projects. Captures rules, statuses, state transitions, role permissions, and calculations that drive system behavior but are not obvious from the code alone.

### api.md (or per-service: dashboard.md, mcp-tools.md, etc.)
API reference: endpoints, methods, request/response shapes, auth requirements. Named for the service it documents when a project has multiple APIs.

### flows.md (or docs/flows/*.md)
For event-driven or state-machine systems. Documents each flow: trigger, states, transitions, guards, side effects. One file per flow if the system has multiple.

### installer.md
For projects distributed as installable software. Build steps, installer behavior, post-install scripts, configuration, prerequisites for end users.

### rendering.md
For projects with complex output pipelines (PDF generation, chart rendering, report building). Documents the pipeline stages, dependencies, caching, and performance characteristics.

### monitoring.md
For projects with cloud infrastructure and observability tooling. Documents how to access metrics, query logs, interpret dashboards, and investigate incidents using CLI commands.

**Structure:**
```
# Monitoring

## Overview
What monitoring exists, where to find dashboards, who gets alerted and how.

## Alarms
Table of all alarms: name, what it watches, threshold, what it means when it fires.

## Dashboard
Where to find it, what each widget shows, how to read the metrics (especially when percentages are misleading at low volume).

## Querying Metrics
CLI commands for pulling CloudWatch (or equivalent) metrics. Use real namespace, metric name, and dimension values. Show the full command with flags, not a description of what to run. Include how to adjust the time window and granularity.

## Querying Logs
Log group names, filter patterns for common searches (errors, specific status codes, slow requests). Include output format notes so the reader knows what they're looking at.

## Interpreting Results
What normal looks like. What patterns indicate real problems vs. expected behavior (e.g., 4xx from auth checks, percentage spikes at low volume). Document any non-obvious insights discovered during actual incident investigation.

## Troubleshooting Recipes
Symptom -> what to check -> how to check it -> what the answer means.
These accumulate over time as real incidents are investigated.
```

**Content guidelines:** Only include commands and values you have verified work. If you've figured out exact namespaces, dimensions, log group names, and filter syntax through trial and error, capture all of it. If a section covers something you haven't tested, include what you know and mark gaps with `<!-- TODO -->` or `<VALUE>` placeholders. Partial coverage with marked gaps is better than omitting the section.

### runbook.md
For production systems that need documented procedures for when things go wrong. Covers what to do, not how to look. monitoring.md handles observability (dashboards, metrics, logs, investigation). runbook.md handles response: restarting services, rolling back deploys, scaling, database recovery, and escalation. If the action is "query a metric to understand what's happening," it belongs in monitoring.md. If the action is "run this command to fix it," it belongs in runbook.md.

**Structure:**
```
# Runbook

## Service Recovery
How to restart each service. Rollback procedures for bad deploys.
Scaling up/down. What to do when a service won't start.

## Database
How to connect. Backup and restore procedures.
How to fix data issues (with safety guardrails).

## Escalation
Who to contact for what. When to page vs. when to wait.

## Incident Log
Dated entries for past incidents: what happened, what was done, what was learned.
Grows over time. Keeps institutional knowledge from being lost.
```

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
