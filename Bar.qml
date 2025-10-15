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
        height: modelData.height/2
        // height: Settings.barAnchor == Settings.barAnchors.TOP ? modelData.height : bar.scaleheightmin
        // height: Settings.isTop ? modelData.height : modelData.height-bar.scaleheightmin
        width: modelData.width
        WlrLayershell.layer: WlrLayer.Top
        visible: true
        color: "transparent"
        exclusionMode: ExclusionMode.Normal
        exclusiveZone: bar.scaleheightmin
        focusable:true

        Connections {
            target: Settings
            function onPopupOpenChanged() {
                regions.childrenChanged()

            }
        }
        Connections {
            target: Settings
            function onBarAnchorChanged() {
                console.log("hot shto n")
                bar.state = "bottom"
            }
        }
        mask: Region {
            item: bar
            id: regions
            onChanged: {
                console.log("HEH")
            }
            Region {
                item: Settings.popupLoader
                intersection: Intersection.Combine
            }
        }
        Item {
            id: itemwindow
            anchors.fill: parent
        }
        Rectangle {
            id: bar
            color: "white"
            // anchors.top: Settings.barAnchor == Settings.barAnchors.TOP ? parent.top : null
            // anchors.bottom: Settings.barAnchor == Settings.barAnchors.TOP ? null : parent.bottom
            width: parent.width
            height: scaleheightmin
            property real minheight: 45
            property real scaleFactor: parent.width / Settings.scaleWidth
            property real scaleheightmin: scaleFactor*minheight
            FlexboxLayout {
                id: left
                objectName: "left"
                anchors.left: bar.left
                direction: FlexboxLayout.Row
                height: bar.scaleheightmin
                // NiriWorkspaceElem{ indx: 1}
                CpuElem{}
                DiskElem{}
                AppLauncherElem{}
                // MemoryElem{ indx: 4 }
                // MenuElem{ indx: 5 }
            }
            FlexboxLayout {
                id: center
                objectName: "center"
                anchors.centerIn: bar
                direction: FlexboxLayout.Row
                height: bar.scaleheightmin
                // NiriWindowElem{ clr: Settings.windowcolors[0]; clrtrngl: Settings.windowcolors[1]; indx: 6}
                // CavaElem{ clr: Settings.windowcolors[0]; clrtrngl: Settings.windowcolors[1]; indx: 7}
            }
            FlexboxLayout {
                id: right
                objectName: "right"
                anchors.right: bar.right
                height: bar.scaleheightmin
                direction: FlexboxLayout.RowReverse
                NetworkElem{ }
                // BatteryElem{ indx: 10}
                AudioElem{ }
                // DateElem{ indx: 8}
            }
            Component.onCompleted: {
                bar.state = Settings.barAnchor == Settings.barAnchors.TOP ? "top" : "bottom"
                console.log(state,"HAEFbhbirbvjidfvnjfknj11")
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


        anchors {
            left: false
            top: Settings.barAnchor === Settings.barAnchors.TOP ? true : false
            right: false
            bottom: Settings.barAnchor === Settings.barAnchors.TOP ? false : true
        }
        margins {
            top:0
            right:0
            left:0
            bottom:0
        }

    }
}

