# Patterns

Design patterns and architectural approaches used across projects. Each doc describes the problem, the pattern, when it applies, and a reference implementation.

These are not code style rules (those go in `code/`) or infrastructure decisions (those go in `infra/`). Patterns describe how to structure a solution to a recurring problem.

## Documents

- `etl-column-contracts.md`: consolidate API-to-database column mappings into a single model class per table. Applies to ETL pipelines with 1:1 source-to-table mapping. Eliminates parallel dicts that drift out of sync.

## Loading Guidance

Only load a pattern doc when the current task matches its "applies to" description. Most projects need zero or one pattern doc at a time.
