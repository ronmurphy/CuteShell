import QtQuick
import QtQuick.Controls.Basic

import "../decorations"

SwitchDelegate {
    id: root
    checked: true
    property Loader handleloader: handleLoader
    property Loader backgroundloader: backgroundLoader
    property Loader backgroundloaderon: backgroundLoaderOn

    property Component backgroundDecor: RectTriangleItem {
        colors: ["transparent","grey"]
    }
    property Component handleDecor: RectTriangleItem {
        colors: ["transparent","green"]
    }
    property Component backgroundDecorOn: RectTriangleItem {
        colors: ["transparent","yellow"]
    }
    implicitWidth: 80
    implicitHeight: 40
    indicator: Rectangle {
        width:root.width
        height: root.height
        color: "transparent"

        Loader {
            id: backgroundLoader
            anchors.fill: parent
            sourceComponent: root.backgroundDecor
        }
        Loader {
            visible: root.checked
            id: backgroundLoaderOn
            anchors.fill: parent
            sourceComponent: root.backgroundDecorOn
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
