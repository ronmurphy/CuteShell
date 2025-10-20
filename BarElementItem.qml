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
    property real scaleheightmin: parent.parent.scaleheightmin
    property real defaultWidth: scaleheightmin
    property int indx: -1
    Component.onCompleted: {
        indx = Settings.distributeUniqueIndex(indx)
        for (const [i,v] of root.parent.children.entries()) {
            if (v === root) {
                clr = Settings.colorPick("black",i)
                console.log(i)
            }
        }
        state = borderDecoration1 != null && borderDecoration2 != null ? "full" :
            borderDecoration2 != null ? "right" :
            borderDecoration1 != null ? "left" : "none"
    }

    property color clr;
    property bool popupvisible: false;
    property bool isscrollable: false
    property bool isPopupEmbedded: false;
    readonly property real contentWidth: itemsrow.width

    property Loader popupItem: popuploader
    property Popup popup: popup
    // property Item popup: popuploader

    // you can override default component for your own popup behavior
    property var datamodel;
    property Component delegatecmpnnt;
    property Component popupcomponent: Rectangle {
        id: rectpop
        anchors.fill:parent
        color: root.clr
        clip:true
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

    property Component borderDecoration1: null
    // property Component borderDecoration1: TriangleItem {
    //     inverted:false;
    //     clr:root.clr
    //     implicitWidth: root.scaleheightmin/2
    //     implicitHeight: root.scaleheightmin
    // }
    property Component borderDecoration2: null
    // property Component borderDecoration2: TriangleItem {
    //     inverted:true;
    //     clr:root.clr
    //     implicitWidth: root.scaleheightmin/2
    //     implicitHeight: root.scaleheightmin
    // }
    property Component rectDecoration: Rectangle {
        color: root.clr
        radius: root.scaleheightmin*0.5
        border.color: Qt.darker(root.clr,1.2)
        border.width: root.scaleheightmin*0.1
        implicitWidth: mainrect.implicitWidth
        implicitHeight: root.scaleheightmin
    }
    // property Component rectDecoration: Rectangle {
    //     color: root.clr
    //     radius: root.scaleheightmin*0.5
    //     border.color: Qt.darker(root.clr,1.2)
    //     border.width: root.scaleheightmin*0.1
    //     implicitWidth: mainrect.implicitWidth
    //     implicitHeight: root.scaleheightmin
    // }
    // property Component rectDecoration: DecorCircleItem {
    //     clr: "blue"
    //     // scale: 0.9
    //     implicitWidth: mainrect.implicitWidth
    //     implicitHeight: root.scaleheightmin*0.8
    // }

    implicitHeight: root.scaleheightmin
    implicitWidth: borderDecor1.implicitWidth+mainrect.implicitWidth+borderDecor2.implicitWidth-2

    Loader {
        id: borderDecor1
        sourceComponent: root.borderDecoration1
    }
    
    Rectangle {
        id: mainrect
        Loader {
            // anchors.fill : parent
            anchors.centerIn: parent
            id: rectDecor
            sourceComponent: root.rectDecoration
        }
        implicitHeight: root.scaleheightmin
        implicitWidth: Settings.curridx == root.indx ? itemsrow.width : root.defaultWidth
        Behavior on implicitWidth {
            id: bhvr
            enabled:true
            ElasticBehavior {}
        }
        color: "transparent"
        // color: root.clr
        clip: true
        Flickable {
            id: flick
            width: mainrect.width
            height: mainrect.height
            interactive:root.isscrollable
            contentWidth: itemsrow.width
            contentHeight: root.scaleheightmin
            FlexboxLayout {
                direction: FlexboxLayout.Row 
                id: itemsrow
            }
        }
    }
    Loader {
        id: borderDecor2
        sourceComponent: root.borderDecoration2
    }
    Popup {
        id: popup
        parent: mainrect
        // x: 0
        x: root.isPopupEmbedded ? 0 : root.parent.x
        y: root.scaleheightmin
        bottomMargin: Settings.isTop ? 0 : root.scaleheightmin
        // y: Settings.barAnchor == Settings.barAnchor.TOP ? root.scaleheightmin : root.scaleheightmin * 2
        height:0
        width: mainrect.width
        // Behavior on height { 
        //     ElasticBehavior  {} 
        // }
        onAboutToShow: {
            // Settings.popupChanged()
        }
        onOpened: {
            // Settings.popupChanged()
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
    states: [
        State {
            name: "full"
            AnchorChanges {
                target: borderDecor1; anchors.left: root.left
            }
            AnchorChanges {
                target: mainrect; anchors.horizontalCenter: root.horizontalCenter
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
                target: mainrect; anchors.right: root.right
            }
        },
        State {
            name: "right"
            AnchorChanges {
                target: borderDecor2; anchors.right: root.right
            }
            AnchorChanges {
                target: mainrect; anchors.left: root.left
            }
        },
        State {
            name: "none"
            AnchorChanges {
                target: mainrect; anchors.top: root; anchors.bottom: root;
                    anchors.right: root; anchors.left: root;
            }
        }
    ]
}


