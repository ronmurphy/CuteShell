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

BarElementItem {
    id:root
    Item {
        id:batteryDecor
        implicitWidth: root.scaleHeightMin*1.3
        implicitHeight:root.scaleHeightMin*0.7
        ProgressBarItem {
            id: progressBar
            width: parent.width*0.9
            height:parent.height
            anchors.left: parent.left
            from: 0
            value: Battery.batteryLevel
            to: 100
            implicitWidth:root.scaleHeightMin*2
            implicitHeight:root.scaleHeightMin
        }
        Rectangle {
            anchors.right: parent.right
            anchors.verticalCenter:parent.verticalCenter
            // radius: parent.height*0.1
            topRightRadius:parent.height*0.1
            bottomRightRadius:parent.height*0.1
            width: parent.width*0.1
            height:parent.height/2
            color: root.config?.progressBarProps?.bgProps.borderColor
        }
        BarContentItem {
            anchors.fill: progressBar
            anchors.horizontalCenter: parent.horizontalCenter
            contentItem: TextItem {
                text: Battery.batteryLevel
            }
            onBtnclick: {
                Settings.curridx = root.uniqueIndex == Settings.curridx ? -1 : root.uniqueIndex
            }
        }
    }
    BarContentItem {
        implicitWidth: root.scaleHeightMin
        implicitHeight:root.scaleHeightMin
        contentItem: TextItem {
            text: "󰃟 "
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
    SliderItem {
        implicitWidth:root.scaleHeightMin*3
        implicitHeight:root.scaleHeightMin
        id: sld
        start: 1
        initvalue: 50
        end: 255
        onSlidermoved: {
            Battery.brightness = sld.val
            Battery.changeBrightness = true
        }
    }
}
