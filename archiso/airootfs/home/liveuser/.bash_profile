# [[ -f ~/.bashrc ]] && . ~/.bashrc

# Auto-start KDE Plasma 6 Wayland session on TTY1
if [ -z "$DISPLAY" ] && [ -n "$XDG_VTNR" ] && [ "$XDG_VTNR" -eq 1 ]; then
    exec dbus-run-session startplasma-wayland
fi
