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


BarModuleItem {
    id:root
    visibleExpandedElements:1
    Connections {
        target: Niri
        function onWorkspacesChanged() {
            listv.positionViewAtIndex(Niri.focusedWorkspaceIndex, ListView.Center)
        }
    }
    onCurrConfigChanged: {
        listv.implicitWidthChanged()
        listv.positionViewAtIndex(Niri.focusedWorkspaceIndex, ListView.Center)
    }
    ListView {
        id:listv
        implicitWidth: root.uniqueIndex === Settings.curridx || !root.isExpandable?
            root.scaleHeightMin*3 : root.scaleHeightMin
        onImplicitWidthChanged: {
            listv.positionViewAtIndex(Niri.focusedWorkspaceIndex, ListView.Center)
        }
        boundsBehavior: Flickable.StopAtBounds
        clip:true
        implicitHeight: root.scaleHeightMin
        layoutDirection: Qt.LeftToRight
        orientation: Qt.Horizontal
        model: Niri.allWorkspaces
        delegate: BarContentItem {
            id: del
            required property int idx;
            required property int index;
            implicitWidth: root.scaleHeightMin
            implicitHeight: root.scaleHeightMin
            contentItem: TextItem {
                id:textitem
                text: idx
                color: del.index === Niri.focusedWorkspaceIndex ?
                root.config.listDelegateProps.workspaceColor1: root.config.listDelegateProps.workspaceColor2
            }

            onClicked: {
                Niri.switchToWorkspace(del.idx)
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


