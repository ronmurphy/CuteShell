pragma Singleton

import Quickshell // for PanelWindow
import Quickshell.Io
import QtQuick // for Text
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Widgets
import QtQml.Models

Singleton {
    id:root
    property string matchString: "btop"

    readonly property var applications: DesktopEntries.applications.values
    readonly property list<DesktopEntry> allDesktopEntries: DesktopEntries.applications.values

    property list<DesktopEntry> desktopEntries: allDesktopEntries.filter(
        entry => entry?.name?.toLowerCase().includes(matchString) || false
    );
    
    function appIconByAppId(id: string): string {
        const desktopentry = DesktopEntries.byId(id)
        console.log(desktopentry)
        return Quickshell.iconPath(desktopentry.icon, true)
    }
}
