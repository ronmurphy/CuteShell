
import Quickshell // for PanelWindow
import Quickshell.Io
import QtQuick // for Text
import QtQuick.Controls
import Quickshell.Widgets
import QtQuick.Layouts
import QtQuick.Shapes
import QtQml
import "./services"
import "./items"
import "../decorations"
import "../"

   
Loader {
    id: root
    property var loaderProps: [null,null]
    onLoaderPropsChanged: {
        root.setSource(loaderProps[0],loaderProps[1])
    }
}
