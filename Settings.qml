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
    
    function getConfig(options = {}) {
        const configs = {
            EverforestTriangle: {
                inverted: options.side === "left" || (options.side === "center" && options.sideIndex === 1) ? true : false,
                source:decorComponents[0],
                mainColor: Settings.colorPick("black",options?.sideIndex || 0),
                popupParentItem: options.side === "left" ||  options.side === "right" ? options.popupParentVariants[3]
                    : options.popupParentVariants[1],

                popupWidth: options.side === "left" ||  options.side === "right" ? null
                    : options.popupWidthVariants[1],

                sideLength: options.sideLength,
                gap: -1,
                colors: options.side === "center" ? ["transparent","#4c7fbbb3"] :
                    options.sideIndex === options.sideLength-1 ? ["transparent",colorPick("black",options.sideIndex)] : 
                    [colorPick("black",options.sideIndex+1),colorPick("black",options.sideIndex)], 

                get props() {
                    return {
                        flickableX: this.inverted ? 0 : (options?.scaleHeightMin/2 || 0),   
                        subtractRectWidth: options?.scaleHeightMin/2 || 0, 
                        defaultWidth: options?.firstChildrenWidth+(options?.scaleHeightMin*0.5),
                        // defaultWidth: options?.scaleHeightMin*1.5,
                        popupWidth: this.popupWidth ?? null,
                        popupX: options.scaleHeightMin/2,
                        popupParentItem: this.popupParentItem,
                        mainColor: this.mainColor,
                    }
                },
                get mainDecorProps() {
                    return {
                        inverted: this.inverted,
                        colors: this.colors,
                    }
                },
                get listDelegateProps() {
                    return {
                        source: "../decorations/RectTriangleItem.qml",
                        properties: {
                        
                        }
                    }
                },
                get inputProps() {
                    return {
                        source: "../decorations/RectTriangleItem.qml",
                        properties: {
                            colors: ["transparent",root.colors_grayscale[0][0]],
                            // scale: 0.7,
                            // implicitWidth: options?.scaleHeightMin,
                            // implicitHeight: options?.scaleHeightMin
                        }
                    }
                },
                get progressBarProperties() {
                    return {}
                },
                get sliderProps() {
                    return {
                        source: "../decorations/RectTriangleItem.qml",
                        properties: {
                            colors: ["transparent",root.colors_grayscale[0][0]]
                        }
                    }
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

    property list<string> centerColors: ["#4c7fbbb3","#7fbbb3"]
    
    property int curridx:-1 // current index for retractable elements
    property int indexDistribute // indices for retractable elements
    
    function colorPick(excludeColor: string,idx: int): string {
        const rm = idx % colors[0].length
        if (colors[0][rm] === excludeColor) {
            return colors[0][idx+1 % colors[0].length]
        }
        return colors[0][rm]
    }

    function distributeUniqueIndex(): int {
        indexDistribute +=1
        return indexDistribute
    }

}
