
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
    defaultWidth: scaleHeightMin*3
    isExpandable: false
    BarContentItem {
        implicitWidth: root.defaultWidth
        implicitHeight: root.scaleHeightMin
        contentItem: TextItem {
            scale:1.2
            text: Cava.output
            textFormat: Text.StyledText
            color: root.config.props.secondaryColor
        }
        onBtnclick: {
            root.isPopupVisible = true
            Settings.curridx = root.uniqueIndex == Settings.curridx ? -1 : root.uniqueIndex
        }
    }

    popupComponent: Rectangle {
        id: popupRect
        color:"transparent"
        // color:root.config.props.primaryColor
        Loader {
            id: upperLoader
            // scale:0.8
            height:root.scaleHeightMin
            Component.onCompleted: {
                upperLoader.setSource(root.config?.listDelegateProps?.source,
                Object.assign(root.config?.listDelegateProps?.properties,
                {colors: ["transparent",Settings.colorPick("",root.config.props.bgColors,0)]}))
            }
            anchors.fill: parent
            BarContentItem {
                z:1
                anchors.left: parent.left
                anchors.horizontalCenter: popupRect.horizontalCenter
                implicitWidth: parent.width*0.7
                implicitHeight: root.scaleHeightMin
                contentItem: TextItem {
                    color: root.config.props.fgColors[0]
                    text: Mpris.currentArtist + " " + Mpris.currentTrack
                    textFormat: Text.StyledText
                    elide:Text.ElideRight
                }
            }
            Item {
                z:1
                anchors.right: parent.right
                anchors.horizontalCenter: popupRect.horizontalCenter
                implicitWidth: parent.width*0.3
                implicitHeight: root.scaleHeightMin
                BarContentItem {
                    anchors.left: parent.left
                    width: parent.width/3
                    implicitHeight: root.scaleHeightMin
                    contentItem: TextItem {
                        color: root.config.props.fgColors[0]
                        text: "󰒮"
                        textFormat: Text.StyledText

                    }
                    onBtnclick: {
                        Mpris.previous();
                    }
                }
                BarContentItem {
                    width: parent.width/3
                    implicitHeight: root.scaleHeightMin
                    anchors.horizontalCenter: parent.horizontalCenter
                    contentItem: TextItem {
                        color: root.config.props.fgColors[0]
                        text: Mpris.currentPlayerState
                        textFormat: Text.StyledText

                    }
                    onBtnclick: {
                        Mpris.playPause();
                    }
                }
                BarContentItem {
                    anchors.right: parent.right
                    width: parent.width/3
                    implicitHeight: root.scaleHeightMin
                    contentItem: TextItem {
                        color: root.config.props.fgColors[0]
                        text: "󰒭"
                        textFormat: Text.StyledText

                    }
                    onBtnclick: {
                        Mpris.next();
                    }
                }
            }
        }
    }
}


