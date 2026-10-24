@echo off
title neweraseOS Local Builder
echo ========================================================
echo          neweraseOS Local Builder (WSL Arch)
echo ========================================================
echo.
wsl -d archlinux -u root -- /bin/bash /mnt/f/linux/build-iso-local.sh
echo.
pause
