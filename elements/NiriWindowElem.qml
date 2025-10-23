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

BarElementItem {
    id:root
    defaultWidth: scaleHeightMin*3
    BarContentItem {
        implicitWidth: root.defaultWidth
        implicitHeight: root.scaleHeightMin
        contentItem: TextItem {
            font.pointSize:12
            elide: Text.ElideRight
            fontSizeMode: Text.VerticalFit
            text: NiriFinal.currentWindowTitle
        }
        onBtnclick: {
            Settings.curridx = root.uniqueIndex == Settings.curridx ? -1 : root.uniqueIndex
            root.isPopupVisible = false
        }
    }
}


