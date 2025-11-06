import Quickshell // for PanelWindow
import Quickshell.Io
import QtQuick // for Text
import QtQuick.Controls
import Quickshell.Widgets
import QtQuick.Layouts
import QtQuick.Shapes
import QtQml
import "../services"
import "../decorations"
import "../items"
import "../"

BarModuleItem {
    id:root
    Item {
        id:batteryDecor
        implicitWidth: root.scaleHeightMin*1.5
        implicitHeight:root.scaleHeightMin*0.7
        scale:0.8
        ProgressBarItem {
            id: progressBar
            width: parent.width*0.8
            height:parent.height
            anchors.left: parent.left
            from: 0
            value: Battery.batteryLevel
            to: 100
        }
        Rectangle {
            anchors.right: parent.right
            anchors.verticalCenter:parent.verticalCenter
            anchors.rightMargin: parent.width*0.05
            topRightRadius:parent.height*0.1
            bottomRightRadius:parent.height*0.1
            width: parent.width*0.1
            height:parent.height/2
            color: root.config?.progressBarProps?.borderColor
        }
        BarContentItem {
            anchors.fill: progressBar
            anchors.horizontalCenter: parent.horizontalCenter
            contentItem: TextItem {
                text: Battery.batteryLevel + (Battery.isCharging ? "󱐋" : Battery.isPluggedIn ? "󰚥" : "")
                color: root.config?.progressBarProps?.textColor
            }
            onClicked: {
                Settings.curridx = root.uniqueIndex == Settings.curridx ? -1 : root.uniqueIndex
            }
        }
    }
    onConfigChanged: {
        progressBar.contentloader.setSource(root.config?.progressBarProps?.fgSource,
        root.config?.progressBarProps?.fgProps)
        progressBar.backgroundloader.setSource(root.config?.progressBarProps?.bgSource,
        root.config?.progressBarProps?.bgProps)

        sld.handleloader.setSource(root.config?.sliderProps?.source,
        root.config?.sliderProps?.properties,)
        sld.backgroundloader.setSource(root.config?.sliderProps?.source,
        root.config?.sliderProps?.properties)
    }
}
