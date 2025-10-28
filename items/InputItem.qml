import Quickshell // for PanelWindow
import Quickshell.Io
import QtQuick // for Text
import QtQuick.Controls
import Quickshell.Widgets
import QtQuick.Layouts
import QtQuick.Shapes
import QtQml
import "../"

Rectangle {
    id:root
    property color textClr: Settings.white
    property Component decor: null
    property Loader loader: loader
    property real scaleInputWidth: 0.75

    property Loader contentLoader: loader
    signal textedited
    signal accepted
    signal editingfinished
    function gettext(): string {
        return inp.text
    }
    color: "transparent"
    clip: true
    implicitWidth: 80
    implicitHeight: 40

    FontMetrics  {
        id: textMetrics
        font.pixelSize:20
    }
    
    Loader {
        id: loader
        anchors.fill: parent
        sourceComponent: root.decor
    }

    TextInput {
        echoMode: TextInput.Normal
        id: inp
        width: contentLoader.width
        anchors.centerIn: parent
        focus: true
        activeFocusOnPress: true
        activeFocusOnTab: true
        color: root.textClr
        selectByMouse: true
        text: ""
        font.pixelSize:20
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        onTextChanged: {
            font.pixelSize=20*Math.min(1,width/(textMetrics.advanceWidth(text)*1.4));
            textMetrics.font.pixelSize=font.pixelSize
        }
        clip:true

        onAccepted: root.accepted()
        onEditingFinished: root.editingfinished()
        onTextEdited: root.textedited()
    }
}
