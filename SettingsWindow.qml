import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

PanelWindow {
    id: root

    anchors.top:  true
    anchors.left: true
    margins.top:  46
    margins.left: 0

    width:  300
    height: 480

    color: "transparent"
    exclusionMode: ExclusionMode.Ignore
    visible: Settings.settingsWindowVisible

    Shortcut {
        sequence: "Escape"
        enabled: root.visible
        onActivated: Settings.settingsWindowVisible = false
    }

    Rectangle {
        anchors.fill: parent
        color:  "#ee101417"
        radius: 10
        border.color: "#33ffffff"
        border.width: 1
    }

    // ── State ────────────────────────────────────────────────────────────
    property string wallpaperPath:   ""
    property bool   applyRunning:    false
    property bool   browserVisible:  false
    property string browseDir:       "/home/brad/Pictures"
    property var    browseEntries:   []

    // Read saved wallpaper path
    FileView {
        path: "/home/brad/.config/quickshell/.wallpaper"
        watchChanges: true
        onTextChanged: {
            var p = String(text).trim()
            if (p) root.wallpaperPath = p
        }
    }

    // List directory contents (folders + images only)
    Process {
        id: lsProc
        running: false
        property string _buf: ""
        command: ["python3", "-c",
            "import os,json,sys\n" +
            "d=sys.argv[1]\n" +
            "out=[]\n" +
            "ext=('.jpg','.jpeg','.png','.webp','.bmp','.gif')\n" +
            "try:\n" +
            "  for f in sorted(os.listdir(d),key=str.lower):\n" +
            "    fp=os.path.join(d,f)\n" +
            "    isd=os.path.isdir(fp)\n" +
            "    if isd or f.lower().endswith(ext):\n" +
            "      out.append({'name':f,'isDir':isd})\n" +
            "except: pass\n" +
            "print(json.dumps(out))",
            root.browseDir
        ]
        stdout: SplitParser {
            onRead: function(line) { lsProc._buf += line }
        }
        onExited: {
            try { root.browseEntries = JSON.parse(lsProc._buf) } catch(e) {}
            lsProc._buf = ""
        }
    }

    function browse(dir) {
        browseDir = dir
        lsProc.running = true
        browserVisible = true
    }

    function goUp() {
        var parts = browseDir.split("/")
        parts.pop()
        var parent = parts.join("/") || "/"
        browse(parent)
    }

    // Apply wallpaper
    function applyWallpaper() {
        if (!root.wallpaperPath) return
        root.applyRunning = true
        savePath.running = true
    }

    Process {
        id: savePath
        running: false
        command: ["python3", "-c",
            "import sys; open('/home/brad/.config/quickshell/.wallpaper','w').write(sys.argv[1]+'\\n')",
            root.wallpaperPath]
        onExited: awwwProc.running = true
    }
    Process {
        id: awwwProc
        running: false
        command: ["bash", "-c",
            "awww init 2>/dev/null || true; awww img \"$1\" --transition-type grow --transition-duration 1 --transition-fps 60",
            "--", root.wallpaperPath]
        stderr: SplitParser { onRead: function(l) { console.warn("awww:", l) } }
        onExited: function(code, status) {
            console.log("awww exited code=" + code)
            matugenProc.running = true
        }
    }
    Process {
        id: matugenProc
        running: false
        command: ["matugen", "image", root.wallpaperPath,
            "-t", schemePicker.currentText, "--prefer=saturation"]
        stderr: SplitParser { onRead: function(l) { console.warn("matugen:", l) } }
        onExited: function(code, status) {
            console.log("matugen exited code=" + code)
            colorReader.running = true
        }
    }
    Process {
        id: colorReader
        running: false
        property string _buf: ""
        command: ["cat", "/home/brad/.config/quickshell/colors/matugen.json"]
        stdout: SplitParser { onRead: function(line) { colorReader._buf += line } }
        onExited: {
            Settings.applyColors(colorReader._buf)
            colorReader._buf = ""
            root.applyRunning = false
        }
    }

    // ── Layout ───────────────────────────────────────────────────────────
    ColumnLayout {
        anchors { fill: parent; margins: 14 }
        spacing: 10

        // Header
        RowLayout {
            Layout.fillWidth: true
            Text {
                text: root.browserVisible ? " File Browser" : " Settings"
                color: "#dfe3e8"; font.pixelSize: 15; font.bold: true
            }
            Item { Layout.fillWidth: true }
            Text {
                text: "✕"; color: "#8b9198"; font.pixelSize: 14
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        if (root.browserVisible) root.browserVisible = false
                        else Settings.settingsWindowVisible = false
                    }
                }
            }
        }

        Rectangle { Layout.fillWidth: true; height: 1; color: "#33ffffff" }

        // ── File browser (shown when browsing) ───────────────────────────
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            visible: root.browserVisible
            spacing: 6

            // Current path
            Text {
                Layout.fillWidth: true
                text: root.browseDir
                color: "#8b9198"; font.pixelSize: 10
                elide: Text.ElideLeft
            }

            // Up button
            Rectangle {
                Layout.fillWidth: true; height: 28
                color: upHov ? "#33ffffff" : "#1affffff"; radius: 5
                property bool upHov: false
                RowLayout {
                    anchors { fill: parent; leftMargin: 8 }
                    Text { text: ""; color: "#dfe3e8"; font.pixelSize: 12 }
                    Text { text: "..  (go up)"; color: "#c1c7ce"; font.pixelSize: 11 }
                }
                MouseArea {
                    anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    onEntered: parent.upHov = true
                    onExited:  parent.upHov = false
                    onClicked: root.goUp()
                }
            }

            // Entries list
            ScrollView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true

                ListView {
                    id: fileList
                    model: root.browseEntries
                    spacing: 2

                    delegate: Rectangle {
                        required property var  modelData
                        required property int  index
                        width: fileList.width; height: 28
                        color: hov ? "#33ffffff" : "transparent"; radius: 5
                        property bool hov: false

                        RowLayout {
                            anchors { fill: parent; leftMargin: 8 }
                            spacing: 6
                            Text {
                                text: modelData.isDir ? "" : ""
                                color: modelData.isDir ? "#94cdf7" : "#cec0e8"
                                font.pixelSize: 12
                            }
                            Text {
                                text: modelData.name
                                color: "#dfe3e8"; font.pixelSize: 11
                                Layout.fillWidth: true
                                elide: Text.ElideRight
                            }
                        }
                        MouseArea {
                            anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                            hoverEnabled: true
                            onEntered: parent.hov = true
                            onExited:  parent.hov = false
                            onClicked: {
                                if (modelData.isDir) {
                                    root.browse(root.browseDir + "/" + modelData.name)
                                } else {
                                    root.wallpaperPath = root.browseDir + "/" + modelData.name
                                    root.browserVisible = false
                                }
                            }
                        }
                    }
                }
            }
        }

        // ── Main settings (hidden while browsing) ────────────────────────
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: false
            visible: !root.browserVisible
            spacing: 10

            // Wallpaper section label
            Text { text: "Wallpaper"; color: "#94cdf7"; font.pixelSize: 12; font.bold: true }

            // Path display
            Rectangle {
                Layout.fillWidth: true; height: 28
                color: "#1affffff"; radius: 5
                Text {
                    anchors { fill: parent; leftMargin: 8; rightMargin: 8 }
                    text: root.wallpaperPath || "No wallpaper selected"
                    color: root.wallpaperPath ? "#c1c7ce" : "#555"
                    font.pixelSize: 10; elide: Text.ElideLeft
                    verticalAlignment: Text.AlignVCenter
                }
            }

            // Preview
            Image {
                Layout.fillWidth: true
                Layout.preferredHeight: 72
                Layout.maximumHeight: 72
                source: root.wallpaperPath ? "file://" + root.wallpaperPath : ""
                fillMode: Image.PreserveAspectCrop
                visible: root.wallpaperPath !== ""
                clip: true
            }

            // Browse button
            Rectangle {
                Layout.fillWidth: true; height: 32
                color: brHov ? "#44ffffff" : "#22ffffff"; radius: 6
                property bool brHov: false
                Text {
                    anchors.centerIn: parent
                    text: "  Browse…"
                    color: "#dfe3e8"; font.pixelSize: 12
                }
                MouseArea {
                    anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    onEntered: parent.brHov = true
                    onExited:  parent.brHov = false
                    onClicked: root.browse(root.browseDir)
                }
            }

            Rectangle { Layout.fillWidth: true; height: 1; color: "#22ffffff" }

            // Scheme
            Text { text: "Color Scheme"; color: "#94cdf7"; font.pixelSize: 12; font.bold: true }

            ComboBox {
                id: schemePicker
                Layout.fillWidth: true
                model: [
                    "scheme-tonal-spot",
                    "scheme-vibrant",
                    "scheme-expressive",
                    "scheme-fruit-salad",
                    "scheme-monochrome",
                    "scheme-rainbow",
                    "scheme-fidelity",
                    "scheme-neutral"
                ]
                font.pixelSize: 12
                contentItem: Text {
                    leftPadding: 8
                    text: schemePicker.displayText
                    color: "#dfe3e8"; font: schemePicker.font
                    verticalAlignment: Text.AlignVCenter
                }
                background: Rectangle {
                    color: schemePicker.hovered ? "#44ffffff" : "#22ffffff"
                    radius: 6
                }
            }

            // Apply
            Rectangle {
                Layout.fillWidth: true; height: 34; radius: 6
                color: apHov ? "#cc94cdf7" : "#8894cdf7"
                property bool apHov: false
                Text {
                    anchors.centerIn: parent
                    text: root.applyRunning ? "Applying…" : "  Apply"
                    color: "#101417"; font.pixelSize: 12; font.bold: true
                }
                MouseArea {
                    anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    onEntered: parent.apHov = true
                    onExited:  parent.apHov = false
                    onClicked: root.applyWallpaper()
                }
            }

            // Reset Colors
            Rectangle {
                Layout.fillWidth: true; height: 30; radius: 6
                color: rstHov ? "#44ffffff" : "#22ffffff"
                property bool rstHov: false
                Text {
                    anchors.centerIn: parent
                    text: "Reset Colors"
                    color: "#dfe3e8"; font.pixelSize: 11
                }
                MouseArea {
                    anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    onEntered: parent.rstHov = true
                    onExited:  parent.rstHov = false
                    onClicked: Settings.resetColors()
                }
            }
        }
    }
}
