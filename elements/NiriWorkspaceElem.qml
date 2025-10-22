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
        implicitHeight: root.scaleHeightMin
        layoutDirection: Qt.LeftToRight
        orientation: Qt.Horizontal
        model: NiriFinal.allWorkspaces
        delegate: BarContentItem {
            id: del
            required property string idx;
            implicitWidth: root.scaleHeightMin
            implicitHeight: root.scaleHeightMin
            
            contentItem: TextItem {
                text: idx
                color: Settings.colors_grayscale[0][0]
            }

            onBtnclick: {
                // Hyprland.activateWorkspaceById(id)
                Settings.curridx = root.uniqueIndex == Settings.curridx ? -1 : root.uniqueIndex
            }
        }
    }
}


