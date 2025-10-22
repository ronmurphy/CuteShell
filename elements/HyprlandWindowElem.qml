import Quickshell // for PanelWindow
import Quickshell.Io
import QtQuick // for Text
import QtQuick.Controls
import Quickshell.Widgets
import QtQuick.Layouts
import QtQuick.Shapes
import QtQml
import "../services"
import "../"

BarItem {
    id:root
    defaultWidth: scaleHeightMin*3
    BarContentItem {
        implicitWidth: root.defaultWidth
        implicitHeight: root.scaleHeightMin
        contentItem: TextItem {
            font.pointSize:12
            elide: Text.ElideRight
            fontSizeMode: Text.VerticalFit
            text: Hyprland.activetoplevel.title
        }
    }
}



