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
    property color borderClr: "red"
    property real borderWidthScale: 0.1
    property real radius: 0
    Rectangle {
        anchors.centerIn: root
        color: root.clr
        width: root.width
        height: root.height
        border.color: root.borderClr
        border.width: root.height*root.borderWidthScale
        border.pixelAligned:true
        radius: root.radius
    }
}
