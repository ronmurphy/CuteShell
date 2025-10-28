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

BarModuleItem {
    id:root
    objectName:"Network"

    property bool inputEnabled: false
    property int selectedConn: -1

    popupComponent: Rectangle {
        id: rectpop
        anchors.fill:parent
        color: root.config.props.primaryColor
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

    property Component delegateComponent: Loader {
        id:del
        scale:0.9
        required property string ssid; required property bool profileExist;
        required property string bars; required property string security;
        required property int index
        property bool inputEnabled: false
        width: root.maxWidth
        height: root.scaleHeightMin
        Component.onCompleted: {
            del.setSource(root.config?.listDelegateProps?.source,
            Object.assign(root.config?.listDelegateProps?.properties,
            {colors: ["transparent",Settings.colorPick(root.config.props.primaryColor,root.config.props.bgColors,del.index)]}))

        }
        BarContentItem {
            z:1
            id: netInfo
            visible: !root.inputEnabled || root.selectedConn != index
            anchors.fill: parent
            TextItem {
                id: name
                anchors.left: parent.left
                width: del.width * 0.7
                height: del.height
                color: root.config.props.secondaryColor
                text: (Network.activeWifiConn === del.index ? " " : "") + ssid + (del.profileExist ? " " : "")
            }
            TextItem {
                id: securityType
                anchors.right: parent.right
                width: del.width * 0.3
                height: del.height
                color: root.config.props.secondaryColor
                text: bars + security.trim().split(/\s+/).pop()
            }
            onBtnclick: {
                root.selectedConn = index
                root.inputEnabled = !root.inputEnabled
            }
        }
        Item {
            z:1
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
                    color: root.config.props.secondaryColor
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
                    colors: ["transparent",Settings.colorPick("",root.config.props.fgColors,0)]
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
                        color: root.config.props.secondaryColor
                    }
                    onBtnclick: {
                        const inptext = inp.gettext()
                        if (inptext.length === 0) {
                            Network.connectToNetwork(del.ssid,"",del.profileExist)
                            return
                        }
                        Network.connectToNetwork(del.ssid,inptext,false)
                    }
                }

                BarContentItem {
                    id: deleteAction
                    anchors.right: parent.right
                    width: action.width * 0.5
                    height: action.height
                    contentItem: TextItem {
                        text: "del"
                        color: root.config.props.secondaryColor
                    }
                    onBtnclick: {
                        Network.deleteNetwork(del.ssid)
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
            color: root.config.props.secondaryColor
        }
        onBtnclick: {
            root.isPopupVisible = true
            Settings.curridx = root.uniqueIndex == Settings.curridx ? -1 : root.uniqueIndex
            Network.getNetworks = true
        }
    }
    onConfigChanged: {
        input.contentLoader.setSource(root.config.inputProps.source,
        root.config.inputProps.properties)
    }
    BusyIndicator {
        running: Network.isConnecting
    }
    InputItem {
        id: input
        scale: visible ? 1.0 : 0.1
        Behavior on scale { 
            ElasticBehavior  {} 
        }
        decor: RectTriangleItem {
            scale: 0.7
            colors: ["transparent",Settings.colorPick(root.config.props.primaryColor,root.config.props.bgColors,del.index)]
            clip: true
        }
        visible: root.inputactive
        // anchors.verticalCenter: root.verticalCenter
        implicitWidth:root.scaleHeightMin*3
        implicitHeight:root.scaleHeightMin*0.6
    }
}
