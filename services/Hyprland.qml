pragma Singleton

pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland

Singleton {
    id: root
    readonly property list<HyprlandWorkspace> workspaces: Hyprland.workspaces.values
    readonly property var activetoplevel: Hyprland.activeToplevel
    readonly property var focusedworkspace: Hyprland.focusedWorkspace

    function findWorkspaceIndexById(id: int): int {
        const index = workspaces.findIndex(w => w.id === id)
        console.log(index)
        return index
    }
    function activateWorkspaceById(id:int) {
        const index = workspaces.findIndex(w => w.id === id)
        workspaces[index].activate()
    }       
}

