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
    property string matchString: ""

    readonly property list<DesktopEntry> allDesktopEntries: DesktopEntries.applications.values

    property list<DesktopEntry> desktopEntries: allDesktopEntries.filter(
        entry => entry?.name?.toLowerCase().includes(matchString) && entry?.runInTerminal === false || false
    );
    
    function appIconByAppId(id: string): string {
        const desktopentry = DesktopEntries.byId(id)
        return Quickshell.iconPath(desktopentry.icon, true)
    }
}
