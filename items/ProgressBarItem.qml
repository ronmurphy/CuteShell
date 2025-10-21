import QtQuick
import QtQuick.Controls.Basic
import Quickshell // for PanelWindow
import Quickshell.Io
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Widgets
import Quickshell.Wayland
import QtQuick.Shapes
import "../decorations"
import "../animations"
import "../"


pragma ComponentBehavior: Bound

ProgressBar {
    id: root
    value: 0.5
    padding: 0
    implicitWidth: 80
    implicitHeight: 40
    property real stepScale: 0.5 

    property Component backgroundDecor: Rectangle {
        color:Settings.dark
        radius:root.width*0.15
    }
    property Component contentDecor: Rectangle {
        color:Settings.white
        radius:19
    }
    
    background: Loader {
        id: loader
        anchors.fill: root
        sourceComponent: root.backgroundDecor
    }

    contentItem: Item {
        id: contitem
        width: root.width
        height:root.height
        Loader {
            // anchors.centerIn: contitem
            scale:0.8
            // anchors.margins:root.stepScale*root.width
            width:root.visualPosition * root.width
            height:root.height
            sourceComponent: root.contentDecor
        }
    }
}
