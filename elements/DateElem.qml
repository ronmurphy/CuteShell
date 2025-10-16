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
    isscrollable: true;
    popupvisible: false

    BarContentItem {
        implicitWidth: root.scaleheightmin*2
        implicitHeight: root.scaleheightmin
        contentItem: TextItem {
            text: SysInfo2.clockdate
        }
        onBtnclick: {
           Settings.curridx = root.indx == Settings.curridx ? -1 : root.indx
        }
    }
}

