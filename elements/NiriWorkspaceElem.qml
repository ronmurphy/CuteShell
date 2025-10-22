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
    isscrollable: true;
    popupvisible: false;

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
        implicitWidth: root.indx == Settings.curridx ? root.scaleheightmin*3 : root.scaleheightmin
        implicitHeight: root.scaleheightmin
        layoutDirection: Qt.LeftToRight
        orientation: Qt.Horizontal
        model: NiriFinal.allWorkspaces
        delegate: BarContentItem {
            id: del
            required property string idx;
            implicitWidth: root.scaleheightmin
            implicitHeight: root.scaleheightmin
            
            contentItem: TextItem {
                text: idx
                color: Settings.colors_grayscale[0][0]
            }

            onBtnclick: {
                // Hyprland.activateWorkspaceById(id)
                Settings.curridx = root.indx == Settings.curridx ? -1 : root.indx
            }
        }
    }
}


