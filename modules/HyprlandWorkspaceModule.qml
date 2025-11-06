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
import "../items"

pragma ComponentBehavior: Bound

BarModuleItem {
    id:root
    visibleExpandedElements:1
    Connections {
        target: Hyprland
        function onWorkspacesChanged() {
            listv.positionViewAtIndex(Hyprland.findWorkspaceIndexById(Hyprland.focusedworkspace.id), ListView.Contain)
        }
        function onFocusedworkspaceChanged() {
            listv.positionViewAtIndex(Hyprland.findWorkspaceIndexById(Hyprland.focusedworkspace.id), ListView.Contain)
        }
    }
    onCurrConfigChanged: {
        listv.implicitWidthChanged()
        listv.positionViewAtIndex(Hyprland.findWorkspaceIndexById(Hyprland.focusedworkspace.id), ListView.Contain)
    }
    ListView {
        id:listv
        implicitWidth: root.uniqueIndex === Settings.curridx || !root.isExpandable?
            root.scaleHeightMin*3 : root.scaleHeightMin
        implicitHeight: root.scaleHeightMin
        onImplicitWidthChanged: {
            listv.positionViewAtIndex(Hyprland.findWorkspaceIndexById(Hyprland.focusedworkspace.id), ListView.Contain)
        }

        boundsBehavior: Flickable.StopAtBounds
        clip:true
        layoutDirection: Qt.LeftToRight
        orientation: Qt.Horizontal
        model: Hyprland.workspaces
        delegate: BarContentItem {
            id: del
            required property int id;
            required property int index;
            implicitWidth: root.scaleHeightMin
            implicitHeight: root.scaleHeightMin
            
            contentItem: TextItem {
                text: del.id
                color: del.index === Hyprland.currentWorkspaceIndex ? root.config.listDelegateProps.workspaceColor1 : root.config.listDelegateProps.workspaceColor2
            }

            onClicked: {
                if (del.index != Hyprland.currentWorkspaceIndex) Hyprland.activateWorkspaceById(del.id)
                Settings.curridx = root.uniqueIndex == Settings.curridx ? -1 : root.uniqueIndex
            }
        }
    }
    BarContentItem {
        implicitWidth: root.scaleHeightMin
        implicitHeight: root.scaleHeightMin
        contentItem: TextItem {
            text: root.isExpandable ? " " : " "
            color: root.config.props.secondaryColor
        }
        onClicked: {
            root.isExpandable = !root.isExpandable
        }
    }
}


