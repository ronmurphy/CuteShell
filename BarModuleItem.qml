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
    
    property var config: Settings.getConfig({
        uniqueIndex:uniqueIndex,
        sideIndex:sideIndex,
        side:root.parent.objectName,
        scaleHeightMin: scaleHeightMin,
        firstChildrenWidth: itemsrow.children[0].width,
        popupParentVariants: [root.parent.parent,root.parent,root,flick],
        sideLength: root.parent.children.length,
    },{
        configName: Settings.currentConfig.key,
        themeArgs: Settings.currentConfig.val
    })

    // If false, the module will have a maximum width and
    // will not collapse/expand when interacting
    property bool isExpandable: true

    property bool isPopupVisible: false
    
    // number of first visible module elements after being expanded (childrens of itemsrow id)
    property int visibleExpandedElements: 0
    
    readonly property real visibleExpandedWidth: {
        if (visibleExpandedElements <= 0) {
            return itemsrow.width
        }
        var wdth = 0
        for (const [i,v] of itemsrow.children.entries()) {
            if (root.visibleExpandedElements > i) {
                wdth += v.width
            }
        }
        return wdth
    }

    Component.onCompleted: {
        uniqueIndex = Settings.distributeUniqueIndex(uniqueIndex)
        for (const [i,v] of root.parent.children.entries()) {
            if (v === root) {
                sideIndex = i
                console.log(i)
            }
        }
        root.parent.gap = config?.gap
    }

    property Loader popupItem: popuploader
    property Popup popup: popup
    property Flickable flick: flick
    property Component popupComponent: null
    property Item popupParent: null

    implicitHeight: root.scaleHeightMin
    implicitWidth: contentRect.implicitWidth
    readonly property real maxWidth: visibleExpandedWidth+(root.config?.props?.subtractContRectWidth || 0)
        + (itemsrow.gap*itemsrow.children.length)

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
            : root.isExpandable ? root.defaultWidth : root.maxWidth
        Behavior on implicitWidth {
            enabled:true
            ElasticBehavior {}
        }
        color: "transparent"
        clip: true
        Flickable {
            id: flick
            width: contentRect.implicitWidth-(root.config?.props?.subtractContRectWidth || 0)
            x: root.config?.props?.flickableX || 0
            height: contentRect.height
            contentWidth: itemsrow.width
            contentHeight: root.scaleHeightMin
            clip: true
            FlexboxLayout {
                direction: FlexboxLayout.Row 
                alignContent:FlexboxLayout.AlignCenter
                alignItems:FlexboxLayout.AlignCenter
                gap:root.scaleHeightMin*0.1
                id: itemsrow
            }
        }
    }
    Popup {
        id: popup
        parent: root.config?.props?.popupParentItem || root
        x: root.config?.props?.popupX || 0
        y: root.scaleHeightMin
        bottomMargin: Settings.isTop ? 0 : root.scaleHeightMin
        height:0
        width: parent.width - root.config?.props?.subtractPopupWidth || parent.width
        Behavior on height { 
            ElasticBehavior  {}
        }
        onAboutToShow: {
            // Settings.popupChanged()
            // popup.height = root.config?.props?.popupHeight || root.scaleHeightMin*3
        }
        onOpened: {
            // Settings.popupChanged()
            popup.height = root.config?.props?.popupHeight || root.scaleHeightMin*3
        }
        background: null
        contentItem: null
        onAboutToHide: {
            popup.height = 0
        }
        focus: true
        modal: false
        // visible: Settings.curridx == root.uniqueIndex || !root.isExpandable
        // visible: Settings.curridx == root.uniqueIndex || (!root.isExpandable && root.isPopupVisible)
        visible: (Settings.curridx == root.uniqueIndex || !root.isExpandable) && root.isPopupVisible
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


