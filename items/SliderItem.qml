import Quickshell // for PanelWindow
import Quickshell.Io
import QtQuick // for Text
import QtQuick.Controls
import Quickshell.Widgets
import QtQuick.Layouts
import QtQuick.Shapes
import QtQml
import "./services"
import "./items"
import "../decorations"
import "../"

   
Slider {
    id: sldr
    property Loader handleloader: handleLoader
    property Loader backgroundloader: backgroundLoader

    property Component backgroundDecor: Rectangle {
        color:Settings.dark
    }
    property Component handleDecor: RectTriangleItem {
        colors: ["transparent",Settings.colorPick(root.config.primaryColor,root.config.bgColors,del.index)]
    }
    implicitWidth: 80
    implicitHeight: 40
    from: 0
    value: 0
    to: 1
    background: Loader {
        id: backgroundLoader
        width: sldr.width
        height: sldr.height/12
        anchors.centerIn: sldr
        sourceComponent: root.backgroundDecor
    }

    handle: Loader {
        id: handleLoader
        x: sldr.leftPadding + (sldr.horizontal ? sldr.visualPosition * (sldr.availableWidth - width) : (sldr.availableWidth - width) / 2)
        y: sldr.topPadding + (sldr.vertical ? sldr.visualPosition * (sldr.availableHeight - height) : (sldr.availableHeight - height) / 2)
        width:sldr.width/4
        height:sldr.height/2
        sourceComponent: sldr.handleDecor
    }
}
