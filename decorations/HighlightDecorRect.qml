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
    property bool highlightBottom: false
    property bool highlightTop: false
    property bool highlightLeft: false
    property bool highlightRight: false
    property real scaleHeightMin: 45
    Rectangle {
        visible: root.highlightBottom
        id: highlightbtm
        color: root.colors[1]
        width: root.width
        height: root.scaleHeightMin/8
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }
    Rectangle {
        visible: root.highlightTop
        id: highlighttop
        color: root.colors[1]
        width: root.width
        height: root.scaleHeightMin/8
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
    }
    Rectangle {
        visible: root.highlightRight
        id: highlightrgt
        color: root.colors[2]
        width: root.scaleHeightMin/14
        height: root.scaleHeightMin*0.5
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
    }
    Rectangle {
        visible: root.highlightLeft
        id: highlightlft
        color: root.colors[2]
        width: root.scaleHeightMin/14
        height: root.scaleHeightMin*0.5
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
    }
}

