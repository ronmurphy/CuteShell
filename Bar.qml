import Quickshell // for PanelWindow
import Quickshell.Io
import QtQuick // for Text
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Widgets
import Quickshell.Wayland
import "./elements"
import "./services"

pragma ComponentBehavior: Bound

Variants {
    model: Quickshell.screens
    delegate: PanelWindow {
        id: root
        required property ShellScreen modelData
        screen: modelData
        property real scalefW: width/Settings.scaleWidth
        property real scalefH: height/Settings.scaleHeight
        height: modelData.height
        width: modelData.width
        WlrLayershell.layer: WlrLayer.Top
        visible: true
        color: "transparent"
        exclusionMode: ExclusionMode.Normal
        exclusiveZone: bar.scaleHeight
        focusable:true
        Rectangle {
            id: bar
            color: "transparent"
            width: parent.width
            height: scaleHeight
            property real minheight: 50
            property real scaleFactor: parent.width / Settings.scaleWidth
            property real scaleHeight: scaleFactor*minheight
            // here you define which bar elements will be positioned
            // on the left, center and right side of the bar respectively
            FlexboxLayout {
                id: left
                objectName: "left"
                anchors.left: bar.left
                direction: FlexboxLayout.Row
                height: bar.scaleHeight
                NiriWorkspaceElem{}
                // HyprlandWorkspaceElem{}
                CpuElem{}
                DiskElem{}
                AppLauncherElem{id: applauncher}
                MemoryElem{}
                MenuElem{}
            }
            FlexboxLayout {
                id: center
                objectName: "center"
                anchors.horizontalCenter: bar.horizontalCenter
                direction: FlexboxLayout.Row
                height: bar.scaleHeight
                // HyprlandWindowElem{}
                NiriWindowElem{}
                CavaElem{}
            }
            FlexboxLayout {
                id: right
                objectName: "right"
                anchors.right: bar.right
                height: bar.scaleHeight
                direction: FlexboxLayout.RowReverse
                NetworkElem{id: network}
                BatteryElem{}
                AudioElem{}
                DateElem{}
            }
            states: [
                State {
                    name: "top"
                    AnchorChanges {
                        target: bar; anchors.top: itemwindow.top
                    }
                },
                State {
                    name: "bottom"
                    AnchorChanges {
                        target: bar; anchors.bottom: itemwindow.bottom
                    }
                }
            ]
        }
        // Here you define which popups have clickable areas,
        // ideally it should work automatically but for some reason
        // rgn.regions list is still empty after Qt.createComponent and myComponent.createObject
        // i tried every workaround and it's still empty, but maybe it's a skill issue.
        mask: Region {
            item: bar
            id: rgn
            Region {
                item: applauncher.popupItem
                intersection: Intersection.Combine
            }
            Region {
                item: network.popupItem
                intersection: Intersection.Combine
            }
        }
        Item {
            id: itemwindow
            anchors.fill: parent
        }

        // Connections {
        //     target: Settings
        //     function onPopupChanged() {
        //         rgn.childrenChanged()
        //     }
        // }
        Connections {
            target: Settings
            function onBarAnchorChanged() {
                bar.state = Settings.isTop ? "top" : "bottom"
            }
        }
        anchors {
            left: false
            top: Settings.isTop ? true : false
            right: false
            bottom: Settings.isTop ? false : true
        }
        margins {
            top: 0
            right: 0
            left: 0
            bottom: 0
        }
    }
}

