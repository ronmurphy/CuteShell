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

pragma ComponentBehavior: Bound


BarElementItem {
    id:root

    Connections {
        target: NiriFinal
        function onWorkspacesChanged() {
            console.log("wripscake change",NiriFinal.focusedWorkspaceIndex)
            // listv.positionViewAtIndex(NiriFinal.findWorkspaceIndexById(NiriFinal.focusedWorkspaceId), ListView.Contain)
            listv.positionViewAtIndex(NiriFinal.focusedWorkspaceIndex, ListView.Contain)
        }
    }
    ListView {
        id:listv
        implicitWidth: root.uniqueIndex == Settings.curridx ? root.scaleHeightMin*3 : root.scaleHeightMin
        onImplicitWidthChanged: {
            listv.positionViewAtIndex(NiriFinal.focusedWorkspaceIndex, ListView.Contain)
        }
        implicitHeight: root.scaleHeightMin
        layoutDirection: Qt.LeftToRight
        orientation: Qt.Horizontal
        model: NiriFinal.allWorkspaces
        delegate: BarContentItem {
            id: del
            required property int idx;
            required property int index;
            implicitWidth: root.scaleHeightMin
            implicitHeight: root.scaleHeightMin
            contentItem: TextItem {
                text: idx
                color: del.index === NiriFinal.focusedWorkspaceIndex ? root.config.grayScaleColors[2]
                : root.config.grayScaleColors[0]
            }

            onBtnclick: {
                NiriFinal.switchToWorkspace(del.idx)
                Settings.curridx = root.uniqueIndex == Settings.curridx ? -1 : root.uniqueIndex
            }
        }
    }
}


