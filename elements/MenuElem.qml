
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
import "../"

pragma ComponentBehavior: Bound 
BarItem {
    id:root
    isscrollable: true;
    popupvisible: false

    BarContentItem {
        implicitWidth: root.scaleheightmin
        implicitHeight: root.scaleheightmin
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
        implicitWidth: root.indx == Settings.curridx ? root.scaleheightmin*3 : root.scaleheightmin
        implicitHeight: root.defaultWidth
        model: SysTray.systrayItems
        layoutDirection: Qt.LeftToRight
        orientation: Qt.Horizontal
        delegate: BarContentItem {
            id: del
            required property int index
            implicitWidth: root.defaultWidth
            implicitHeight: root.defaultWidth
            
            contentItem: Image {
                source: SysTray.systrayItems[index].icon
            }

            onBtnclick: {
            }
        }
    }
}


