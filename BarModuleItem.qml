import Quickshell // for PanelWindow
import Quickshell.Io
import QtQuick // for Text
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Widgets
import Quickshell.Wayland
import QtQuick.Shapes
import "./modules"
import "./services"
import "./decorations"
import "./animations"

pragma ComponentBehavior: Bound

Item {
    id: root
    default property alias content: itemsrow.data
    property real scaleHeightMin: parent.parent.scaleHeight
    property real defaultWidth: config?.props?.defaultWidth || scaleHeightMin
    property int uniqueIndex: -1
    property int sideIndex: -1
    property var config: null
    property bool isRectractable: true
    
    Component.onCompleted: {
        uniqueIndex = Settings.distributeUniqueIndex(uniqueIndex)
        for (const [i,v] of root.parent.children.entries()) {
            if (v === root) {
                sideIndex = i
                console.log(i)
            }
        }
        config = Settings.getConfig({
            themeName: Settings.decorConfigName,
            uniqueIndex:uniqueIndex,
            sideIndex:sideIndex,
            side:root.parent.objectName,
            scaleHeightMin: scaleHeightMin,
            firstChildrenWidth: itemsrow.children[0].width,
            popupWidthVariants: [root.parent.parent.width,root.parent.width,root.width,flick.width],
            popupParentVariants: [root.parent.parent,root.parent,root,flick],
            sideLength: root.parent.children.length,
        })
        root.parent.gap = config?.gap
    }

    property bool isPopupVisible: false
    readonly property real contentWidth: itemsrow.width

    property Loader popupItem: popuploader
    property Popup popup: popup
    property Flickable flick: flick
    property Component popupComponent: null
    property Item popupParent: null

    implicitHeight: root.scaleHeightMin
    implicitWidth: contentRect.implicitWidth
    readonly property real maxWidth: itemsrow.width+(root.config?.props?.subtractRectWidth || 0)
    Rectangle {
        id: contentRect
        Loader {
            anchors.fill : parent
            anchors.centerIn: parent
            id: rectDecor
            Component.onCompleted: {
                rectDecor.setSource(root.config?.source,root.config?.mainDecorProps)
            }
        }
        implicitHeight: root.scaleHeightMin
        implicitWidth: Settings.curridx == root.uniqueIndex ? root.maxWidth
            : root.isRectractable ? root.defaultWidth : root.maxWidth
        Behavior on implicitWidth {
            enabled:true
            ElasticBehavior {}
        }
        color: "transparent"
        clip: true
        Flickable {
            id: flick
            width: contentRect.implicitWidth-(root.config?.props?.subtractRectWidth || 0)
            x: root.config?.props?.flickableX || 0
            height: contentRect.height
            contentWidth: itemsrow.width
            contentHeight: root.scaleHeightMin
            clip: true
            // scale:0.8 //////////////////////////////////////////////////////////////////
            FlexboxLayout {
                direction: FlexboxLayout.Row 
                alignContent:FlexboxLayout.AlignCenter
                alignItems:FlexboxLayout.AlignCenter
                // anchors.verticalCenter: root.verticalCenter
                id: itemsrow
            }
        }
    }
    Popup {
        id: popup
        parent: root.config?.props?.popupParentItem

        // parent: flick
        x: root.config?.props?.popupX || 0
        // x: root.isPopupEmbedded ? 0 : root.parent.x
        y: root.scaleHeightMin
        bottomMargin: Settings.isTop ? 0 : root.scaleHeightMin
        // y: Settings.barAnchor == Settings.barAnchor.TOP ? root.scaleHeightMin : root.scaleHeightMin * 2
        height:0
        width: root.config?.props?.popupWidth ||
            contentRect.width - root.config?.props?.subtractPopupWidth
        // Behavior on height { 
        //     ElasticBehavior  {} 
        // }
        onAboutToShow: {
            // Settings.popupChanged()
        }
        onOpened: {
            // Settings.popupChanged()
            popup.height = root.scaleHeightMin*3
        }
        background: null
        contentItem: null
        onAboutToHide: {
            popup.height = 0
        }
        focus: true
        modal: false
        visible: Settings.curridx == root.uniqueIndex && root.isPopupVisible
        closePolicy: Popup.NoAutoClose
        margins:0
        padding:0
        Loader {
            id: popuploader
            anchors.fill: parent
            sourceComponent: root.popupComponent
        }
    }
}


