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
    property bool inverted: false
    state: inverted ? "left" : "right"
    Rectangle {
        id: rect
        color: root.colors[1]
        width: root.width-root.height/2
        height: root.height
    }
}

