@echo off
komorebic stop --whkd
timeout /t 2 /nobreak >nul
komorebic start --whkd
