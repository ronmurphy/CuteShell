pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    // Properties that match the facade interface
    property list<var> windows: []
    property list<var> workspaces: []
    property int focusedWindowIndex: -1
    property string focusedWindowTitle: "(No active window)"
    property int focusedWorkspaceIndex: -1

    // Signals that match the facade interface
    signal workspaceChanged
    signal activeWindowChanged
    signal windowListChanged


    Component.onCompleted: {
        niriEventStream.running = true
        updateWorkspaces()
        updateWindows()
        console.log("NiriService", "Initialized successfully")
    }
    // Update workspaces
    function updateWorkspaces() {
        niriWorkspaceProcess.running = true
    }

    // Update windows
    function updateWindows() {
        niriWindowsProcess.running = true
    }
      

  // Niri workspace process
    Process {
        id: niriWorkspaceProcess
        running: false
        command: ["niri", "msg", "--json", "workspaces"]

        stdout: SplitParser {
            onRead: function (line) {
                try {
                    const workspacesData = JSON.parse(line)
                    const workspacesList = []

                    for (const ws of workspacesData) {
                        const isFocused = ws.is_focused === true
                        if (isFocused) {
                            root.focusedWorkspaceIndex = ws.idx
                        }
                        workspacesList.push({
                            "id": ws.id,
                            "idx": ws.idx,
                            "name": ws.name || "",
                            "output": ws.output || "",
                            "isFocused": isFocused,
                            "isActive": ws.is_active === true,
                            "isUrgent": ws.is_urgent === true,
                            "isOccupied": ws.active_window_id ? true : false
                        })
                    }

                    // Sort workspaces by output, then by index
                    workspacesList.sort((a, b) => {
                        if (a.output !== b.output) {
                            return a.output.localeCompare(b.output)
                        }
                        return a.idx - b.idx
                    })
                    console.log(root.workspaces.length)

                    root.workspaces = workspacesList
                    // Update the workspaces ListModel
                    workspaceChanged()
                } catch (e) {
                    console.log("NiriService", "Failed to parse workspaces:", e, line)
                }
            }
        }
    }

  // Niri windows process (for initial load)
    Process {
        id: niriWindowsProcess
        running: false
        command: ["niri", "msg", "--json", "windows"]

        stdout: SplitParser {
            onRead: function (line) {
                try {
                    const windowsData = JSON.parse(line)
                    root.windows = []

                    for (const win of windowsData) {
                        root.windows.push({
                            "id": win.id,
                            "title": win.title || "",
                            "appId": win.app_id || "",
                            "workspaceId": win.workspace_id || null,
                            "isFocused": win.is_focused === true
                        })
                    }

                    root.windows.sort((a, b) => a.id - b.id)
                    windowListChanged()
                    console.log(windowsData)
                    // Update focused window index
                    // root.focusedWindowIndex = -1
                    for (var i = 0; i < root.windows.length; i++) {
                        if (root.windows[i].isFocused) {
                            root.focusedWindowIndex = i
                            root.focusedWindowTitle = root.windows[i].title
                            break
                        }
                    }

                    activeWindowChanged()
                } catch (e) {
                    console.log("NiriService", "Failed to parse windows:", e, line)
                }
            }
        }
    }

  // Niri event stream process
    Process {
        id: niriEventStream
        running: false
        command: ["niri", "msg", "--json", "event-stream"]

        stdout: SplitParser {
            onRead: data => {
                try {
                    const event = JSON.parse(data.trim())
                    console.log(event)
                    if (event.WorkspacesChanged) {
                        root.updateWorkspaces()
                        console.log("workspace changed")
                    } else if (event.WindowOpenedOrChanged) {
                        root.handlewindowopenedorchanged(event.windowopenedorchanged)
                        console.log("window opened or ch")
                    } else if (event.windowclosed) {
                        root.handlewindowclosed(event.windowclosed)
                        console.log("window closed")
                    } else if (event.windowschanged) {
                        root.handlewindowschanged(event.windowschanged)
                        console.log("window changed")
                    } else if (event.workspaceactivated) {
                        root.updateworkspaces()
                        console.log("worspace activated")
                    } else if (event.windowfocuschanged) {
                        root.handlewindowfocuschanged(event.windowfocuschanged)
                        console.log("window focus changed")
                    }
                    // removed overviewopenedorclosed handling
                } catch (e) {
                    console.log("niriservice", "error parsing event stream:", e, data)
                }
            }
        }
    }

  // Event handlers
    function handlewindowopenedorchanged(eventData) {
        try {
            const windowData = eventData.window
            const existingIndex = windows.findIndex(w => w.id === windowData.id)

            const newWindow = {
                "id": windowData.id,
                "title": windowData.title || "",
                "appId": windowData.app_id || "",
                "workspaceId": windowData.workspace_id || null,
                "isFocused": windowData.is_focused === true
            }
                if (windowData.is_focused === true) {
                    console.log(windowData.title)
                    root.focusedWindowTitle = windowData.title
                }
            if (existingIndex >= 0) {
                // Update existing window
                windows[existingIndex] = newWindow
            } else {
                // Add new window
                windows.push(newWindow)
                windows.sort((a, b) => a.id - b.id)
            }

            // Update focused window index if this window is focused
            if (newWindow.isFocused) {
                const oldFocusedIndex = focusedWindowIndex
                focusedWindowIndex = windows.findIndex(w => w.id === windowData.id)

                // Only emit activeWindowChanged if the focused window actually changed
                if (oldFocusedIndex !== focusedWindowIndex) {
                    activeWindowChanged()
                }
            }

            windowListChanged()
        } catch (e) {
            console.log("NiriService", "Error handling WindowOpenedOrChanged:", e)
        }
    }

    function handleWindowClosed(eventData) {
        try {
            const windowId = eventData.id
            const windowIndex = windows.findIndex(w => w.id === windowId)

            if (windowIndex >= 0) {
                // If this was the focused window, clear focus
                if (windowIndex === focusedWindowIndex) {
                    focusedWindowIndex = -1
                    // activeWindowChanged()
                } else if (focusedWindowIndex > windowIndex) {
                    // Adjust focused window index if needed
                    focusedWindowIndex--
                }

                // Remove the window
                windows.splice(windowIndex, 1)
                windowListChanged()
            }
        } catch (e) {
            console.log("NiriService", "Error handling WindowClosed:", e)
        }
    }

    function handleWindowsChanged(eventData) {
        try {
            const windowsData = eventData.windows
            windows = []

            for (const win of windowsData) {
                if (win.is_focused === true) {
                    root.focusedWindowTitle = win.title
                    console.log(win.title)
                }
                windows.push({
                    "id": win.id,
                    "title": win.title || "",
                    "appId": win.app_id || "",
                    "workspaceId": win.workspace_id || null,
                    "isFocused": win.is_focused === true
                })
            }
            windows.sort((a, b) => a.id - b.id)
            windowListChanged()

            // Update focused window index
            focusedWindowIndex = -1
            for (var i = 0; i < windows.length; i++) {
                if (windows[i].isFocused) {
                    focusedWindowIndex = i
                    break
                }
            }

            activeWindowChanged()
        } catch (e) {
            console.log("NiriService", "Error handling WindowsChanged:", e)
        }
    }

    function handleWindowFocusChanged(eventData) {
        try {
            const focusedId = eventData.id

            if (focusedId) {
                const newIndex = windows.findIndex(w => w.id === focusedId)
                focusedWindowIndex = newIndex >= 0 ? newIndex : -1
            } else {
                focusedWindowIndex = -1
            }

            activeWindowChanged()
        } catch (e) {
            console.log("NiriService", "Error handling WindowFocusChanged:", e)
        }
    }

    // Public functions
    function switchToWorkspace(workspaceId) {
        try {
            Quickshell.execDetached(["niri", "msg", "action", "focus-workspace", workspaceId.toString()])
        } catch (e) {
            console.log("NiriService", "Failed to switch workspace:", e)
        }
    }

    function logout() {
        try {
            Quickshell.execDetached(["niri", "msg", "action", "quit", "--skip-confirmation"])
        } catch (e) {
            console.log("NiriService", "Failed to logout:", e)
        }
    }
}
