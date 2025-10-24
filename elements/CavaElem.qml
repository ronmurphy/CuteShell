
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

BarElementItem {
    id:root
    defaultWidth: scaleHeightMin*3
    BarContentItem {
        implicitWidth: root.defaultWidth
        implicitHeight: root.scaleHeightMin
        contentItem: TextItem {
            font.bold: true
            font.weight: Font.ExtraBold
            scale:1.2
            text: Cava.output
            textFormat: Text.StyledText
        }
        onBtnclick: {
            root.isPopupVisible = !root.isPopupVisible
            Settings.curridx = root.uniqueIndex == Settings.curridx ? -1 : root.uniqueIndex
        }
    }
    popupComponent: Rectangle {
        id: popupRect
        BarContentItem {
            anchors.left: popupRect.left
            implicitWidth: root.scaleHeightMin
            implicitHeight: root.scaleHeightMin
            contentItem: TextItem {
                text: Mpris.activePlayer && Mpris.activePlayer.canTogglePlaying ? "󰐊" : "󰏤"
                textFormat: Text.StyledText
            }
            onBtnclick: {
                Mpris.playPause();
            }
        }
        BarContentItem {
            anchors.right: popupRect.right
            implicitWidth: root.scaleHeightMin
            implicitHeight: root.scaleHeightMin
            contentItem: TextItem {
                text: SysInfo2.clocktime
                textFormat: Text.StyledText
            }
            onBtnclick: {
                Mpris.playPause();
            }
        }
        BarContentItem {
            anchors.centerIn: popupRect.center
            anchors.horizontalCenter: popupRect.horizontalCenter
            implicitWidth: root.scaleHeightMin*5
            implicitHeight: root.scaleHeightMin
            contentItem: TextItem {
                text: Mpris.currentArtist + " " + Mpris.currentTrack
                textFormat: Text.StyledText
            }
            onBtnclick: {
                Mpris.playPause();
            }
        }
    }
}


