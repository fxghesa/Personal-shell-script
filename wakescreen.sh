#!/bin/bash

# Ensure runtime directory and DBus session are set (crucial when executed over SSH)
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
export DBUS_SESSION_BUS_ADDRESS="${DBUS_SESSION_BUS_ADDRESS:-unix:path=${XDG_RUNTIME_DIR}/bus}"

# Ensure a UTF-8 locale for Qt
if [ -z "$LANG" ] && [ -z "$LC_ALL" ]; then
    export LC_ALL="C.UTF-8"
fi

# Detect active Wayland display socket if not set in the current environment
if [ -z "$WAYLAND_DISPLAY" ]; then
    WAYLAND_DISPLAY=$(systemctl --user show-environment 2>/dev/null | sed -n 's/^WAYLAND_DISPLAY=//p')
fi

if [ -z "$WAYLAND_DISPLAY" ]; then
    for sock in "$XDG_RUNTIME_DIR"/wayland-*; do
        if [ -S "$sock" ]; then
            WAYLAND_DISPLAY="$(basename "$sock")"
            break
        fi
    done
fi

MODE="on"
if [ "$1" = "off" ]; then
    MODE="off"
fi

if [ -n "$WAYLAND_DISPLAY" ]; then
    export WAYLAND_DISPLAY
    export QT_QPA_PLATFORM=wayland
    kscreen-doctor --dpms "$MODE"
else
    # Fallback for X11 sessions
    if [ -z "$DISPLAY" ]; then
        DISPLAY=$(systemctl --user show-environment 2>/dev/null | sed -n 's/^DISPLAY=//p')
    fi
    export DISPLAY="${DISPLAY:-:0}"
    xset dpms force "$MODE" 2>/dev/null || true
fi

# Wake up lockscreen/screensaver and reset idle timer if turning on
if [ "$MODE" = "on" ]; then
    busctl --user call org.freedesktop.ScreenSaver /ScreenSaver org.freedesktop.ScreenSaver SimulateUserActivity 2>/dev/null || true
fi
