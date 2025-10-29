import Quickshell // for PanelWindow
import Quickshell.Io
import QtQuick // for Text
import QtQuick.Controls
import QtQuick.Controls.Fusion
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

    property bool inputEnabled: true
    property int selectedConn: -1
    property bool hideSSID: true
    isPopupVisible: Network.wifiEnabled

    popupComponent: Rectangle {
        id: rectpop
        anchors.fill:parent
        color: root.config.props.primaryColor
        clip:true
        ListView {
            highlightRangeMode: ListView.StrictlyEnforceRange
            spacing:root.scaleHeightMin/10
            anchors.fill: parent
            model: Network.wifinetworks
            delegate: root.delegateComponent
        }
    }

    property Component delegateComponent: Loader {
        id:del
        scale:1
        required property string ssid; required property bool profileExist;
        required property string signal; required property string security;
        required property bool active; required property int index;
        property string networkName: root.hideSSID ? "Network " + index : ssid

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
                anchors.leftMargin: root.scaleHeightMin/2
                anchors.left: parent.left
                width: del.width * 0.5
                height: del.height
                color: root.config.props.secondaryColor
                elide: Text.ElideRight
                font.pointSize:12
                horizontalAlignment: Text.AlignLeft
                text: (del.active ? " " : "") + del.networkName
            }
            TextItem {
                id: securityType
                anchors.right: parent.right
                anchors.rightMargin: root.scaleHeightMin/2
                width: del.width * 0.3
                height: del.height
                color: root.config.props.secondaryColor
                font.pointSize:16
                horizontalAlignment: Text.AlignRight
                text: signal + (security != "" ? " " : " ") + (del.profileExist ? " " : "")
            }
            onBtnclick: {
                root.selectedConn = del.index
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
                anchors.leftMargin: root.scaleHeightMin/2
                width: del.width * 0.2
                height: del.height
                contentItem: TextItem {
                    text: "󱞳"
                    color: root.config.props.secondaryColor
                }
                onBtnclick: {
                    root.inputEnabled = !root.inputEnabled
                }
            }
            InputItem {
                id: inp
                visible: del.profileExist ? false : true
                width: del.width * 0.4
                height: del.height*0.7
                anchors.centerIn: parent
                Component.onCompleted: {
                    inp.contentLoader.setSource(root.config?.inputProps?.source,
                    root.config?.inputProps?.properties)
                }
            }
            Item {
                id: action
                anchors.right: parent.right
                anchors.rightMargin: root.scaleHeightMin/2
                width: del.width * 0.2
                height: del.height
                BarContentItem {
                    id: deleteAction
                    anchors.left: parent.left
                    width: action.width * 0.5
                    height: action.height
                    contentItem: TextItem {
                        text: " "
                        color: root.config.props.secondaryColor
                    }
                    onBtnclick: {
                        root.inputEnabled = !root.inputEnabled
                        Network.deleteNetwork(del.ssid)
                    }
                }
                BarContentItem {
                    id: connectAction
                    anchors.right: parent.right
                    width: action.width * 0.5
                    height: action.height
                    contentItem: TextItem {
                        text: (del.active ? " " : " ")
                        horizontalAlignment: Text.AlignRight
                        color: root.config.props.secondaryColor
                    }
                    onBtnclick: {
                        root.inputEnabled = !root.inputEnabled
                        const inptext = inp.gettext()
                        if (del.active) {
                            Network.disconnectFromNetwork(del.ssid)
                        } else {
                            if (inptext.length === 0) {
                            Network.connectToNetwork(del.ssid,"",del.profileExist)
                                return
                            }
                            Network.connectToNetwork(del.ssid,inptext,false)
                        }
                    }
                }
            }
        }
    }

    BarContentItem {
        implicitWidth:root.scaleHeightMin
        implicitHeight:root.scaleHeightMin
        contentItem: TextItem {
            text: Network.statusConn
            color: root.config.props.secondaryColor
        }
        onBtnclick: {
            Settings.curridx = root.uniqueIndex == Settings.curridx ? -1 : root.uniqueIndex
        }
    }
    onConfigChanged: {
        // swtch.backgroundloader.setSource(root.config.inputProps.source,
        // Object.assign(root.config.inputProps.properties,
        // {colors: ["transparent","blue"]}))
    }
    BusyIndicatorItem {
        running: Network.isConnecting || Network.isSearching
        color:root.config.props.secondaryColor
        implicitWidth: root.scaleHeightMin
        implicitHeight: root.scaleHeightMin
    }
    BarContentItem {
        implicitWidth:root.scaleHeightMin
        implicitHeight:root.scaleHeightMin
        contentItem: TextItem {
            text: " "
            color: root.config.props.secondaryColor
        }
        onBtnclick: {
            Network.getNetworks()
        }
    }
    BarContentItem {
        implicitWidth:root.scaleHeightMin
        implicitHeight:root.scaleHeightMin
        contentItem: TextItem {
            text: root.hideSSID ? " " : " "
            color: root.config.props.secondaryColor
        }
        onBtnclick: {
            root.hideSSID = !root.hideSSID
        }
    }
    BarContentItem {
        id: swtch
        checked: Network.wifiEnabled
        implicitWidth:root.scaleHeightMin*1.5
        implicitHeight:root.scaleHeightMin
        contentItem: TextItem {
            text: swtch.checked ? "󰨚 " : "󰨙 "
            // font.pointSize: 24
            fontSizeMode :Text.HorizontalFit
            color: root.config.props.secondaryColor
        }
        onBtnclick: {
            Network.wifiEnabled = !Network.wifiEnabled
        }
    }
    // SwitchItem {
    //     id: swtch
    //     // checkable:true
    //     checked: Network.wifiEnabled
    //     onClicked: {
    //         Network.wifiEnabled = !Network.wifiEnabled
    //     }
            
    //     implicitWidth:root.scaleHeightMin*1.5
    //     implicitHeight:root.scaleHeightMin*0.6
    // }
}
