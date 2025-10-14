import Quickshell // for PanelWindow
import Quickshell.Io
import QtQuick // for Text
import QtQuick.Controls
import Quickshell.Widgets
import QtQuick.Layouts
import QtQuick.Shapes
import QtQml

Item {
    id: root
    implicitWidth: 120
    implicitHeight: 40
    property color clr: "blue"
    CircleItem {
        anchors.left: root.left
        inverted: true
        clr: "green"
        width: root.height/2
        height: root.height
    }
    Rectangle {
        anchors.centerIn: root
        color: "red"
        // color: root.clr
        width: root.width-root.height
        height: root.height
    }
    CircleItem {
        anchors.right: root.right

        clr: "purple"
        inverted: false
        width: root.height/2
        height: root.height
    }
}

