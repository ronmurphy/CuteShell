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
    color: colors[0]
    property bool highlightBottom: false
    property bool highlightLeft: false
    property bool highlightRight: false
    Rectangle {
        visible: root.highlightBottom
        id: highlightbtm
        color: root.colors[1]
        width: root.width*0.8
        height: root.height/5
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }
    Rectangle {
        visible: root.highlightRight
        id: highlightrgt
        color: root.colors[2]
        width: root.width/5
        height: root.height*0.8
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
    }
    Rectangle {
        visible: root.highlightLeft
        id: highlightlft
        color: root.colors[2]
        width: root.width/5
        height: root.height*0.8
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
    }
}

