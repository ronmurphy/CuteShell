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
    property real scaleHeightMin: parent.parent.height
    property real defaultWidth: config?.props?.defaultWidth || scaleHeightMin
    property int uniqueIndex: -1
    property int sideIndex: -1
    
    property var config: ({})

    function setConfig() {
        config = Settings.getConfig({
            uniqueIndex:uniqueIndex,
            sideIndex:sideIndex,
            side:root.parent.objectName,
            scaleHeightMin: scaleHeightMin,
            firstChildrenWidth: itemsrow.children[0].width,
            popupParentVariants: [root.parent.parent,root.parent,root,flick],
            sideLength: root.parent.children.length,
        },{
            configName: currConfig.key,
            themeArgs: currConfig.val
        })
        root.parent.gap = config?.props.gap
        root.parent.parent.parent.minheight = config?.props?.minHeight || 45
        root.parent.parent.heightScale = config?.props?.heightScale || 1
        root.parent.parent.widthScale = config?.props?.widthScale || 1
        if (root.config?.barProps?.source && root.config.barProps.properties) {
            root.parent.parent.children[0].setSource(root.config.barProps.source,
            root.config.barProps.properties)
        }
        rectDecor.setSource(root.config?.common?.mainRectSource,root.config?.mainRectProps)
    }
    property var currConfig: Settings.currentConfig

    Component.onCompleted: {
        uniqueIndex = Settings.distributeUniqueIndex(uniqueIndex)
        for (const [i,v] of root.parent.children.entries()) {
            if (v === root) {
                sideIndex = i
                console.log(i)
            }
        }
        setConfig()
    }
    onCurrConfigChanged: {
        setConfig()
    }
    // If false, the module will have a maximum width and
    // will not collapse/expand on interacting
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

    property Loader popupItem: popuploader
    property Popup popup: popup
    property Flickable flick: flick
    property Component popupComponent: null
    property Item popupParent: null

    implicitHeight: root.scaleHeightMin
    implicitWidth: contentRect.implicitWidth
    readonly property real maxWidth: visibleExpandedWidth
        + (root.config?.props?.subtractContRectWidth || 0)
        + ((root.config?.props?.itemsRowGap || 0)*itemsrow.children.length)

    Rectangle {
        id: contentRect
        Loader {
            anchors.fill : parent
            anchors.centerIn: parent
            id: rectDecor
        }
        anchors.verticalCenter: parent.verticalCenter
        implicitHeight: root.scaleHeightMin-(root.config?.props?.subtractContRectHeight || 0)
        implicitWidth: Settings.curridx == root.uniqueIndex ? root.maxWidth
            : root.isExpandable ? root.defaultWidth : root.maxWidth
            
        Behavior on implicitWidth {
            enabled: root.config?.props?.moduleAnimProps || false
            PropertyAnimation {
                duration: root.config?.props.moduleAnimProps.duration
                easing.type: root.config?.props.moduleAnimProps.easingType
                easing.amplitude: root.config?.props.moduleAnimProps.easingAmplitude
                easing.period: root.config?.props.moduleAnimProps.easingPeriod
            }
        }

        color: "transparent"
        clip: true
        Flickable {
            id: flick
            // anchors.verticalCenter: parent.verticalCenter
            width: contentRect.width-(root.config?.props?.subtractContRectWidth || 0)
            x: root.config?.props?.flickableX || 0
            height: parent.height
            contentWidth: itemsrow.width
            contentHeight: parent.height
            clip: true
            FlexboxLayout {
                height: parent.height
                direction: FlexboxLayout.Row 
                alignContent:FlexboxLayout.AlignCenter
                alignItems:FlexboxLayout.AlignCenter
                gap:root.config?.props?.itemsRowGap || 0
                id: itemsrow
            }
        }
    }
    // here you define popup behavior,
    // but content of popup in 
    // property real maxPopupWidth: root.config?.props?.popupWidth ||
    //     popup.parent.width - root.config?.props?.subtractPopupWidth ||
    //     popup.parent.width + root.config?.props?.addPopupWidth || root.width
    Popup {
        id: popup
        parent: root.config?.props?.popupParentItem || root
        x: root.config?.props?.popupX || 0
        y: root.config?.props?.popupY || root.scaleHeightMin
        bottomMargin: Settings.isTop ? 0 : root.scaleHeightMin
        height:0
        width: maxWidth
        property real maxWidth: root.config?.props?.popupWidth ||
            parent.width - root.config?.props?.subtractPopupWidth ||
            parent.width + root.config?.props?.addPopupWidth || root.width

        Behavior on height {
            enabled: root.config?.props?.popupAnimProps || false
            PropertyAnimation {
                duration: root.config?.props.popupAnimProps.duration
                easing.type: root.config?.props.popupAnimProps.easingType
                easing.amplitude: root.config?.props.popupAnimProps.easingAmplitude
                easing.period: root.config?.props.popupAnimProps.easingPeriod
            }
        }
        onOpened: {
            popup.height = root.config?.props?.popupHeight || root.scaleHeightMin*3
            // popup.width = maxWidth
        }
        background: null
        contentItem: null
        onAboutToHide: {
            popup.height = 0
            // popup.width = 0
        }
        focus: true
        modal: false
        visible: (Settings.curridx == root.uniqueIndex || !root.isExpandable) && root.isPopupVisible
        closePolicy: Popup.NoAutoClose
        popupType: Popup.Item
        margins:0
        padding:0
        Loader {
            id: popuploader
            anchors.fill: parent
            sourceComponent: root.popupComponent
        }
    }
}


