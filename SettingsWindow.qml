import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import "./services"

PanelWindow {
    id: root

    anchors.top:  true
    anchors.left: true
    margins.top:  46
    margins.left: 0

    width:  300
    height: 320

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

    // ── Layout ───────────────────────────────────────────────────────────
    ColumnLayout {
        anchors { fill: parent; margins: 14 }
        spacing: 10

        // Header
        RowLayout {
            Layout.fillWidth: true
            Text {
                text: "Settings"
                color: "#dfe3e8"; font.pixelSize: 15; font.bold: true
            }
            Item { Layout.fillWidth: true }
            Text {
                text: "\u2715"; color: "#8b9198"; font.pixelSize: 14
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Settings.settingsWindowVisible = false
                }
            }
        }

        Rectangle { Layout.fillWidth: true; height: 1; color: "#33ffffff" }

        // Wallpaper section
        Text { text: "Wallpaper"; color: "#94cdf7"; font.pixelSize: 12; font.bold: true }

        // Current wallpaper path
        Rectangle {
            Layout.fillWidth: true; height: 28
            color: "#1affffff"; radius: 5
            Text {
                anchors { fill: parent; leftMargin: 8; rightMargin: 8 }
                text: WallpaperService.currentWallpaper || "No wallpaper selected"
                color: WallpaperService.currentWallpaper ? "#c1c7ce" : "#555"
                font.pixelSize: 10; elide: Text.ElideLeft
                verticalAlignment: Text.AlignVCenter
            }
        }

        // Preview
        Image {
            Layout.fillWidth: true
            Layout.preferredHeight: 72
            Layout.maximumHeight: 72
            source: WallpaperService.currentWallpaper ? "file://" + WallpaperService.currentWallpaper : ""
            fillMode: Image.PreserveAspectCrop
            visible: WallpaperService.currentWallpaper !== ""
            clip: true
        }

        // Browse / Pick wallpaper
        Rectangle {
            Layout.fillWidth: true; height: 32
            color: brHov ? "#44ffffff" : "#22ffffff"; radius: 6
            property bool brHov: false
            Text {
                anchors.centerIn: parent
                text: "Change Wallpaper..."
                color: "#dfe3e8"; font.pixelSize: 12
            }
            MouseArea {
                anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
                onEntered: parent.brHov = true
                onExited:  parent.brHov = false
                onClicked: WallpaperService.togglePicker()
            }
        }

        Rectangle { Layout.fillWidth: true; height: 1; color: "#22ffffff" }

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

        Item { Layout.fillHeight: true }
    }
}
