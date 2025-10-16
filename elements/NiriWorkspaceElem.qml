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
        target: Niri
        function onWorkspaceChanged() {
            console.log("wripscake change",Niri.focusedWorkspaceIndex)
            listv.positionViewAtIndex(Niri.focusedWorkspaceIndex, ListView.Contain)
        }
    }

}

