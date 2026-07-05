#!/bin/bash
# Swap all windows between the current workspace and the target workspace.
# Usage: komorebi-swap-workspaces.sh <target_workspace_index>

target="$1"
if [ -z "$target" ]; then
	echo "Usage: $0 <target_workspace_index>"
	exit 1
fi

current=$(komorebic query focused-workspace-index)

read countA countB temp <<< "$(komorebic state | python -c "import json,sys; s=json.load(sys.stdin); m=s['monitors']['elements'][s['monitors']['focused']]; ws=m['workspaces']['elements']; c=$current; t=$target; countA=len(ws[c]['containers']['elements']); countB=len(ws[t]['containers']['elements']); temp=next((i for i,w in enumerate(ws) if i not in (c,t) and len(w['containers']['elements'])==0), -1); print(countA, countB, temp)")"

if [ "$temp" = "-1" ]; then
	echo "No empty workspace available for temp storage"
	exit 1
fi

komorebic focus-workspace "$current"
for ((i=0; i<countA; i++)); do
	komorebic send-to-workspace "$temp"
done

komorebic focus-workspace "$target"
for ((i=0; i<countB; i++)); do
	komorebic send-to-workspace "$current"
done

komorebic focus-workspace "$temp"
for ((i=0; i<countA; i++)); do
	komorebic send-to-workspace "$target"
done

komorebic focus-workspace "$target"
