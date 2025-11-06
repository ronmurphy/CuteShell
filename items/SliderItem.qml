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
    id: root
    property Loader handleloader: handleLoader
    property Loader backgroundloader: backgroundLoader
    
    property Component backgroundDecor: Rectangle {
        color:"blue"
    }
    property Component handleDecor: RectTriangleItem {
        colors: ["transparent","green"]
    }
    property int handleWidthScale: 4
    implicitWidth: 80
    implicitHeight: 40
    from: 0
    value: 0
    to: 1
    background: Loader {
        id: backgroundLoader
        width: root.width
        height: root.height/8
        anchors.centerIn: root
        sourceComponent: root.backgroundDecor
    }

    handle: Loader {
        id: handleLoader
        x: root.leftPadding + root.visualPosition * (root.availableWidth - width)
        y: root.topPadding + root.availableHeight / 2 - height / 2
        // x: root.leftPadding + (root.horizontal ? root.visualPosition * (root.availableWidth - width) : (root.availableWidth - width) / 2)
        // y: root.topPadding + (root.vertical ? root.visualPosition * (root.availableHeight - height) : (root.availableHeight - height) / 2)
        width:root.width/root.handleWidthScale
        height:root.height/1.5
        sourceComponent: root.handleDecor
    }
}
