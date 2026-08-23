#!/usr/bin/env bash
set -uo pipefail

taskkill //f //im yasb.exe
sleep 1
taskkill //f //im komorebi.exe
sleep 1
taskkill //f //im explorer.exe
sleep 2
explorer.exe &
sleep 2
komorebic start --whkd
sleep 1
yasb
