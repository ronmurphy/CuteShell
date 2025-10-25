
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
                Settings.curridx = root.uniqueIndex == Settings.curridx ? -1 : root.uniqueIndex
        }
    }
    onConfigChanged: {
        sld.handleloader.setSource(root.config?.listDelegateProps?.source,
        Object.assign(root.config?.listDelegateProps?.properties,
        {colors: ["transparent",Settings.colorPick(root.mainColor,root.uniqueIndex)]}))
    }
    SliderItem {
        implicitWidth:root.scaleHeightMin*3
        implicitHeight:root.scaleHeightMin
        // source:root.config?.listDelegateProps?.source
        // props:Object.assign(root.config?.listDelegateProps?.properties,
        //     {colors: ["transparent",Settings.colorPick(root.mainColor,root.uniqueIndex)]})
        id: sld
        start: 0
        initvalue: 0.3
        end: 1
        onSlidermoved: {
            Audio.setVolume(sld.val)
        }
    }
}


