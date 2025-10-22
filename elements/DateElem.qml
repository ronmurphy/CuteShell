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
        implicitWidth: root.scaleHeightMin*2
        implicitHeight: root.scaleHeightMin
        contentItem: TextItem {
            text: SysInfo2.clockdate
        }
        onBtnclick: {
           Settings.curridx = root.indx == Settings.curridx ? -1 : root.indx
        }
    }
}

