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
import "../decorations"
import "../"

pragma ComponentBehavior: Bound

BarElementItem {
    id:root
    isPopupVisible: false
    property bool inputactive: false
    
    popupComponent: Rectangle {
        id: rectpop
        anchors.fill:parent
        color: root.clr
        clip:true
        ListView {
            // highlightRangeMode: ListView.StrictlyEnforceRange
            highlightRangeMode: ListView.StrictlyEnforceRange
            anchors.fill: parent
            model: AppLauncher.apps
            contentWidth: root.scaleHeightMin
            contentHeight: root.height
            delegate: root.delegateComponent
        }
    }
    property Component delegateComponent: ListDelegateItem {
        id: del
        required property string appname;
        required property string appicon;
        required property int index
        implicitWidth: root.contentWidth
        implicitHeight: root.scaleHeightMin
        decor: RectTriangleItem {
            colors: ["transparent",Settings.colorPick(root.clr,del.index)]
        }
        BarContentItem {
            id: barcnt
            implicitWidth: root.contentWidth
            implicitHeight: root.scaleHeightMin
            scale:0.9
            contentItem: Item {
                id:rl
                width: barcnt.width
                height: barcnt.height
                Image {
                    scale:0.8
                    anchors.left: parent.left
                    width: rl.height
                    height: rl.height
                    Layout.alignment: Qt.AlignCenter
                    source:del.appicon
                }
                TextItem {
                    anchors.right: parent.right
                    width: rl.width-rl.height
                    height: rl.height
                    text: del.appname
                }
            }
            onBtnclick: {
                AppLauncher.pathname = del.sectxt
                console.log(AppLauncher.pathname)
                AppLauncher.isexec = true;
            }
        }
    }
    
    BarContentItem {
        implicitSize:root.scaleHeightMin
        contentItem: TextItem {
            // implicitSize: root.scaleHeightMin
            text: "󰀻"
        }
        onBtnclick: {
            Settings.changeBarState()
            Settings.curridx = root.uniqueIndex == Settings.curridx ? -1 : root.uniqueIndex
        }
    }

    BarContentItem {
        visible: !root.inputactive
        implicitSize:root.scaleHeightMin
        contentItem: TextItem {
            text: ""
        }
        onBtnclick: {
            root.isPopupVisible = !root.isPopupVisible
            root.inputactive = true
        }
    }

    InputItem {
        id: input
        decor: RectTriangleItem {
            colors: ["transparent",Settings.colorPick(root.clr,del.index)]
        }
        visible: root.inputactive
        implicitWidth:root.scaleHeightMin*5
        implicitHeight:root.scaleHeightMin
        // Component.onCompleted: {
        //     input.loader.setSource(root.decorConfig?.BarElement?.source,root.decorConfig?.BarElement?.decorProperties)
        // }
        onTextedited: {
            AppLauncher.searchApplications(gettext())
        }
    }

}
