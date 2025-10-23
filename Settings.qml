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
    property string decorConfigName: "EverforestTriangle"
    property list<string> decorComponents: ["./decorations/DirectedRectTriangle.qml",
        "./decorations/GenericDecorItem.qml",
        "./decorations/RectTriangleItem.qml"]
    
    // function getConfig(themeName,itemType,index,side,lengthSide) {
    function getDecorConfig(options = {}) {
        const configs = {
            "EverforestTriangle": {
                "BarElement":{
                    inverted: options.side === "left" || (options.side === "center" && options.sideIndex === 1) ? true : false,
                    source:decorComponents[0],
                    
                    get decorProperties() {
                        return {
                            inverted: this.inverted,
                            colors: ["transparent",colorPick(options.mainColor,options.uniqueIndex),Settings.colorPick(options.mainColor,options.uniqueIndex)],
                        }
                    },
    
                    get properties() {
                        return {
                            flickableX: this.inverted ? 0 : (options?.contentRectHeight/2 || 0),   
                            flickableWidth: (options?.contentRectWidth - options?.contentRectHeight/2) || 100, 
                            defaultWidth: options?.scaleHeightMin*1.5
                        }
                        // inverted: options.side === "left" || (options.side === "center" && options.sideIndex === 1) ? true : false,
                        // flickableX: decorProperties.inverted ?
                    }
                },
                "Input":{
                    
                },
                "ProgressBar":{
                
                },
                "Slider":{
                
                }
            },
            "OnedarkCircle": {
                "Settings": {
                
                },
                "BarElement":{
                
                },
                "Input":{
                    
                },
                "ProgressBar":{
                
                },
                "Slider":{
                
                }
            }
        }
        return configs[options.themeName]
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
