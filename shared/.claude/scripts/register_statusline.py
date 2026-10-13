"""Point Claude Code's statusLine at statusline.py without touching other settings.

Usage: python register_statusline.py <settings.json> <statusline.py>
"""

import json
import os
import sys


def to_forward_slashes(path):
    return path.replace("\\", "/")


def main():
    settings_path, script_path = sys.argv[1], sys.argv[2]

    settings = {}
    if os.path.exists(settings_path):
        with open(settings_path, encoding="utf-8") as settings_file:
            settings = json.load(settings_file)

    command = f"{to_forward_slashes(sys.executable)} {to_forward_slashes(script_path)}"
    status_line = {"type": "command", "command": command}
    if settings.get("statusLine") == status_line:
        print(f"  OK (statusLine already set): {command}")
        return

    settings["statusLine"] = status_line
    with open(settings_path, "w", encoding="utf-8", newline="\n") as settings_file:
        json.dump(settings, settings_file, indent=2, ensure_ascii=False)
        settings_file.write("\n")
    print(f"  SET statusLine: {command}")


if __name__ == "__main__":
    main()
