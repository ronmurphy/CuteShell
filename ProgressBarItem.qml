import QtQuick
import QtQuick.Controls.Basic
import "./decorations"

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
    }
    
    background: Loader {
        id: loader
        anchors.fill: root
        sourceComponent: root.backgroundDecor
    }

    contentItem: Item {
        width: root.width
        height:root.height
        Loader {
            anchors.centerIn: root
            scale:0.6
            // anchors.margins:root.stepScale*root.width
            width:root.visualPosition * root.width
            height:root.height
            sourceComponent: root.contentDecor
        }
    }
}
