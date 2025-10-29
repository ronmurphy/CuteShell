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
    Item {
        id: dateclock
        implicitWidth: root.scaleHeightMin*2
        implicitHeight: root.scaleHeightMin
        BarContentItem {
            anchors.bottom: dateclock.bottom
            anchors.horizontalCenter: dateclock.horizontalCenter
            implicitWidth: root.scaleHeightMin*2
            implicitHeight: root.scaleHeightMin/2
            contentItem: TextItem {
                text: SysInfo2.clockdate
                color: root.config.props.secondaryColor
            }
            onClicked: {
               Settings.curridx = root.uniqueIndex == Settings.curridx ? -1 : root.uniqueIndex
            }
        }
        BarContentItem {
            anchors.top: dateclock.top
            anchors.horizontalCenter: dateclock.horizontalCenter
            implicitWidth: root.scaleHeightMin
            implicitHeight: root.scaleHeightMin/2
            contentItem: TextItem {
                color: root.config.props.secondaryColor
                text: SysInfo2.clocktime
                textFormat: Text.StyledText
            }
            onClicked: {
                Mpris.playPause();
            }
        }
    }
}

