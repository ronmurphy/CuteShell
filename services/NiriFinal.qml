pragma Singleton

pragma ComponentBehavior: Bound

import QtCore
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
// import qs.Common

Singleton {
    id: root

    readonly property string socketPath: Quickshell.env("NIRI_SOCKET")

    property var workspaces: ({})
    property var allWorkspaces: []
    property int focusedWorkspaceIndex: 0
    property string focusedWorkspaceId: ""
    property string currentWindowTitle: ""
    property var windows: []

    property bool inOverview: false

    property int currentKeyboardLayoutIndex: 0
    property var keyboardLayoutNames: []

    property bool hasInitialConnection: false

    signal windowUrgentChanged
    DankSocket {
        id: eventStreamSocket
        path: root.socketPath
        connected: true

        onConnectionStateChanged: {
            if (connected) {
                send('"EventStream"')
            }
        }

        parser: SplitParser {
            onRead: line => {
                try {
                    const event = JSON.parse(line)
                    handleNiriEvent(event)
                } catch (e) {
                    console.warn("NiriService: Failed to parse event:", line, e)
                }
            }
        }
    }

    DankSocket {
        id: requestSocket
        path: root.socketPath
        connected: true
    }


    function handleNiriEvent(event) {
        const eventType = Object.keys(event)[0]
        switch (eventType) {
        case 'WorkspacesChanged':
            handleWorkspacesChanged(event.WorkspacesChanged)
            break
        case 'WorkspaceActivated':
            handleWorkspaceActivated(event.WorkspaceActivated)
            break
        case 'WorkspaceActiveWindowChanged':
            handleWorkspaceActiveWindowChanged(event.WorkspaceActiveWindowChanged)
            break
        case 'WorkspaceActiveWindowChanged':
            handleWorkspaceActiveWindowChanged(event.WorkspaceActiveWindowChanged)
            break
        case 'WindowFocusChanged':
            currentWindowTitle = windows.find(p => p.id === event.WindowFocusChanged.id).title
            break
        case 'WindowsChanged':
            windows = sortWindowsByLayout(event.WindowsChanged.windows)
            currentWindowTitle = windows.find(p => p.is_focused).title
            break
        case 'WindowOpenedOrChanged':
            handleWindowOpenedOrChanged(event.WindowOpenedOrChanged)
            break
        case 'WindowClosed':
            windows = windows.filter(w => w.id !== event.WindowClosed.id)
            break
        case 'OverviewOpenedOrClosed':
            inOverview = event.OverviewOpenedOrClosed.is_open
            break
        case 'KeyboardLayoutsChanged':
            keyboardLayoutNames = event.KeyboardLayoutsChanged.keyboard_layouts.names
            currentKeyboardLayoutIndex = event.KeyboardLayoutsChanged.keyboard_layouts.current_idx
            break
        case 'KeyboardLayoutSwitched':
            currentKeyboardLayoutIndex = event.KeyboardLayoutSwitched.idx
            break
        case 'WorkspaceUrgencyChanged':
            handleWorkspaceUrgencyChanged(event.WorkspaceUrgencyChanged)
            break
        }
    }

    function sortWindowsByLayout(windowList) {
        return [...windowList].sort((a, b) => {
            return a.id - b.id
        })
    }

    function handleWindowOpenedOrChanged(data) {
        if (!data.window) return

        const window = data.window
        const existingIndex = windows.findIndex(w => w.id === window.id)

        if (existingIndex >= 0) {
            const updatedWindows = [...windows]
            updatedWindows[existingIndex] = window
            windows = sortWindowsByLayout(updatedWindows)
            currentWindowTitle = windows.find(p => p.is_focused).title
            return
        }

        windows = sortWindowsByLayout([...windows, window])
    }

    function handleWorkspacesChanged(data) {
        const workspaces = {}

        for (const ws of data.workspaces) {
            workspaces[ws.id] = ws
        }

        root.workspaces = workspaces
        allWorkspaces = [...data.workspaces].sort((a, b) => a.idx - b.idx)

        focusedWorkspaceIndex = allWorkspaces.findIndex(w => w.is_focused)
        if (focusedWorkspaceIndex >= 0) {
            const focusedWs = allWorkspaces[focusedWorkspaceIndex]
            focusedWorkspaceId = focusedWs.id
        } else {
            focusedWorkspaceIndex = 0
            focusedWorkspaceId = ""
        }
        workspacesChanged()
    }

    function handleWorkspaceActivated(data) {
        const ws = root.workspaces[data.id]
        if (!ws) {
            return
        }
        const output = ws.output

        for (const id in root.workspaces) {
            const workspace = root.workspaces[id]
            const got_activated = workspace.id === data.id

            if (workspace.output === output) {
                workspace.is_active = got_activated
            }

            if (data.focused) {
                workspace.is_focused = got_activated
            }
        }

        focusedWorkspaceId = data.id
        focusedWorkspaceIndex = allWorkspaces.findIndex(w => w.id === data.id)
        allWorkspaces = Object.values(root.workspaces).sort((a, b) => a.idx - b.idx)
        workspacesChanged()
    }

    function handleWorkspaceActiveWindowChanged(data) {
        const updatedWindows = []

        for (var i = 0; i < windows.length; i++) {
            const w = windows[i]
            const updatedWindow = {}

            for (let prop in w) {
                updatedWindow[prop] = w[prop]
                
            }

            if (data.active_window_id !== null && data.active_window_id !== undefined) {
                updatedWindow.is_focused = (w.id == data.active_window_id)
            } else {
                updatedWindow.is_focused = w.workspace_id == data.workspace_id ? false : w.is_focused
            }
            updatedWindows.push(updatedWindow)
        }

        windows = updatedWindows
        currentWindowTitle = windows.find(p => p.is_focused).title
    }



    function handleWorkspaceUrgencyChanged(data) {
        const ws = root.workspaces[data.id]
        if (!ws) return

        ws.is_urgent = data.urgent

        const idx = allWorkspaces.findIndex(w => w.id === data.id)
        if (idx >= 0) {
            allWorkspaces[idx].is_urgent = data.urgent
        }

        windowUrgentChanged()
    }

    function send(request) {
        if (!requestSocket.connected) return false
        requestSocket.send(request)
        return true
    }

    function doScreenTransition() {
        return send({"Action": {"DoScreenTransition": {"delay_ms": 0}}})
    }

    function switchToWorkspace(workspaceIndex) {
        return send({"Action": {"FocusWorkspace": {"reference": {"Index": workspaceIndex}}}})
    }

    function focusWindow(windowId) {
        return send({"Action": {"FocusWindow": {"id": windowId}}})
    }

    function powerOffMonitors() {
        return send({"Action": {"PowerOffMonitors": {}}})
    }
    function powerOnMonitors() {
        return send({"Action": {"PowerOnMonitors": {}}})
    }

    function cycleKeyboardLayout() {
        return send({"Action": {"SwitchLayout": {"layout": "Next"}}})
    }

    function quit() {
        return send({"Action": {"Quit": {"skip_confirmation": true}}})
    }

    function getCurrentWorkspaceNumber() {
        if (focusedWorkspaceIndex >= 0 && focusedWorkspaceIndex < allWorkspaces.length) {
            return allWorkspaces[focusedWorkspaceIndex].idx + 1
        }
        return 1
    }

    function findWorkspaceIndexById(id: int): int {
        const index = allWorkspaces.findIndex(w => w.id === id)
        return index
    }

    function getCurrentKeyboardLayoutName() {
        if (currentKeyboardLayoutIndex >= 0 && currentKeyboardLayoutIndex < keyboardLayoutNames.length) {
            return keyboardLayoutNames[currentKeyboardLayoutIndex]
        }
        return ""
    }

}
