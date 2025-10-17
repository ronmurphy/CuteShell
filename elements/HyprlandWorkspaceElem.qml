import Quickshell // for PanelWindow
import Quickshell.Io
import QtQuick // for Text
import QtQuick.Controls
import Quickshell.Widgets
import QtQuick.Layouts
import QtQuick.Shapes
import QtQml
import "../services"
import "../"

pragma ComponentBehavior: Bound

BarItem {
    id:root
    isscrollable: true;
    popupvisible: false;

    Connections {
        target: Hyprland
        function onWorkspacesChanged() {
            console.log("wripscake change1")
            listv.positionViewAtIndex(Hyprland.findWorkspaceIndexById(Hyprland.focusedworkspace.id), ListView.Contain)
        }
        function onFocusedworkspaceChanged() {
            console.log("wripscake change2")
            listv.positionViewAtIndex(Hyprland.findWorkspaceIndexById(Hyprland.focusedworkspace.id), ListView.Contain)
        }
    }
    ListView {
        id:listv
        implicitWidth: root.indx == Settings.curridx ? root.scaleheightmin*3 : root.scaleheightmin
        implicitHeight: root.defaultWidth
        layoutDirection: Qt.LeftToRight
        orientation: Qt.Horizontal
        model: Hyprland.workspaces
        delegate: BarContentItem {
            id: del
            required property string id;
            implicitWidth: root.defaultWidth
            implicitHeight: root.defaultWidth
            
            contentItem: TextItem {
                text: id
                color: Settings.dark
            }

            onBtnclick: {
                Hyprland.activateWorkspaceById(id)
                Settings.curridx = root.indx == Settings.curridx ? -1 : root.indx
            }
        }
    }
}


