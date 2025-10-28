import QtQuick
import QtQuick.Controls.Basic

import "../decorations"

SwitchDelegate {
    id: root
    checked: true

    property Loader handleloader: handleLoader
    property Loader backgroundloader: backgroundLoader

    property Component backgroundDecor: RectTriangleItem {
        colors: ["transparent","grey"]
    }
    property Component handleDecor: RectTriangleItem {
        colors: ["transparent","green"]
    }
    implicitWidth: 80
    implicitHeight: 40
    indicator: Rectangle {
        width:root.width
        height: root.height
        color:"transparent"
        Loader {
            id: backgroundLoader
            anchors.fill: parent
            sourceComponent: root.backgroundDecor
        }

        Rectangle {
            x: root.checked ? parent.width - width : 0
            width: root.height*1.5
            height: root.height
            Loader {
                id: handleLoader
                anchors.fill: parent
                sourceComponent: root.handleDecor
            }
            color:"transparent"
        }
    }

    background: Rectangle {
        color:"transparent"
    }
}
