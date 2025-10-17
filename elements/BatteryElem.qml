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
import "../"

BarItem {
    id:root
    isscrollable: true;
    popupvisible: false
    BarContentItem {
        implicitWidth: root.scaleheightmin
        implicitHeight:root.scaleheightmin
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
        implicitWidth:root.scaleheightmin*2
        implicitHeight:root.scaleheightmin
    }
    BarContentItem {
        implicitWidth: root.scaleheightmin
        implicitHeight:root.scaleheightmin
        contentItem: TextItem {
            text: "󰃟 "
        }
    }
    SliderItem {
        implicitWidth:root.scaleheightmin*3
        implicitHeight:root.scaleheightmin
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
