---
description: Compile notes from a transcript file in .claude/notes/
disable-model-invocation: true
argument-hint: "[file prefix]"
allowed-tools: Bash Glob Grep Read Write
---

## Compile Notes

The user may or may not have provided a file prefix as the argument.

### Steps

1. Look in `.claude/notes/` relative to the current working directory. If `.claude/notes/` does not exist, fall back to `notes/` in the current directory. IMPORTANT: The notes directory may be a symlink. Use `ls` via Bash to list files rather than Glob, which does not follow symlinks.
2. If no prefix was supplied, select the most recently modified file ending with `-transcript.md` in the notes directory (use `ls -t` to sort by modification time).
3. If a prefix was supplied, find files containing `{prefix}` in their name that end with `-transcript.md`. The argument may be a partial match (e.g., "2026" should match "20260507-standup-transcript.md"). The separator between the prefix and the rest of the filename may be a hyphen or underscore.
4. If no matches are found, list the available transcript files and ask the user which one they meant.
5. If multiple files match the prefix, list all matches and ask the user to clarify which one.
6. Read the matched transcript file.
7. Write a compiled summary to the same directory with the filename `{prefix}-compiled-notes.md` (using the exact prefix from the matched filename, before `-transcript.md`).

### Summary format

The compiled notes should be a concise, well-structured summary of the transcript content:

- Extract key decisions, action items, and important discussion points
- Organize by topic rather than chronologically
- Use bullet points for clarity
- Preserve any specific names, dates, numbers, or technical details mentioned
- Flag any open questions or unresolved items
- Keep the tone neutral and factual
