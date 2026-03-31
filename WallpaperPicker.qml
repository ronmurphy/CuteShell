import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import "./services"

PanelWindow {
    id: pickerWin
    visible: WallpaperService.pickerVisible
    focusable: true
    color: "transparent"

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
    WlrLayershell.namespace: "qdm-wallpaper"

    exclusionMode: ExclusionMode.Ignore
    anchors { top: true; bottom: true; left: true; right: true }

    property string searchText: ""
    property string previewPath: ""
    property string selectedScheme: "scheme-tonal-spot"

    property var filteredWallpapers: {
        var q = searchText.toLowerCase()
        if (q === "") return WallpaperService.wallpapers
        return WallpaperService.wallpapers.filter(function(p) {
            return p.split("/").pop().toLowerCase().includes(q)
        })
    }

    // ── Dark backdrop ────────────────────────────────────────────────
    MouseArea {
        anchors.fill: parent
        onClicked: WallpaperService.pickerVisible = false

        Rectangle {
            anchors.fill: parent
            color: "#cc000000"
        }
    }

    // ── Picker box ───────────────────────────────────────────────────
    Rectangle {
        anchors.centerIn: parent
        width: 740; height: 560
        radius: 14
        color: "#1a1a2e"
        border.color: "#333348"; border.width: 1

        MouseArea { anchors.fill: parent; onClicked: function(e) { e.accepted = true } }

        // Scheme dropdown — lives here (direct child of picker box) so it renders above the GridView
        Rectangle {
            id: schemePopup; visible: false
            x: schemeBtn.mapToItem(schemePopup.parent, 0, schemeBtn.height + 4).x
            y: schemeBtn.mapToItem(schemePopup.parent, 0, schemeBtn.height + 4).y
            width: 180; radius: 6; color: "#1a1a2e"; border.color: "#333"
            height: schemeCol.implicitHeight + 8
            z: 200

            MouseArea { anchors.fill: parent; onClicked: function(e) { e.accepted = true } }

            Column {
                id: schemeCol
                anchors.fill: parent
                anchors.margins: 4
                spacing: 2
                Repeater {
                    model: ["scheme-tonal-spot", "scheme-vibrant", "scheme-expressive",
                            "scheme-fidelity", "scheme-content", "scheme-neutral",
                            "scheme-monochrome", "scheme-fruit-salad", "scheme-rainbow"]
                    Rectangle {
                        required property string modelData
                        width: schemeCol.width; height: 24; radius: 4
                        color: schemeMa.containsMouse ? "#333" : "transparent"
                        Text {
                            anchors { left: parent.left; leftMargin: 8; verticalCenter: parent.verticalCenter }
                            text: modelData.replace("scheme-", ""); color: "#dfe3e8"; font.pixelSize: 11
                        }
                        MouseArea {
                            id: schemeMa; anchors.fill: parent; hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: { pickerWin.selectedScheme = modelData; schemePopup.visible = false }
                        }
                    }
                }
            }
        }

        ColumnLayout {
            anchors.fill: parent; anchors.margins: 14; spacing: 10

            // Header
            RowLayout {
                Layout.fillWidth: true; spacing: 10
                Text { text: "Wallpaper"; color: "#dfe3e8"; font.pixelSize: 14; font.bold: true }
                Item { Layout.fillWidth: true }
                Text {
                    text: pickerWin.filteredWallpapers.length + " images"
                    color: "#888"; font.pixelSize: 11
                }
                // Refresh
                Rectangle {
                    width: 26; height: 26; radius: 13
                    color: refreshMa.containsMouse ? "#333" : "transparent"
                    Text { anchors.centerIn: parent; text: "R"; color: "#888"; font.pixelSize: 12; font.bold: true }
                    MouseArea {
                        id: refreshMa; anchors.fill: parent; hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: WallpaperService.rescan()
                    }
                }
                // Close
                Rectangle {
                    width: 26; height: 26; radius: 13
                    color: closeMa.containsMouse ? "#433" : "transparent"
                    Text { anchors.centerIn: parent; text: "X"; color: "#888"; font.pixelSize: 12; font.bold: true }
                    MouseArea {
                        id: closeMa; anchors.fill: parent; hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: WallpaperService.pickerVisible = false
                    }
                }
            }

            // Search + scheme row
            RowLayout {
                Layout.fillWidth: true; spacing: 8

                Rectangle {
                    Layout.fillWidth: true; height: 32; radius: 6
                    color: "#22ffffff"
                    border.color: searchInput.activeFocus ? "#94cdf7" : "#333"
                    TextInput {
                        id: searchInput
                        anchors { fill: parent; leftMargin: 10; rightMargin: 10 }
                        verticalAlignment: TextInput.AlignVCenter
                        color: "#dfe3e8"; font.pixelSize: 12
                        clip: true; selectByMouse: true
                        onTextChanged: pickerWin.searchText = text
                        Keys.onEscapePressed: {
                            if (pickerWin.previewPath !== "") pickerWin.previewPath = ""
                            else WallpaperService.pickerVisible = false
                        }
                    }
                    Text {
                        anchors { left: parent.left; leftMargin: 10; verticalCenter: parent.verticalCenter }
                        text: "Search wallpapers..."
                        color: "#666"; font.pixelSize: 12
                        visible: searchInput.text === "" && !searchInput.activeFocus
                    }
                }

                // Scheme picker button
                Rectangle {
                    id: schemeBtn
                    width: 160; height: 32; radius: 6; color: "#22ffffff"
                    RowLayout {
                        anchors { fill: parent; leftMargin: 8; rightMargin: 8 }
                        Text {
                            Layout.fillWidth: true
                            text: pickerWin.selectedScheme.replace("scheme-", "")
                            color: "#dfe3e8"; font.pixelSize: 11
                            elide: Text.ElideRight
                        }
                        Text { text: "v"; color: "#888"; font.pixelSize: 10 }
                    }
                    MouseArea {
                        anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                        onClicked: schemePopup.visible = !schemePopup.visible
                    }
                }
            }

            // ── Grid ─────────────────────────────────────────────────
            GridView {
                id: grid
                Layout.fillWidth: true; Layout.fillHeight: true
                cellWidth: Math.floor(width / 4)
                cellHeight: cellWidth * 0.6 + 8
                clip: true; boundsBehavior: Flickable.StopAtBounds
                model: pickerWin.filteredWallpapers

                delegate: Item {
                    required property string modelData
                    width: grid.cellWidth; height: grid.cellHeight

                    Rectangle {
                        anchors { fill: parent; margins: 3 }
                        radius: 6; color: "#22ffffff"; clip: true
                        border.color: WallpaperService.currentWallpaper === modelData ? "#94cdf7" : (imgMa.containsMouse ? "#555" : "transparent")
                        border.width: WallpaperService.currentWallpaper === modelData ? 2 : 1

                        Image {
                            anchors { fill: parent; margins: 2 }
                            source: "file://" + modelData
                            fillMode: Image.PreserveAspectCrop
                            sourceSize.width: 200; sourceSize.height: 120
                            asynchronous: true

                            Rectangle {
                                anchors.fill: parent; color: "#1a1a2e"
                                visible: parent.status !== Image.Ready
                                Text { anchors.centerIn: parent; text: "..."; color: "#666"; font.pixelSize: 14 }
                            }
                        }

                        // Filename
                        Rectangle {
                            anchors { bottom: parent.bottom; left: parent.left; right: parent.right }
                            height: 20; color: "#99000000"
                            Text {
                                anchors.centerIn: parent
                                text: modelData.split("/").pop()
                                color: "#ccc"; font.pixelSize: 9
                                elide: Text.ElideMiddle; width: parent.width - 6
                                horizontalAlignment: Text.AlignHCenter
                            }
                        }

                        // Active badge
                        Rectangle {
                            anchors { top: parent.top; right: parent.right; margins: 5 }
                            width: 16; height: 16; radius: 8; color: "#4caf50"
                            visible: WallpaperService.currentWallpaper === modelData
                            Text { anchors.centerIn: parent; text: "ok"; color: "#fff"; font.pixelSize: 7 }
                        }

                        MouseArea {
                            id: imgMa; anchors.fill: parent; hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            acceptedButtons: Qt.LeftButton | Qt.RightButton
                            onClicked: function(mouse) {
                                if (mouse.button === Qt.RightButton)
                                    pickerWin.previewPath = modelData
                                else
                                    WallpaperService.setWallpaper(modelData, pickerWin.selectedScheme)
                            }
                        }
                    }
                }

                // Empty state
                Text {
                    anchors.centerIn: parent; visible: grid.count === 0
                    text: "No wallpapers found\nAdd images to ~/Pictures/"
                    color: "#666"; font.pixelSize: 13; horizontalAlignment: Text.AlignHCenter
                }
            }

            // Footer
            RowLayout {
                Layout.fillWidth: true; spacing: 12
                Text { text: "click = apply  |  right-click = preview  |  esc = close"; color: "#555"; font.pixelSize: 10 }
                Item { Layout.fillWidth: true }
                // Reset colors
                Text {
                    text: "Reset Colors"
                    color: rstMa.containsMouse ? "#dfe3e8" : "#888"
                    font.pixelSize: 10
                    MouseArea {
                        id: rstMa; anchors.fill: parent; hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: Settings.resetColors()
                    }
                }
            }
        }
    }

    // ── Preview overlay ──────────────────────────────────────────────
    Rectangle {
        anchors.fill: parent; color: "#dd000000"
        visible: pickerWin.previewPath !== ""

        MouseArea { anchors.fill: parent; onClicked: pickerWin.previewPath = "" }

        Image {
            anchors.centerIn: parent
            width: parent.width * 0.85; height: parent.height * 0.85
            source: pickerWin.previewPath !== "" ? "file://" + pickerWin.previewPath : ""
            fillMode: Image.PreserveAspectFit; asynchronous: true
        }

        Rectangle {
            anchors { bottom: parent.bottom; horizontalCenter: parent.horizontalCenter; bottomMargin: 40 }
            width: applyRow.width + 28; height: 36; radius: 18; color: "#94cdf7"
            Row {
                id: applyRow; anchors.centerIn: parent; spacing: 6
                Text { text: "Apply Wallpaper"; color: "#101417"; font.pixelSize: 12; font.bold: true }
            }
            MouseArea {
                anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                onClicked: {
                    WallpaperService.setWallpaper(pickerWin.previewPath, pickerWin.selectedScheme)
                    pickerWin.previewPath = ""
                }
            }
        }
    }
}
