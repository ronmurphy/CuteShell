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

BarModuleItem {
    id:root
    visibleExpandedElements:2
    defaultWidth: visibleExpandedWidth
    BarContentItem {
        implicitWidth: root.scaleHeightMin
        implicitHeight: root.scaleHeightMin
        contentItem: TextItem {
            text: ""
            color: root.config.props.secondaryColor
        }
        onBtnclick: {
            Settings.curridx = root.uniqueIndex == Settings.curridx ? -1 : root.uniqueIndex
        }
    }
    ListView {
        id:listv
        implicitWidth: root.scaleHeightMin*3
        // implicitWidth: root.uniqueIndex == Settings.curridx ? root.scaleHeightMin*2 : root.scaleHeightMin
        implicitHeight: root.scaleHeightMin
        // focus:true
        displayMarginBeginning:root.scaleHeightMin*2
        displayMarginEnd:root.scaleHeightMin*2
        model: SysTray.systrayItems
        layoutDirection: Qt.LeftToRight
        orientation: Qt.Horizontal
        cacheBuffer:1000
        onAddTransitionChanged: {
            root.visibleExpandedElements+=1
        }
        delegate: BarContentItem {
            id: del
            required property int index
            implicitWidth: root.scaleHeightMin
            implicitHeight: root.scaleHeightMin
        
            contentItem: Image {
                source: SysTray.systrayItems[index].icon
            }

            onBtnclick: {
                SysTray.systrayItems[index].activate()
            }
        }
    }
}



