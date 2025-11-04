
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
    implicitHeight: 80
    implicitWidth: 80
    property list<color> colors: ["transparent","red","green","blue"]
    border.color: colors[1]
}

