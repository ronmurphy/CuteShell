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
    property list<var> colors: [
        ["#d699b6",
        "#e67e80",
        "#e69875",
        "#dbbc7f",
        "#a7c080", 
        "#83c092",
        "#7fbbb3",],
        ["#C678DD", //purple  
        "#E06C75", //red  
        "#E5C07B", //yellow  
        "#98C379", //green  
        "#56B6C2", //cyan  
        "#61AFEF",] //blue
    ]
    property list<var> colors_grayscale: [
        ["#424b50",
        "#d3c6aa"],

        ["#ABB2BF", //white  
        "#282C34", //black  
        "#3E4452",] //gray
    ]
    property int currentDecorConfig: 0
    property list<string> decorComponents: ["./decorations/GenericDecorItem.qml",
        "./decorations/GenericDecorItem.qml",
        "./decorations/RectTriangleItem.qml"]
    
    property list<var> decorProperties: [
        {"implicitWidth":0,
        "implicitHeight":0,
        },
        {"radius":0},
        {},
        {},
    ]
    property list<var> decorConfigs: [
        (index, side, length) => {
            console.log("hi");
        },
        {},
        {},
    ]
    function isAllowed(index, side, length) {
        return true
    }

    property list<string> windowcolors: ["#4c7fbbb3","#7fbbb3"]
    
    property int curridx:-1 // current index for retractable elements
    property int indexDistribute // indices for retractable elements
    
    function colorPick(excludeColor: string,idx: int): string {
        const rm = idx % colors[0].length
        if (colors[0][rm] === excludeColor) {
            return "#d699b6"
        }
        return colors[0][rm]
    }

    function distributeUniqueIndex(): int {
        indexDistribute +=1
        return indexDistribute
    }

}
