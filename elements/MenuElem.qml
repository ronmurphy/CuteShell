
import Quickshell // for PanelWindow
import Quickshell.Io
import QtQuick // for Text
import QtQuick.Controls
import Quickshell.Widgets
import QtQuick.Layouts
import QtQuick.Shapes
import Qt.labs.platform
import QtQml
import "../services"
import "../items"
import "../"

pragma ComponentBehavior: Bound 

BarElementItem {
    id:root
    BarContentItem {
        implicitWidth: root.scaleHeightMin
        implicitHeight: root.scaleHeightMin
        contentItem: TextItem {
            text: "Menu"
        }
        onBtnclick: {
            Settings.curridx = root.indx == Settings.curridx ? -1 : root.indx
            SysTray.systraydo()
        }
    }
    ListView {
        id:listv
        implicitWidth: root.indx == Settings.curridx ? root.scaleHeightMin*3 : root.scaleHeightMin
        implicitHeight: root.scaleHeightMin
        model: SysTray.systrayItems
        layoutDirection: Qt.LeftToRight
        orientation: Qt.Horizontal
        delegate: BarContentItem {
            id: del
            required property int index
            implicitWidth: root.scaleHeightMin
            implicitHeight: root.scaleHeightMin
            
            contentItem: Image {
                source: SysTray.systrayItems[index].icon
            }

            onBtnclick: {
            }
        }
    }
}


