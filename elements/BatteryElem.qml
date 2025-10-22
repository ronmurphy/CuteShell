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
            Settings.curridx = root.indx == Settings.curridx ? -1 : root.indx
        }
    }
    ProgressBarItem {
        scale: 0.6
        from: 0
        value: Battery.batteryLevel
        to: 100
        implicitWidth:root.scaleHeightMin*2
        implicitHeight:root.scaleHeightMin
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
