
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
    isRectractable: false
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
            root.isPopupVisible = !root.isPopupVisible
            Settings.curridx = root.uniqueIndex == Settings.curridx ? -1 : root.uniqueIndex
        }
    }
    popupComponent: Rectangle {
        id: popupRect
        color:root.config.props.primaryColor
        Loader {
            id: upperLoader
            scale:0.8
            Component.onCompleted: {
                upperLoader.setSource(root.config?.listDelegateProps?.source,
                Object.assign(root.config?.listDelegateProps?.properties,
                {colors: ["transparent",root.config.props.bgColors[6]]}))
            }
            anchors.top: popupRect.top
            anchors.right: popupRect.right
            anchors.left: popupRect.left
            BarContentItem {
                z:1
                anchors.left: upperLoader.left
                implicitWidth: root.scaleHeightMin
                implicitHeight: root.scaleHeightMin
                contentItem: TextItem {
                    color: root.config.props.secondaryColor
                    text: Mpris.activePlayer && Mpris.activePlayer.canTogglePlaying ? "󰐊" : "󰏤"
                    textFormat: Text.StyledText

                }
                onBtnclick: {
                    Mpris.playPause();
                }
            }
            BarContentItem {
                z:1
                anchors.right: upperLoader.right
                // anchors.horizontalCenter: popupRect.horizontalCenter
                implicitWidth: root.scaleHeightMin*5
                implicitHeight: root.scaleHeightMin
                contentItem: TextItem {
                    color: root.config.props.secondaryColor
                    text: Mpris.currentArtist + " " + Mpris.currentTrack
                    textFormat: Text.StyledText
                        elide:Text.ElideRight
                }
            }
        }
    }
}


