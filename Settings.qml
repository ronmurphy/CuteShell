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
    property list<var> colorsGrayscale: [ // black,gray,white
        ["#424b50",
        "#8a887d",
        "#d3c6aa"],
        ["#282C34",
        "#3E4452",
        "#ABB2BF"],
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
                popupParentItem: options.side === "left" ||  options.side === "right" ? options.popupParentVariants[2]
                    : options.popupParentVariants[1],

                popupWidth: options.side === "center" ? options.popupWidthVariants[1] : 0,
                subtractPopupWidth: 0,
                addPopupWidth: options.side === "left" ? 0 :
                    options.side === "right" ? options.scaleHeightMin/2: 0,

                sideLength: options.sideLength,
                gap: -1,
                popupX: options.side === "left" ? -options.scaleHeightMin/2 :
                    options.side === "right" ? options.scaleHeightMin/2 : options.scaleHeightMin/2,

                get palette() {
                    return {
                        bgColors: root.colors[0],
                        fgColors: root.colorsGrayscale[0]
                    }
                },
                get sideColors() {
                    return {
                        colors: options.side === "center" ? ["transparent","#4c7fbbb3"] :
                            options.sideIndex === options.sideLength-1 ? ["transparent",colorPick("",this.palette.bgColors,options.sideIndex)] : 
                            [colorPick("",this.palette.bgColors,options.sideIndex+1),colorPick("",this.palette.bgColors,options.sideIndex)],
                    }
                },

                get props() {
                    return {
                        flickableX: this.inverted ? 0 : (options?.scaleHeightMin/2 || 0),   
                        subtractRectWidth: options?.scaleHeightMin/2 || 0, 
                        defaultWidth: options?.firstChildrenWidth+(options?.scaleHeightMin*0.5),
                        popupWidth: this.popupWidth,
                        subtractPopupWidth: this.subtractPopupWidth,
                        popupX: this.popupX,
                        popupParentItem: this.popupParentItem,
                        primaryColor: colorPick("",this.palette.bgColors,options?.sideIndex || 0),
                        secondaryColor: this.palette.fgColors[0],
                        bgColors: this.palette.bgColors,
                        fgColors: this.palette.fgColors,
                    }
                },
                get mainDecorProps() {
                    return {
                        inverted: this.inverted,
                        colors: this.sideColors.colors,
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
                            colors: ["transparent",this.palette.fgColors[0]],
                        }
                    }
                },
                get progressBarProps() {
                    return {
                        bgSource: "../decorations/GenericDecorItem.qml",
                        bgProps: {
                            color: "transparent",
                            radius:options.scaleHeightMin*0.2,
                            "border.width": options.scaleHeightMin*0.07,
                            "border.color": this.palette.fgColors[0],
                            borderColor: this.palette.fgColors[0],
                        },
                        fgSource: "../decorations/GenericDecorItem.qml",
                        fgProps: {
                            // colors: ["transparent",root.colors_grayscale[0][0]],
                            color:this.palette.fgColors[2],
                            radius:options.scaleHeightMin*0.3
                        }
                    }
                },
                get sliderProps() {
                    return this.inputProps
                }
            },
        }
        return configs[options.themeName]
    }

    property list<string> centerColors: ["#4c7fbbb3","#7fbbb3"]
    
    property int curridx:-1 // current index for module
    property int indexDistribute // indices for modules
    
    function colorPick(excludeColor,colors,idx) {
        const rm = idx % colors.length
        const rm2 = (idx+1) % colors.length
        if (colors[rm] === excludeColor) {
            return colors[rm2]
        }
        return colors[rm]
    }

    function distributeUniqueIndex(): int {
        indexDistribute +=1
        return indexDistribute
    }

}
