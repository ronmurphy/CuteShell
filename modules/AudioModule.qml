
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

BarModuleItem {
    id:root
    BarContentItem {
        id: barContent1
        implicitWidth:root.scaleHeightMin*1.5
        implicitHeight:root.scaleHeightMin
        contentItem: TextItem {
            text: Audio.volume + Audio.icon
            font.pointSize:20
            color: root.config.props.secondaryColor
        }
        onBtnclick: {
                Settings.curridx = root.uniqueIndex == Settings.curridx ? -1 : root.uniqueIndex
        }
    }
    onConfigChanged: {
        sld.handleloader.setSource(root.config?.sliderProps?.source,
        root.config?.sliderProps?.properties,)
        sld.backgroundloader.setSource(root.config?.sliderProps?.source,
        root.config?.sliderProps?.properties)
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


