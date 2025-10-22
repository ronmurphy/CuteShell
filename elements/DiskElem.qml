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
        implicitWidth: root.scaleHeightMin
        implicitHeight: root.scaleHeightMin
        contentItem: TextItem {
            text: SysInfo2.diskPercent + " " +SysInfo2.diskAvail
        }
        onBtnclick: {
           Settings.curridx = root.uniqueIndex == Settings.curridx ? -1 : root.uniqueIndex
        }
    }
}


