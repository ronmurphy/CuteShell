import Quickshell // for PanelWindow
import Quickshell.Io
import QtQuick // for Text
import QtQuick.Controls
import Quickshell.Widgets
import QtQuick.Layouts
import QtQuick.Shapes
import QtQml

GenericDecorItem {
    id: root
    implicitWidth: 120
    implicitHeight: 40
    color: root.colors[0]
    CircleItem {
        anchors.left: root.left
        inverted: true
        clr: root.colors[1]
        width: root.height/2
        height: root.height
    }
    Rectangle {
        anchors.centerIn: root
        color: root.colors[1]
        width: root.width-root.height
        height: root.height
    }
    CircleItem {
        anchors.right: root.right

        clr: root.colors[1]
        inverted: false
        width: root.height/2
        height: root.height
    }
}

