import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Controls
import Quickshell.Widgets
import QtQuick.Layouts
import "../services"
import "../items"
import "../"

// Taskbar for labwc (ext-foreign-toplevel-list protocol).
// Shows one icon per open window; click to activate.
BarModuleItem {
    id: root
    isExpandable: false

    Row {
        id: taskRow
        spacing: root.scaleHeightMin * 0.15

        Repeater {
            model: ToplevelManager.toplevels

            delegate: BarContentItem {
                id: taskBtn
                required property var modelData

                implicitSize: root.scaleHeightMin * 0.9

                // Highlight the active window
                clr: taskBtn.modelData.activated
                    ? (root.config.props?.primaryColor   ?? "#ffffff")
                    : (root.config.props?.secondaryColor ?? "#888888")

                readonly property string iconName: {
                    var id = taskBtn.modelData.appId || ""
                    // Try last segment of reverse-DNS id first, then full id
                    return id.split(".").pop().toLowerCase() || "application-x-executable"
                }

                contentItem: Image {
                    width:  taskBtn.implicitSize * 0.65
                    height: taskBtn.implicitSize * 0.65
                    anchors.centerIn: parent
                    source:   Quickshell.iconPath(taskBtn.iconName, true)
                    fillMode: Image.PreserveAspectFit
                    smooth:   true
                }

                onClicked: taskBtn.modelData.activate()
            }
        }
    }
}
