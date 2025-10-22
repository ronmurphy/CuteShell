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
    property real scaleHeightMin: parent.parent.scaleHeightMin
    property real defaultWidth: scaleHeightMin*2
    property int uniqueIndex: -1
    property int sideIndex: -1
    
    Component.onCompleted: {
        uniqueIndex = Settings.distributeUniqueIndex(uniqueIndex)
        for (const [i,v] of root.parent.children.entries()) {
            if (v === root) {
                sideIndex = i
                mainColor = Settings.colorPick("black",i)
                console.log(i)
            }
        }
    }
    property color mainColor;
    property bool isPopupVisible: false
    readonly property real contentWidth: itemsrow.width

    property Loader popupItem: popuploader
    property Popup popup: popup
    property Flickable flick: flick
    property Component popupComponent: null

    implicitHeight: root.scaleHeightMin
    implicitWidth: contentRect.implicitWidth

    Rectangle {
        id: contentRect
        Loader {
            anchors.fill : parent
            anchors.centerIn: parent
            id: rectDecor
            sourceComponent: DirectedRectTriangle {
                inverted: root.parent.objectName === "left" || (root.parent.objectName === "center" && root.sideIndex === 1)? true : false
                colors: ["transparent",Settings.colorPick(root.mainColor,root.uniqueIndex),Settings.colorPick(root.mainColor,root.uniqueIndex)]
            }
            // sourceComponent: root.rectDecoration
            // Component.onCompleted: {
            //     // rectDecor.setSource(null,null);
            //     rectDecor.setSource(Settings.decorComponents[0],
            //     Object.assign({},{"colors": [root.mainColor]},Settings.decorProperties[0]));
            // }
        }
        implicitHeight: root.scaleHeightMin
        implicitWidth: Settings.curridx == root.uniqueIndex ? itemsrow.width : root.defaultWidth
        Behavior on implicitWidth {
            id: bhvr
            enabled:true
            ElasticBehavior {}
        }
        color: "transparent"
        // color: root.mainColor
        clip: true
        Flickable {
            id: flick
            width: contentRect.width-contentRect.height
            anchors.centerIn: contentRect
            height: contentRect.height
            interactive:root.isscrollable
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
        parent: contentRect
        x: 0
        // x: root.isPopupEmbedded ? 0 : root.parent.x
        y: root.scaleHeightMin
        bottomMargin: Settings.isTop ? 0 : root.scaleHeightMin
        // y: Settings.barAnchor == Settings.barAnchor.TOP ? root.scaleHeightMin : root.scaleHeightMin * 2
        height:0
        width: contentRect.width
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
        visible: Settings.curridx == root.uniqueIndex && root.popupvisible
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


