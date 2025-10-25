import Quickshell // for PanelWindow
import Quickshell.Io
import QtQuick // for Text
import QtQuick.Controls
import Quickshell.Widgets
import QtQuick.Layouts
import QtQuick.Shapes
import QtQuick.Effects
import QtQml
import "../services"
import "../items"
import "../decorations"
import "../animations"
import "../"

pragma ComponentBehavior: Bound

BarElementItem {
    id:root
    objectName:"Network"

    property bool inputEnabled: false
    property int selectedConn: -1
    function selectstatus(idx: string): string {
        return Network.selected[0] != idx ? "" :
        Network.selected[1] == Network.state.SELECTED ? "X ": 
        Network.selected[1] == Network.state.PENDING ? " ": " "
    }
        
    popupComponent: Rectangle {
        id: rectpop
        anchors.fill:parent
        color: root.clr
        clip:true
        ListView {
            // highlightRangeMode: ListView.StrictlyEnforceRange
            highlightRangeMode: ListView.StrictlyEnforceRange
            anchors.fill: parent
            model: Network.wifinetworks
            // contentWidth: root.scaleHeightMin
            // contentHeight: root.height
            delegate: root.delegateComponent
        }
    }

    property Component delegateComponent: Item {
        id:del
        required property string ssid; required property bool profileExist;
        required property string bars; required property string security;
        required property int index
        // MultiEffect {
        //     anchors.fill: del
        //     source: del
        //     blur:100
        //     blurEnabled:false
        //     // blur.radius: 10 // Adjust the blur radius as needed
        //     // Other effects can be added here, e.g., shadow, colorization
        // }
        property bool inputEnabled: false
        implicitWidth: root.contentWidth
        implicitHeight: root.scaleHeightMin
        Loader {
            id: delegateLoader
            anchors.fill: parent
            Component.onCompleted: {
                delegateLoader.setSource(root.config?.listDelegateProps?.source,
                Object.assign(root.config?.listDelegateProps?.properties,
                {colors: ["transparent",Settings.colorPick(root.mainColor,del.index)]}))

            }
        }
        BarContentItem {
            scale: 0.9
            id: netInfo
            visible: !root.inputEnabled || root.selectedConn != index
            anchors.fill: parent
            TextItem {
                id: name
                anchors.left: parent.left
                width: del.width * 0.7
                height: del.height
                
                text: root.selectstatus(index) + ssid + bars 
                color: Settings.dark
            }
            TextItem {
                id: securityType
                anchors.right: parent.right
                width: del.width * 0.3
                height: del.height

                text: security.trim().split(/\s+/).pop()
                color: Settings.dark
            }
            onBtnclick: {
                root.selectedConn = index
                root.inputEnabled = !root.inputEnabled
                Network.selected[0] = index;
                Network.selected[1] = 0;
            }
        }
        Item {
            scale: 0.9
            id: netAction
            visible: root.inputEnabled && root.selectedConn === index
            anchors.fill: parent
            BarContentItem {
                id: backButton
                anchors.left: parent.left
                width: del.width * 0.2
                height: del.height
                contentItem: TextItem {
                    text: "back"
                }
                onBtnclick: {
                    root.inputEnabled = !root.inputEnabled
                }
            }
            InputItem {
                id: inp
                width: del.width * 0.5
                height: del.height
                anchors.horizontalCenter: parent.horizontalCenter
                decor: RectTriangleItem {
                    colors: ["transparent",Settings.colorPick(root.clr,del.index)]
                }
            }
            Item {
                id: action
                anchors.right: parent.right

                width: del.width * 0.3
                height: del.height
                BarContentItem {
                    id: connectAction
                    anchors.left: parent.left
                    width: action.width * 0.5
                    height: action.height
                    contentItem: TextItem {
                        text: "conn"
                    }
                    onBtnclick: {
                        const inptext = inp.gettext()
                        Network.selected[1] = Network.state.PENDING;
                        if (inptext.length === 0) {
                            Network.connectToNetwork(Network.wifinetworks[Network.selected[0]].ssid,
                                "",Network.wifinetworks[Network.selected[0]].profileExist)
                            Network.selected[1] = Network.state.PENDING;
                            return
                        }
                        Network.connectToNetwork(
                            Network.wifinetworks[Network.selected[0]].ssid,inptext,false)
                    }
                }

                BarContentItem {
                    id: deleteAction
                    anchors.right: parent.right
                    width: action.width * 0.5
                    height: action.height
                    contentItem: TextItem {
                        text: "del"
                    }
                }
            }
        }
    }

    BarContentItem {
        implicitWidth:root.scaleHeightMin
        implicitHeight:root.scaleHeightMin
        contentItem: TextItem {
            text: Network.statusConn[0]
        }
        onBtnclick: {
            root.isPopupVisible = !root.isPopupVisible
            Settings.curridx = root.uniqueIndex == Settings.curridx ? -1 : root.uniqueIndex
            Network.getNetworks = true
        }
    }
    onConfigChanged: {
        input.contentLoader.setSource(root.config?.inputProps?.source,
        root.config?.inputProps?.properties,)
        input.contentLoader.setSource(root.config?.inputProps?.source,
        root.config?.inputProps?.properties)
    }
    InputItem {
        id: input
        scale: visible ? 1.0 : 0.1
        Behavior on scale { 
            ElasticBehavior  {} 
        }
        decor: RectTriangleItem {
            scale: 0.7
            colors: ["transparent",Settings.colorPick(root.clr,del.index)]
            clip: true
        }
        visible: root.inputactive
        // anchors.verticalCenter: root.verticalCenter
        implicitWidth:root.scaleHeightMin*3
        implicitHeight:root.scaleHeightMin*0.6
    }
}
