import Quickshell // for PanelWindow
import Quickshell.Io
import QtQuick // for Text
import QtQuick.Controls
import Quickshell.Widgets
import QtQuick.Layouts
import QtQuick.Shapes
import QtQml
import "../services"
import "../items"
import "../"

BarModuleItem {
    id:root
    BarContentItem {
        implicitHeight: root.scaleHeightMin
        implicitWidth: root.scaleHeightMin*1.5
        contentItem: TextItem {
            font.pointSize:12
            // elide: Text.ElideRight
            // fontSizeMode: Text.HorizontalFit
            text: "  "+SysInfo2.cpuUsage + "% "
            color: root.config.props.secondaryColor
        }
        onClicked: {
           Settings.curridx = root.uniqueIndex == Settings.curridx ? -1 : root.uniqueIndex
        }
    }
    BarContentItem {
        implicitHeight: root.scaleHeightMin
        implicitWidth: root.scaleHeightMin
        contentItem: TextItem {
            font.pointSize:12
            text: SysInfo2.cpuTemp + "  "
            color: root.config.props.secondaryColor
        }
        onClicked: {
           Settings.curridx = root.uniqueIndex == Settings.curridx ? -1 : root.uniqueIndex
        }
    }
}

