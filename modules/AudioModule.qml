
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
        onClicked: {
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
        from: 0
        value: Audio.volumeRaw
        to: 1

        Connections {
            target: Audio
            function onVolumeRawChanged() {
                sld.value = Audio.volumeRaw
            }
        }
        onMoved: {
            Audio.setVolume(sld.value)
        }

    }
}


