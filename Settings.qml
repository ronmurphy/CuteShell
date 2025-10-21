pragma Singleton

import QtQuick
import Quickshell

import Quickshell // for PanelWindow
import QtQuick // for Text

import "./services"
import "./items"
import "./decorations"
import "./animations"
import "./"

Singleton {
    id: root
    signal popupChanged
    property real scaleWidth: 1920
    property real scaleHeight: 1080    

    property int barAnchor: barAnchors.TOP
    property var barAnchors: Object.freeze({
        TOP: 0,
        BOTTOM: 1,
    });

    function changeBarState() {
        barAnchor = isTop ? barAnchors.BOTTOM : barAnchors.TOP
    }
    property bool isTop: barAnchor == barAnchors.TOP
    property color colors_onedark: {
        "#E5C07B" //yellow  
        "#61AFEF" //blue  
        "#E06C75" //red  
        "#C678DD" //purple  
        "#98C379" //green  
        "#56B6C2" //cyan  
        "#ABB2BF" //white  
        "#282C34" //black  
        "#3E4452" //gray  
    }
    property var colors_everforest: [
        "#d699b6",
        "#e67e80",
        "#e69875",
        "#dbbc7f",
        "#a7c080", 
        "#83c092",
        "#7fbbb3",
    ]
    property int currentDecorConfig: 0
    property list<string> decorComponents: ["./decorations/GenericDecorItem.qml",
        "./decorations/RectTriangleItem.qml",
        "./decorations/RectCircleItem.qml" ]
    
    property list<var> decorProperties: [
        {"radius":39},
        {},
        {},
    ]

    property list<string> windowcolors: ["#4c7fbbb3","#7fbbb3"]
    property string dark: "#424b50"
    property string white: "#d3c6aa"
    
    property int curridx:-1 // current index for retractable elements
    property int indexDistribute // indices for retractable elements
    
    function colorPick(excludeColor: string,idx: int): string {
        const rm = idx % colors_everforest.length
        if (colors_everforest[rm] === excludeColor) {
            return "#d699b6"
        }
        return colors_everforest[rm]
    }

    function distributeUniqueIndex(): int {
        indexDistribute +=1
        return indexDistribute
    }

}
