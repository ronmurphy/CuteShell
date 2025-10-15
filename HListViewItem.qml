import Quickshell // for PanelWindow
import Quickshell.Io
import QtQuick // for Text
import QtQuick.Controls
import Quickshell.Widgets
import QtQuick.Layouts
import QtQuick.Shapes
import QtQml

ListView {
    id: root
    layoutDirection: Qt.LeftToRight
    verticalLayoutDirection: ListView.TopToBottom
    orientation: horizontal ? Qt.Horizontal : Qt.Vertical
    implicitWidth: 80
    implicitHeight: 200
    property var datamodel: null
    property Component delegatecmpnnt: null
    property bool horizontal: true
    delegate: delegatecmpnnt
    model: datamodel
}

