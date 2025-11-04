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
    isPopupVisible: true
    property bool inputactive: false
    
    popupComponent: LoaderItem {
        id: popupldr
        clip:true
        loaderProps: [root.config?.popupProps?.source,root.config?.popupProps?.properties]

        ListView {
            id:lstv
            highlightRangeMode: ListView.StrictlyEnforceRange
            anchors.fill:parent
            anchors.topMargin:root.config?.listDelegateProps?.listvTopMargin || 0
            anchors.bottomMargin:root.config?.listDelegateProps?.listvBottomMargin || 0
            clip:true
            model: AppLauncher.desktopEntries
            delegate: root.delegateComponent
        }
    }
    
    property Component delegateComponent: LoaderItem {
        id: del
        scale: root.config?.listDelegateProps?.scale || 1
        required property string name;
        required property string icon;
        required property string workingDirectory;
        required property list <string> command;
        required property int index
        
        width: root.maxWidth-root.config?.props?.subtractPopupWidth ||
            root.maxWidth+root.config?.props?.addPopupWidth || root.maxWidth
        height: root.scaleHeightMin

        loaderProps: [root.config?.listDelegateProps?.source,Object.assign(root.config?.listDelegateProps?.properties,
            {colors: [root.config?.listDelegateProps?.genericBgColor || "transparent",
            Settings.colorPick(root.config.props.primaryColor,root.config.listDelegateProps.bgColors,del.index,2)]})]

        property color fgColor: Settings.colorPick(root.config.props.primaryColor,
                        root.config.listDelegateProps.fgColors,del.index,2)
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
                    scale:0.9
                    width: rl.height
                    height: rl.height
                    Layout.alignment: Qt.AlignCenter
                    source:Quickshell.iconPath(del.icon,true)
                }
                TextItem {
                    elide:Text.ElideRight
                    anchors.rightMargin:rl.height/2
                    anchors.right: parent.right
                    color: del.fgColor
                    width: rl.width-(rl.height*2)
                    height: rl.height
                    text: del.name
                }
            }
            onClicked: {
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
        onClicked: {
            Settings.curridx = root.uniqueIndex == Settings.curridx ? -1 : root.uniqueIndex
        }
    }

    onConfigChanged: {
        input.contentLoader.setSource(root.config?.inputProps?.source,
        root.config?.inputProps?.properties)
    }

    InputItem {
        id: input
        decor: RectTriangleItem {
            colors: ["transparent",Settings.colorPick(root.config.primaryColor,root.config.bgColors,del.index,2)]
        }
        implicitWidth:root.scaleHeightMin*3.5
        implicitHeight:root.scaleHeightMin*0.6
        onTextedited: {
            AppLauncher.matchString = gettext().toLowerCase()
        }
    }

}
