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

BarModuleItem {
    id:root
    isPopupVisible: false
    property bool inputactive: false
    
    popupComponent: Rectangle {
        id: rectpop
        anchors.fill:parent
        color: root.config.props.primaryColor
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
    
    property Component delegateComponent: Loader {
        id: del
        required property string name;
        required property string icon;
        required property string workingDirectory;
        required property list <string> command;
        required property bool runInTerminal;
        required property int index
        width: root.maxWidth
        height: root.scaleHeightMin
        Component.onCompleted: {
            del.setSource(root.config?.listDelegateProps?.source,
            Object.assign(root.config?.listDelegateProps?.properties,
            {colors: ["transparent",Settings.colorPick(root.config.props.primaryColor,root.config.props.bgColors,del.index)]}))
        }
        BarContentItem {
            id: barcnt
            z:1
            anchors.fill: del
            contentItem: Item {
                id:rl
                width: barcnt.width
                height: barcnt.height
                Image {
                    anchors.leftMargin:rl.height/2
                    anchors.left: parent.left
                    width: rl.height
                    height: rl.height
                    Layout.alignment: Qt.AlignCenter
                    source:Quickshell.iconPath(del.icon,true)
                }
                TextItem {
                    elide:Text.ElideRight
                    anchors.rightMargin:rl.height/2
                    anchors.right: parent.right
                    color: root.config.props.secondaryColor
                    width: rl.width-(rl.height*2)
                    height: rl.height
                    text: del.name
                }
            }
            onBtnclick: {
                Quickshell.execDetached({
                    command: del.command,
                    workingDirectory: del.workingDirectory,
                });
            }
        }
    }
    
    BarContentItem {
        implicitSize:root.scaleHeightMin
        contentItem: TextItem {
            color: root.config.props.secondaryColor
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
            color: root.config.props.secondaryColor
            text: ""
        }
        onBtnclick: {
            root.isPopupVisible = !root.isPopupVisible
            root.inputactive = true
        }
    }

    onConfigChanged: {
        input.contentLoader.setSource(root.config?.inputProps?.source,
        root.config?.inputProps?.properties)
    }

    InputItem {
        id: input
        decor: RectTriangleItem {
            colors: ["transparent",Settings.colorPick(root.config.primaryColor,root.config.bgColors,del.index)]
        }
        visible: root.inputactive
        implicitWidth:root.scaleHeightMin*4.5
        implicitHeight:root.scaleHeightMin*0.75
        onTextedited: {
            AppLauncher.matchString = gettext().toLowerCase()
            console.log(AppLauncher.matchString)
        }
    }

}
