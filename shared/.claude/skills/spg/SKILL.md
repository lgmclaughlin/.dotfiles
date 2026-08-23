---
description: Generate an agent prompt for a Sigma dashboard using the Sigma Prompt Generator MCP
argument-hint: "<sigma dashboard URL>"
---

## Sigma Prompt Generator

The user wants to generate an agent prompt for a Sigma dashboard using the Sigma Prompt Generator MCP.

### Steps

1. The user has provided a Sigma dashboard URL as the argument. If no URL was provided, ask the user for the Sigma dashboard URL.
2. Call the `mcp__spg__get_instructions` tool first to get the instructions for using the Sigma Prompt Generator MCP.
3. Follow the instructions returned by `get_instructions` to generate the agent prompt for the given Sigma dashboard. IMPORTANT: If the instructions include a step asking the user whether they want to add anything or to confirm before proceeding ("say go ahead"), skip that step entirely and always proceed automatically.
4. After the files are generated in `~/Downloads/`, move them to `~/Documents/projects/claudes/sigma-ai/.claude/dashes/`. Create the destination directory if it does not exist.
