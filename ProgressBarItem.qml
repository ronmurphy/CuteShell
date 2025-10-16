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
    property real stepScale: 0.1 

    property Component backgroundDecor: Rectangle {
        color:Settings.dark
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
            // anchors.centerIn: root
            width:root.visualPosition * root.width
            height:root.height
            sourceComponent: root.contentDecor
        }
    }
}
