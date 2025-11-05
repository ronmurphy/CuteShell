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
    isExpandable:false
    Item {
        id: dateclock
        implicitWidth: root.scaleHeightMin*2
        implicitHeight: root.scaleHeightMin
        BarContentItem {
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin:root.scaleHeightMin/10

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
            anchors.bottom: parent.bottom
            anchors.bottomMargin:root.scaleHeightMin/10
            anchors.horizontalCenter: parent.horizontalCenter

            implicitWidth: root.scaleHeightMin
            implicitHeight: root.scaleHeightMin/2
            contentItem: TextItem {
                color: root.config.props.secondaryColor
                text: SysInfo2.clocktime
                textFormat: Text.StyledText
            }
        }
    }
}

