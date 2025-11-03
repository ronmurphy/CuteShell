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
        // implicitHeight: modelData.height
        // implicitWidth: modelData.width
        WlrLayershell.layer: WlrLayer.Top
        visible: true
        color: "transparent"
        exclusionMode: ExclusionMode.Normal
        exclusiveZone: barContainer.height
        focusable:true
        Item {
            id: barContainer
            width: root.width
            height: 45 // dummy value, will be overwritten by config value

            // property real scaleFactor: root.width / Settings.scaleWidth
            Item {// root.width / settings.scalewidth * minheight
                id: bar
                property real widthScale: 1
                property real heightScale: 1
                width: parent.width*widthScale
                height: parent.height*heightScale
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
                    anchors.left: barContainer.left;
                    direction: FlexboxLayout.Row
                    // anchors.leftMargin: barContainer.actualHeight/2
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
                    anchors.horizontalCenter: bar.horizontalCenter
                    direction: FlexboxLayout.Row
                    height: bar.height
                    // HyprlandWindowModule{}
                    NiriWindowModule{}
                    CavaModule{id: cava}
                }
                FlexboxLayout {
                    id: right
                    objectName: "right"
                    anchors.right: bar.right
                    height: bar.height
                    direction: FlexboxLayout.RowReverse
                    // anchors.rightMargin: barContainer.actualHeight/2
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
                        target: barContainer; anchors.top: itemwindow.top
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
        // Here you define which popups have clickable areas,
        // ideally it should work automatically but for some reason
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

        // Connections {
        //     target: Settings
        //     function onPopupChanged() {
        //         rgn.childrenChanged()
        //     }
        // }
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

