pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import "../"

Singleton {
    id: root

    property list<string> wallpapers: []
    property string currentWallpaper: ""
    property bool pickerVisible: false

    function togglePicker() {
        pickerVisible = !pickerVisible
        if (pickerVisible && wallpapers.length === 0) rescan()
    }

    // ── Scanner ──────────────────────────────────────────────────────
    Process {
        id: scanner
        running: false
        command: ["find",
            Quickshell.env("HOME") + "/Pictures",
            "-maxdepth", "3", "-type", "f",
            "(", "-iname", "*.jpg", "-o", "-iname", "*.jpeg",
            "-o", "-iname", "*.png", "-o", "-iname", "*.webp",
            "-o", "-iname", "*.bmp", ")"]
        stdout: SplitParser {
            onRead: function(line) {
                var p = line.trim()
                if (p !== "") root.wallpapers = [...root.wallpapers, p]
            }
        }
    }

    Component.onCompleted: { scanner.running = true; loadSaved.running = true }

    function rescan() {
        wallpapers = []
        scanner.running = true
    }

    // ── Load saved wallpaper ─────────────────────────────────────────
    Process {
        id: loadSaved
        running: false
        property string _buf: ""
        command: ["cat", Quickshell.env("HOME") + "/.config/quickshell/.wallpaper"]
        stdout: SplitParser { onRead: function(line) { loadSaved._buf += line } }
        onExited: {
            var p = loadSaved._buf.trim()
            if (p) root.currentWallpaper = p
            loadSaved._buf = ""
        }
    }

    // ── Set wallpaper ────────────────────────────────────────────────
    function setWallpaper(path, scheme) {
        currentWallpaper = path
        _scheme = scheme || "scheme-tonal-spot"
        saveProc.running = true
    }

    property string _scheme: "scheme-tonal-spot"

    Process {
        id: saveProc
        running: false
        command: ["python3", "-c",
            "import sys,os; open(os.path.expanduser('~/.config/quickshell/.wallpaper'),'w').write(sys.argv[1]+'\\n')",
            root.currentWallpaper]
        onExited: awwwProc.running = true
    }

    Process {
        id: awwwProc
        running: false
        command: ["bash", "-c",
            "awww init 2>/dev/null || true; awww img \"$1\" --transition-type grow --transition-pos center --transition-duration 1",
            "--", root.currentWallpaper]
        onExited: matugenProc.running = true
    }

    Process {
        id: matugenProc
        running: false
        command: ["matugen", "image", root.currentWallpaper,
            "-t", root._scheme, "--prefer=saturation"]
        stderr: SplitParser { onRead: function(l) { console.warn("matugen:", l) } }
        onExited: function(code) {
            console.log("matugen exited code=" + code)
            colorReader.running = true
        }
    }

    Process {
        id: colorReader
        running: false
        property string _buf: ""
        command: ["cat", Quickshell.env("HOME") + "/.local/state/quickshell/user/generated/colors.json"]
        stdout: SplitParser { onRead: function(line) { colorReader._buf += line } }
        onExited: {
            Settings.applyColors(colorReader._buf)
            colorReader._buf = ""
        }
    }
}
