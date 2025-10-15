pragma Singleton

import QtQuick
import Quickshell

import Quickshell // for PanelWindow
import QtQuick // for Text

Singleton {
    id: root
    property int barAnchor: barAnchors.TOP
    property var barAnchors: Object.freeze({
        TOP: 0,
        BOTTOM: 1,
    });
    function changeBarState() {
        barAnchor = isTop ? barAnchors.BOTTOM : barAnchors.TOP
    }
    property bool isTop: barAnchor == barAnchors.TOP

    property var colors: [
        "#d699b6",
        "#e67e80",
        "#e69875",
        "#dbbc7f",
        "#a7c080", 
        "#83c092",
        "#7fbbb3"]

    property list<string> windowcolors: ["#4c7fbbb3","#7fbbb3"]
    property string dark: "#424b50"
    property string white: "#d3c6aa"
    
    property real scaleWidth: 1920
    property real scaleHeight: 1080    

    property int curridx:-1 // current index for retractable elements
    property int indexDistribute // indices for retractable elements
    
    property bool popupOpen: false
    property Item popupLoader: null

    function colorPick(excludeColor: string,idx: int): string {
        const rm = idx % colors.length
        if (colors[rm] === excludeColor) {
            return "#d699b6"
        }
        return colors[rm]
    }

    function distributeUniqueIndex(): int {
        indexDistribute +=1
        return indexDistribute
    }

}
