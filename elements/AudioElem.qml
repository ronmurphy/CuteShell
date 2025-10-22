
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
        id: barContent1
        implicitWidth:root.scaleHeightMin
        implicitHeight:root.scaleHeightMin
        contentItem: TextItem {
            text: Math.round(Audio.volume*100)
        }
        onBtnclick: {
                Settings.curridx = root.indx == Settings.curridx ? -1 : root.indx
        }
    }
    SliderItem {
        implicitWidth:root.scaleHeightMin*3
        implicitHeight:root.scaleHeightMin
        id: sld
        start: 0
        initvalue: 0.3
        end: 1
        onSlidermoved: {
            Audio.setVolume(sld.val)
        }
    }
}


