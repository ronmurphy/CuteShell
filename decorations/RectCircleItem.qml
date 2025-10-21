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
    property color clr: "blue"
    color: "transparent"
    CircleItem {
        anchors.left: root.left
        inverted: true
        clr: root.clr
        width: root.height/2
        height: root.height
    }
    Rectangle {
        anchors.centerIn: root
        color: root.clr
        width: root.width-root.height
        height: root.height
    }
    CircleItem {
        anchors.right: root.right

        clr: root.clr
        inverted: false
        width: root.height/2
        height: root.height
    }
}

