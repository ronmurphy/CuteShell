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
    
    // popupParent: root
    
    popupComponent: Rectangle {
        id: rectpop
        anchors.fill:parent
        color: root.clr
        clip:true
        ListView {
            // highlightRangeMode: ListView.StrictlyEnforceRange
            highlightRangeMode: ListView.StrictlyEnforceRange
            anchors.fill: parent
            model: AppLauncher.desktopEntries
            contentWidth: root.scaleHeightMin
            contentHeight: root.height
            delegate: root.delegateComponent
        }
    }
    
    property Component delegateComponent: Item {
        id: del
        required property string name;
        required property string icon;
        required property int index
        implicitWidth: root.contentWidth
        implicitHeight: root.scaleHeightMin
        Loader {
            id: delegateLoader
            anchors.fill: parent
            Component.onCompleted: {
                delegateLoader.setSource(root.config?.listDelegateProps?.source,
                Object.assign(root.config?.listDelegateProps?.properties,
                {colors: ["transparent",Settings.colorPick(root.mainColor,del.index)]}))

            }
        }
        BarContentItem {
            id: barcnt
            implicitWidth: root.contentWidth
            implicitHeight: root.scaleHeightMin
            // scale:1
            x: delegateLoader.height
            contentItem: Item {
                id:rl
                width: barcnt.width
                height: barcnt.height
                Image {
                    // scale:1
                    anchors.left: parent.left
                    width: rl.height
                    height: rl.height
                    Layout.alignment: Qt.AlignCenter
                    source:Quickshell.iconPath(del.icon,true)
                }
                TextItem {
                    anchors.right: parent.right
                    width: rl.width-rl.height
                    height: rl.height
                    text: del.name
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
        //     input.loader.setSource(root.config?.BarElement?.source,root.config?.BarElement?.decorProperties)
        // }
        onTextedited: {
            
            AppLauncher.matchString = gettext().toLowerCase()
            console.log(AppLauncher.matchString)
        }
    }

}
