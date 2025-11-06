import Quickshell // for PanelWindow
import Quickshell.Io
import QtQuick // for Text
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Widgets
import Quickshell.Wayland
import "./modules"
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
        exclusiveZone: barContainer.height
        focusable:true
        Item {
            id: barContainer
            width: root.width
            height: 45 // will be overwritten by config value
            Item {
                id: bar
                width: parent.width
                height: parent.height
                anchors.centerIn: parent
                Loader {
                    anchors.fill: bar
                }
                // here you define which bar modules will be positioned
                // on the left, center and right side of the bar respectively
                FlexboxLayout {
                    id: left
                    z:1
                    objectName: "left"
                    anchors.left: parent.left;
                    anchors.verticalCenter: parent.verticalCenter
                    direction: FlexboxLayout.Row
                    MenuModule{}
                    NiriWorkspaceModule{}
                    // HyprlandWorkspaceModule{}
                    CpuModule{}
                    DiskModule{}
                    AppLauncherModule{id: applauncher}
                    MemoryModule{}
                }
                FlexboxLayout {
                    id: center
                    objectName: "center"
                    anchors.centerIn: parent
                    direction: FlexboxLayout.Row
                    // HyprlandWindowModule{}
                    NiriWindowModule{}
                    CavaModule{id: cava}
                }
                FlexboxLayout {
                    id: right
                    objectName: "right"
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    direction: FlexboxLayout.RowReverse
                    DateModule{}
                    BatteryModule{}
                    AudioModule{}
                    NetworkModule{id: network}
                    SystemTrayModule{}
                }
            }
            states: [
                State {
                    name: "top"
                    AnchorChanges {
                        target: barContainer;
                        anchors.top: itemwindow.top
                    }
                },
                State {
                    name: "bottom"
                    AnchorChanges {
                        target: barContainer; anchors.bottom: itemwindow.bottom
                    }
                }
            ]
        }
        // Here you define which popups have interactive areas,
        // this should work automatically but for some reason
        // rgn.regions list is still empty after Qt.createComponent and myComponent.createObject
        // i tried every workaround and it's still empty, but maybe it's a skill issue.
        mask: Region {
            item: barContainer
            id: rgn
            Region {
                item: applauncher.popupItem
                intersection: Intersection.Combine
            }
            Region {
                item: network.popupItem
                intersection: Intersection.Combine
            }
            Region {
                item: cava.popupItem
                intersection: Intersection.Combine
            }
        }
        Item {
            id: itemwindow
            anchors.fill: parent
        }

        Connections {
            target: Settings
            function onBarAnchorChanged() {
                barContainer.state = Settings.isTop ? "top" : "bottom"
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

