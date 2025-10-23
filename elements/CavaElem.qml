
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
           Settings.curridx = root.uniqueIndex == Settings.curridx ? -1 : root.uniqueIndex
        }
    }
    // BarContentItem {
    //     Layout.preferredWidth: root.scaleHeightMin
    //     Layout.preferredHeight: root.scaleHeightMin
    //     item: Text {
    //         text: Mpris.activePlayer && Mpris.activePlayer.canTogglePlaying ? "󰐊" : "󰏤"
    //         horizontalAlignment: Text.AlignHCenter
    //         verticalAlignment: Text.AlignVCenter
    //         font.pointSize:12
    //         textFormat: Text.StyledText
    //     }
    //     onBtnclick: {
    //         Mpris.playPause();
    //     }
    // }
    // BarContentItem {
    //     Layout.preferredWidth: root.scaleHeightMin
    //     Layout.preferredHeight: root.scaleHeightMin
    //     item: Text {
    //         text: SysInfo2.clocktime
    //         horizontalAlignment: Text.AlignHCenter
    //         verticalAlignment: Text.AlignVCenter
    //         font.pointSize:12
    //         textFormat: Text.StyledText
    //     }
    //     onBtnclick: {
    //         Mpris.playPause();
    //     }
    // }
}


