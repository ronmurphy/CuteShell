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
    TriangleItem {
        anchors.left: root.left
        width: root.height/2
        height: root.height
        inverted: false
        clr: root.clr
    }
    Rectangle {
        anchors.centerIn: root
        color: root.clr
        width: root.width-root.height+1
        height: root.height
    }
    TriangleItem {
        anchors.right: root.right
        width: root.height/2
        height: root.height
        inverted: true
        clr: root.clr
    }
}
