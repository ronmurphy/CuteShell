
import Quickshell // for PanelWindow
import Quickshell.Io
import QtQuick // for Text
import QtQuick.Controls
import Quickshell.Widgets
import QtQuick.Layouts
import QtQuick.Shapes
import QtQml

GenericDecorItem {
    id: root
    implicitWidth: 120
    implicitHeight: 40
    color: colors[0]
    property bool inverted: false
    state: inverted ? "left" : "right"
    TriangleItem {
        id: triang
        width: root.height/2
        height: root.height
        inverted: root.inverted
        clr: root.colors[2]
    }
    Rectangle {
        id: rect
        color: root.colors[1]
        width: root.width-root.height/2
        height: root.height
    }
    states: [
        State {
            name: "left"
            AnchorChanges {
                target: triang;
                anchors.right:  root.right
            }
            AnchorChanges {
                target: rect;
                anchors.left: root.left
            }
        },
        State {
            name: "right"
            AnchorChanges {
                target: triang;
                anchors.left: root.left
            }
            AnchorChanges {
                target: rect;
                anchors.right: root.right
            }
        }
    ]
}
// state = borderDecoration1 != null && borderDecoration2 != null ? "full" :
//     borderDecoration2 != null ? "right" :
//     borderDecoration1 != null ? "left" : "none"

