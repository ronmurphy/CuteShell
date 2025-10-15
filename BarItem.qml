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

pragma ComponentBehavior: Bound

Item {
    id: root
    property real scaleheightmin: parent.parent.scaleheightmin
    property int indx: -1
    
    Component.onCompleted: {
        indx = Settings.distributeIndex(indx)
        for (const [i,v] of root.parent.children.entries()) {
            if (v === root) {
                clr = Settings.colorpick("black",i)
                console.log(i)
            }
        }
        state = borderDecoration1 != null && borderDecoration2 != null ? "full" :
            borderDecoration2 != null ? "right" :
            borderDecoration1 != null ? "left" : "none"
    }

    property color clr;
    required property bool popupvisible;
    required property bool isscrollable;
    property bool isPopupEmbedded: false;
    
    property var datamodel;
    property Component delegatecmpnnt;

    default property alias content: itemsrow.data
    readonly property real contentWidth: itemsrow.width


    // you can override default component for your own popup behavior
    property Component popupcomponent: Rectangle {
        id: rectpop
        anchors.fill:parent
        color: root.clr
        clip:true
        radius: 12
        ListView {
            // highlightRangeMode: ListView.StrictlyEnforceRange
            highlightRangeMode: ListView.StrictlyEnforceRange
            anchors.fill: parent
            model: root.datamodel
            contentWidth: root.scaleheightmin
            contentHeight: root.height
            delegate: root.delegatecmpnnt
        }
    }

    // property Component borderDecoration1: null
    property Component borderDecoration1: TriangleItem {
        inverted:false;
        clr:root.clr
        implicitWidth: root.scaleheightmin/2
        implicitHeight: root.scaleheightmin
    }
    // property Component borderDecoration2: null
    property Component borderDecoration2: TriangleItem {
        inverted:true;
        clr:root.clr
        implicitWidth: root.scaleheightmin/2
        implicitHeight: root.scaleheightmin
    }
    property Component rectDecoration: DecorCircleItem {
        clr: "blue"
        // scale: 0.9
        implicitWidth: itemrect1.implicitWidth
        implicitHeight: root.scaleheightmin*0.8
    }
    implicitHeight: root.scaleheightmin
    implicitWidth: borderDecor1.implicitWidth+itemrect1.implicitWidth+borderDecor2.implicitWidth-2

    Loader {
        id: borderDecor1
        sourceComponent: root.borderDecoration1
    }
    
    Rectangle {
        id: itemrect1
        Loader {
            // anchors.fill : parent
            anchors.centerIn: parent
            id: rectDecor
            sourceComponent: root.rectDecoration
        }
        implicitHeight: root.scaleheightmin
        implicitWidth: Settings.curridx == root.indx ? itemsrow.width : root.scaleheightmin
        Popup {
            id: popup
            x: 0
            // x: root.isPopupEmbedded ? 0 : root.parent.x
            y: root.scaleheightmin
            bottomMargin: Settings.barAnchor == Settings.barAnchors.TOP ? 0 : root.scaleheightmin
            // y: Settings.barAnchor == Settings.barAnchor.TOP ? root.scaleheightmin : root.scaleheightmin * 2
            height:0
            width: itemrect1.width
            // Behavior on height { 
            //     ElasticBehavior  {} 
            // }
            onAboutToShow: {
                Settings.popupLoader = popuploader
                Settings.popupOpen = !Settings.popupOpen
            }
            onOpened: {
                Settings.popupLoader = popuploader
                Settings.popupOpen = !Settings.popupOpen
                popup.height = root.scaleheightmin*3
            }
            background: null
            contentItem: null
            onAboutToHide: {
                popup.height = 0
            }
            focus: true
            modal: false
            visible: Settings.curridx == root.indx && root.popupvisible
            closePolicy: Popup.NoAutoClose
            margins:0
            padding:0
            Loader {
                id: popuploader
                anchors.fill: parent
                sourceComponent: root.popupcomponent
            }
        }
        Behavior on implicitWidth {
            id: bhvr
            enabled:true
            ElasticBehavior {}
        }
        color: root.clr
        clip: true
        Flickable {
            id: flick
            width: itemrect1.width
            height: itemrect1.height
            interactive:root.isscrollable
            focus:true
            contentWidth: itemsrow.width
            contentHeight: root.scaleheightmin
            boundsBehavior:Flickable.DragOverBounds
            FlexboxLayout {
                scale:0.9
                id: itemsrow
            }
        }
    }
    Loader {
        id: borderDecor2
        sourceComponent: root.borderDecoration2
    }

    states: [
        State {
            name: "full"
            AnchorChanges {
                target: borderDecor1; anchors.left: root.left
            }
            AnchorChanges {
                target: itemrect1; anchors.horizontalCenter: root.horizontalCenter
            }
            AnchorChanges {
                target: borderDecor2; anchors.right: root.right
            }
        },
        State {
            name: "left"
            AnchorChanges {
                target: borderDecor1; anchors.left: root.left
            }
            AnchorChanges {
                target: itemrect1; anchors.right: root.right
            }
        },
        State {
            name: "right"
            AnchorChanges {
                target: borderDecor2; anchors.right: root.right
            }
            AnchorChanges {
                target: itemrect1; anchors.left: root.left
            }
        },
        State {
            name: "none"
            AnchorChanges {
                target: itemrect1; anchors.top: root; anchors.bottom: root;
                    anchors.right: root; anchors.left: root;
            }
        }
    ]
}


