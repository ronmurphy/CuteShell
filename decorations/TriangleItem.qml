import Quickshell // for PanelWindow
import Quickshell.Io
import QtQuick // for Text
import QtQuick.Controls
import Quickshell.Widgets
import QtQuick.Layouts
import QtQuick.Shapes
import QtQml


Rectangle {
    id: root
    property color clr: "blue"
    property bool inverted: false
    property real implicitSize: 40
    color: "transparent"
    Shape {
        anchors.fill: parent
        ShapePath {
            strokeWidth: -1
            fillColor: root.clr 
            startX: root.inverted == false ? root.width : 0
            startY: 0
            PathLine { x: root.inverted == false ?
                root.width : 0; y: root.height }
            PathLine { x: root.inverted == false ?
                root.width-(root.height/2) : root.width; y: root.height / 2 }
            PathLine { x: root.inverted == false ?
                root.width : 0; y: 0 }

        }
    }
}
