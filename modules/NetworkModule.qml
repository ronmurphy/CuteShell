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
        color:root.config?.popupProps?.popupColor || "transparent"
        radius:root.config?.popupProps?.popupRadius || 0
        Loader {
            id: popupldr
            clip:true
            anchors.fill:parent
            property var popLoader: [root.config?.popupProps?.source,root.config?.popupProps?.properties]
            z:root.config.popupProps.loaderZ
            onPopLoaderChanged: {
                popupldr.setSource(popLoader[0],popLoader[1])
            }
        }
        ListView {
            highlightRangeMode: ListView.StrictlyEnforceRange
            anchors.fill:parent
            anchors.topMargin:root.scaleHeightMin/8
            anchors.bottomMargin:root.scaleHeightMin/8
            clip:true
            model: Network.wifinetworks
            delegate: root.delegateComponent
            spacing:root.scaleHeightMin/6
        }
    }

    property Component delegateComponent: Loader {
        id:del
        required property string ssid; required property bool profileExist;
        required property int signal; required property string security;
        required property bool active; required property int index;
        property string networkName: root.hideSSID ? "Network " + (index+1) : ssid
        width: root.maxWidth-root.config?.props?.subtractPopupWidth ||
            root.maxWidth+root.config?.props?.addPopupWidth || root.maxWidth
        scale:0.9
        height: root.scaleHeightMin
        property var delProps: [root.config?.listDelegateProps?.source,Object.assign(root.config?.listDelegateProps?.properties,
            {colors: ["transparent",Settings.colorPick(root.config.props.primaryColor,root.config.listDelegateProps.bgColors,del.index,2)]})]
            
        onDelPropsChanged: {
            del.setSource(delProps[0],delProps[1])
        }
        property color fgColor: Settings.colorPick(root.config.props.primaryColor,
            root.config.listDelegateProps.fgColors,del.index,2)
            
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
                color: del.fgColor
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
                color: del.fgColor
                font.pointSize:16
                horizontalAlignment: Text.AlignRight
                text: Network.wifiStrength[Math.ceil((del.signal/100)*4)-1] +
                    (security != "" ? " " : " ") + (del.profileExist ? " " : "")
            }
            onClicked: {
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
                    color: del.fgColor
                }
                onClicked: {
                    root.inputEnabled = !root.inputEnabled
                }
            }
            InputItem {
                id: inp
                visible: del.profileExist ? false : true
                width: del.width * 0.4
                height: del.height * 0.7
                anchors.centerIn: parent
                property var inpProps: [root.config?.inputProps?.source,root.config?.inputProps?.properties]
                onInpPropsChanged: {
                    inp.contentLoader.setSource(inpProps[0],inpProps[1])
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
                        color: del.fgColor
                    }
                    onClicked: {
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
                        color: del.fgColor
                    }
                    onClicked: {
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
        onClicked: {
            Settings.curridx = root.uniqueIndex == Settings.curridx ? -1 : root.uniqueIndex
        }
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
        onClicked: {
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
        onClicked: {
            root.hideSSID = !root.hideSSID
        }
    }
    BarContentItem {
        id: swtch
        checked: Network.wifiEnabled
        implicitWidth:root.scaleHeightMin*1.2
        implicitHeight:root.scaleHeightMin
        contentItem: TextItem {
            text: swtch.checked ? "󰨚 " : "󰨙 "
            // font.pointSize: 24
            fontSizeMode :Text.HorizontalFit
            color: root.config.props.secondaryColor
        }
        onClicked: {
            Network.wifiEnabled = !Network.wifiEnabled
        }
    }
}
