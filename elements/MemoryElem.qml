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

BarElementItem {
    id:root
    BarContentItem {
        implicitHeight: root.scaleHeightMin
        implicitWidth: root.scaleHeightMin*2
        contentItem: TextItem {
            text: SysInfo2.memPercent + "% " + SysInfo2.memGb + " GB"
        }
        onBtnclick: {
           Settings.curridx = root.uniqueIndex == Settings.curridx ? -1 : root.uniqueIndex
        }
    }
}


