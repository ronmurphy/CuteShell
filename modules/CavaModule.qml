
import Quickshell // for PanelWindow
import Quickshell.Io
import QtQuick // for Text
import QtQuick.Controls
import Quickshell.Widgets
import QtQuick.Layouts
import QtQuick.Shapes
import QtQml
import "../services"
import "../items"
import "../"

BarModuleItem {
    id:root
    isExpandable: false
    BarContentItem {
        implicitWidth: root.scaleHeightMin*3
        implicitHeight: root.scaleHeightMin
        contentItem: TextItem {
            text: Cava.output
            textFormat: Text.StyledText
            color: root.config.props.secondaryColor
        }
        onClicked: {
            root.isPopupVisible = !root.isPopupVisible
        }
    }
    onConfigChanged: {
        Cava.bars = root.config.props.cavaTextBars
        Cava.colors = root.config.props.cavaColors
    }
    popupComponent: Rectangle {
        id: popupRect
        scale:1
        color:"transparent"
        // color:root.config.props.primaryColor
        LoaderItem {
            id: upperLoader
            // scale:1.1
            height:root.scaleHeightMin
            loaderProps: [root.config?.listDelegateProps?.source,Object.assign(root.config?.listDelegateProps?.properties,
                {colors: [root.config?.listDelegateProps?.bgColor || "transparent",
                Settings.colorPick(root.config.props.primaryColor,root.config.listDelegateProps.bgColors,0,2)]})]

            // loaderProps: [root.config?.listDelegateProps?.source,
            //     Object.assign(root.config?.listDelegateProps?.properties,
            //     {colors: ["transparent",Settings.colorPick("",root.config.props.bgColors,0,2)]})]

            anchors.fill: parent
            BarContentItem {
                z:1
                anchors.left: parent.left
                anchors.leftMargin: root.scaleHeightMin/2
                anchors.horizontalCenter: popupRect.horizontalCenter
                implicitWidth: parent.width*0.5
                implicitHeight: root.scaleHeightMin
                contentItem: TextItem {
                    color: root.config?.listDelegateProps?.fgColor
                    text: Mpris.currentArtist + " " + Mpris.currentTrack
                    textFormat: Text.StyledText
                    elide:Text.ElideRight
                }
            }
            Item {
                z:1
                anchors.right: parent.right
                anchors.rightMargin: root.scaleHeightMin/2
                anchors.horizontalCenter: popupRect.horizontalCenter
                implicitWidth: parent.width*0.3
                implicitHeight: root.scaleHeightMin
                BarContentItem {
                    anchors.left: parent.left
                    width: parent.width/3
                    implicitHeight: root.scaleHeightMin
                    contentItem: TextItem {
                        color: root.config?.listDelegateProps?.fgColor
                        text: "󰒮"
                        textFormat: Text.StyledText

                    }
                    onClicked: {
                        Mpris.previous();
                    }
                }
                BarContentItem {
                    width: parent.width/3
                    implicitHeight: root.scaleHeightMin
                    anchors.horizontalCenter: parent.horizontalCenter
                    contentItem: TextItem {
                        color: root.config?.listDelegateProps?.fgColor
                        text: Mpris.currentPlayerState
                        textFormat: Text.StyledText

                    }
                    onClicked: {
                        Mpris.playPause();
                    }
                }
                BarContentItem {
                    anchors.right: parent.right
                    width: parent.width/3
                    implicitHeight: root.scaleHeightMin
                    contentItem: TextItem {
                        color: root.config?.listDelegateProps?.fgColor
                        text: "󰒭"
                        textFormat: Text.StyledText

                    }
                    onClicked: {
                        Mpris.next();
                    }
                }
            }
        }
    }
}


