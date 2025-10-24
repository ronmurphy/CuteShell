import Quickshell // for PanelWindow
import Quickshell.Io
import QtQuick // for Text
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Widgets
import Quickshell.Wayland
import QtQuick.Shapes
import "./elements"
import "./services"
import "./decorations"
import "./animations"

pragma ComponentBehavior: Bound

Item {
    id: root
    default property alias content: itemsrow.data
    property real scaleHeightMin: parent.parent.scaleHeight
    property real defaultWidth: decorConfig?.properties?.defaultWidth || scaleHeightMin
    property int uniqueIndex: -1
    property int sideIndex: -1
    property var decorConfig: ({})
    
    Component.onCompleted: {
        uniqueIndex = Settings.distributeUniqueIndex(uniqueIndex)
        for (const [i,v] of root.parent.children.entries()) {
            if (v === root) {
                sideIndex = i
                mainColor = Settings.colorPick("black",i)
                console.log(i)
            }
        }
        decorConfig = Settings.getDecorConfig({
            themeName: Settings.decorConfigName,
            uniqueIndex:uniqueIndex,
            sideIndex:sideIndex,
            side:root.parent.objectName,
            mainColor:mainColor,
            scaleHeightMin: scaleHeightMin,
            popupWidth: root.parent.width,
            popupParentVariants: [root.parent.parent,root.parent,root,flick],
            sideLength: root.parent.children.length,
        })
        root.parent.gap = decorConfig?.gap
    }

    property color mainColor;
    property bool isPopupVisible: false
    readonly property real contentWidth: itemsrow.width

    property Loader popupItem: popuploader
    // property Popup popup: popup
    property Flickable flick: flick
    property Component popupComponent: null
    property Item popupParent: null

    implicitHeight: root.scaleHeightMin
    implicitWidth: contentRect.implicitWidth
    Rectangle {
        id: contentRect
        Loader {
            anchors.fill : parent
            anchors.centerIn: parent
            id: rectDecor
            Component.onCompleted: {
                rectDecor.setSource(root.decorConfig?.source,root.decorConfig?.decorProperties)
                // Object.assign({},{"colors": [root.mainColor]},Settings.decorProperties[0]));
            }
        }
        implicitHeight: root.scaleHeightMin
        implicitWidth: Settings.curridx == root.uniqueIndex ? itemsrow.width+(root.decorConfig?.properties?.subtractRectWidth || 0) : root.defaultWidth
        Behavior on implicitWidth {
            enabled:true
            ElasticBehavior {}
        }
        color: "transparent"
        // color: root.mainColor
        clip: true
        Flickable {
            id: flick
            width: contentRect.implicitWidth-(root.decorConfig?.properties?.subtractRectWidth || 0)
            x: root.decorConfig?.properties?.flickableX || 0
            // anchors.left: contentRect.left
            // anchors.centerIn: contentRect
            height: contentRect.height
            contentWidth: itemsrow.width
            contentHeight: root.scaleHeightMin
            clip: true
            FlexboxLayout {
                direction: FlexboxLayout.Row 
                id: itemsrow
            }
        }
    }
    Popup {
        id: popup
        parent: root.decorConfig?.properties?.popupParentItem

        // parent: flick
        x: root.decorConfig?.properties?.popupX || 0
        // x: root.isPopupEmbedded ? 0 : root.parent.x
        y: root.scaleHeightMin
        bottomMargin: Settings.isTop ? 0 : root.scaleHeightMin
        // y: Settings.barAnchor == Settings.barAnchor.TOP ? root.scaleHeightMin : root.scaleHeightMin * 2
        height:0
        width: root.decorConfig?.properties?.popupWidth || contentRect.width
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


