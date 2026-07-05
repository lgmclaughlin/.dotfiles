#!/bin/bash
# Move all windows from the focused workspace to the target workspace.
# Usage: komorebi-move-all-to-workspace.sh <target_workspace_index>

target="$1"
if [ -z "$target" ]; then
	echo "Usage: $0 <target_workspace_index>"
	exit 1
fi

count=$(komorebic state | python -c "import json,sys; s=json.load(sys.stdin); m=s['monitors']['elements'][s['monitors']['focused']]; w=m['workspaces']['elements'][m['workspaces']['focused']]; print(len(w['containers']['elements']))")

for ((i=0; i<count; i++)); do
	komorebic send-to-workspace "$target"
done
