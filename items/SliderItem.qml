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

Item {
    id: root
    property real start: 0
    property real initvalue: 0.1
    property real end: 1
    readonly property real val: sldr.value
    signal slidermoved
    implicitWidth: 80
    implicitHeight: 40

    property Component backgroundDecor: Rectangle {
        color:Settings.dark
    }
    property Component handleDecor: RectTriangleItem {
        colors: ["transparent",Settings.colorPick(root.clr,del.index)]
    }
    
    Slider {
        id: sldr
        width:root.width
        height:root.height
        from: root.start
        value: root.initvalue
        to: root.end
        onMoved: root.slidermoved()
        background: Loader {
            id: loader
            width: sldr.width
            height: sldr.height/12
            anchors.centerIn: sldr
            sourceComponent: root.backgroundDecor
        }

        handle: Loader {
            x: sldr.leftPadding + (sldr.horizontal ? sldr.visualPosition * (sldr.availableWidth - width) : (sldr.availableWidth - width) / 2)
            y: sldr.topPadding + (sldr.vertical ? sldr.visualPosition * (sldr.availableHeight - height) : (sldr.availableHeight - height) / 2)
            width:root.width/3
            height:root.height/2
            sourceComponent: root.handleDecor
        }
    }
}
