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
    BarContentItem {
        implicitWidth: root.scaleHeightMin
        implicitHeight:root.scaleHeightMin
        contentItem: TextItem {
            text: Battery.batteryLevel
        }
        onBtnclick: {
            Settings.curridx = root.uniqueIndex == Settings.curridx ? -1 : root.uniqueIndex
        }
    }
    Item {
        id:batteryDecor
        implicitWidth: root.scaleHeightMin*2
        implicitHeight:root.scaleHeightMin
        scale: 0.6
        ProgressBarItem {
            width: parent.width*0.9
            height:parent.height
            anchors.left: parent.left
            from: 0
            // value: 100
            value: 50
            // value: Battery.batteryLevel
            to: 100
            implicitWidth:root.scaleHeightMin*2
            implicitHeight:root.scaleHeightMin
        }
        Rectangle {
            anchors.right: parent.right
            anchors.verticalCenter:parent.verticalCenter
            radius: parent.height*0.1
            width: parent.width*0.1
            height:parent.height/2
            color: "black"
        }
    }
    BarContentItem {
        implicitWidth: root.scaleHeightMin
        implicitHeight:root.scaleHeightMin
        contentItem: TextItem {
            text: "󰃟 "
        }
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
