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
        target: NiriFinal
        function onWorkspacesChanged() {
            listv.positionViewAtIndex(NiriFinal.focusedWorkspaceIndex, ListView.Center)
        }
    }
    ListView {
        id:listv
        implicitWidth: root.uniqueIndex === Settings.curridx || !root.isExpandable?
            root.scaleHeightMin*3 : root.scaleHeightMin
        onImplicitWidthChanged: {
            listv.positionViewAtIndex(NiriFinal.focusedWorkspaceIndex, ListView.Center)
        }
        boundsBehavior: Flickable.StopAtBounds
        clip:true
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
                id:textitem
                text: idx
                color: del.index === NiriFinal.focusedWorkspaceIndex ?
                root.config.listDelegateProps.workspaceColor1: root.config.listDelegateProps.workspaceColor2
            }

            onClicked: {
                NiriFinal.switchToWorkspace(del.idx)
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


