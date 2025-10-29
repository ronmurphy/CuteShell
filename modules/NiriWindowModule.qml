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

BarModuleItem {
    id:root
    isExpandable: false
    BarContentItem {
        implicitWidth: root.scaleHeightMin*3
        implicitHeight: root.scaleHeightMin
        contentItem: TextItem {
            font.pointSize:12
            elide: Text.ElideRight
            fontSizeMode: Text.VerticalFit
            text: NiriFinal.currentWindowTitle
            color: root.config.props.secondaryColor
        }
    }
}


