
import Quickshell // for PanelWindow
import Quickshell.Io
import QtQuick // for Text
import QtQuick.Controls
import Quickshell.Widgets
import QtQuick.Layouts
import QtQuick.Shapes
import QtQml


Rectangle {
    id: root
    property color clr: "blue"
    property bool inverted: false
    property real implicitSize: 40
    color: "transparent"
    Shape {
        anchors.fill: root

        ShapePath {
            fillColor: root.clr
            // strokeColor: "darkBlue"
            strokeWidth: -1
            // capStyle: ShapePath.FlatCap

            PathAngleArc {
                centerY: root.height/2

                centerX: root.inverted ? root.height/2 : 0

                radiusX: root.height/2; radiusY: root.height/2
                startAngle: root.inverted ? 90 : 270
                sweepAngle: 180
            }
        }
    }
}
