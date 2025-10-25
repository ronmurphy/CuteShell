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
    property Loader contentLoader: contentLoader
    property Loader backgroundLoader: backgroundLoader
    
    property Component backgroundDecor: Rectangle {
        color:"transparent"
        radius:root.width*0.15
        border.width: root.width*0.1
        border.color: "black"
    }
    property Component contentDecor: Rectangle {
        color:"white"
        radius:root.width*0.15
    }
    
    background: Loader {
        z:2
        id: backgroundLoader
        // anchors.fill: root
        sourceComponent: root.backgroundDecor
    }

    contentItem: Item {
        id: contentitem
        // anchors.fill: root
        Loader {
            width:root.position * contentitem.width
            height:root.height
            id: contentLoader
            sourceComponent: root.contentDecor
        }
    }
}
