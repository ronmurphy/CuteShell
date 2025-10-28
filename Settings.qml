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

    property list<string> decorComponents: ["./decorations/DirectedRectTriangle.qml",
        "./decorations/GenericDecorItem.qml",
        "./decorations/RectTriangleItem.qml"]
    
    property list<string> centerColors: ["#4c7fbbb3","#7fbbb3"]
    
    property int curridx:-1 // current index for module
    property int indexDistribute // indices for modules
    
    function colorPick(excludeColor,colors,idx) {
        const rm = idx % colors.length
        const rm2 = (idx+2) % colors.length
        if (colors[rm] === excludeColor) {
            return colors[rm2]
        }
        return colors[rm]
    }

    function distributeUniqueIndex(): int {
        indexDistribute +=1
        return indexDistribute
    }
    property var currentConfig: nextConfig()
    
    property var configsAndThemes: ({
      Powerline: {},
      DefaultSized: {
        OnedarkCircled:{a1:20},
        EverforestRectangled:{a2:30}
      },
    })

    property var configs: generateConfigsIterator()

    function nextConfig() {
        return configs.next().value
    }

    function* generateConfigsIterator() {
        const entries = Object.entries(configsAndThemes);
        let index = 0;

        while (true) {
            const [key, value] = entries[index];
            var len = Object.keys(value).length;

            if (len > 0) {
                for (const [k,val] of Object.entries(value)) {
                    yield { key, val };
                }
            } else {
                yield { key, value}      
            }

            index++;
            if (index >= entries.length) {
              index = 0;
            }
        }
    }


    function getConfig(args = {},specialArgs = {}) {
        const configs = {
            get Powerline() {
                return {
                    inverted: args.side === "left" || (args.side === "center" && args.sideIndex === 1) ? true : false,
                    source:"./decorations/DirectedRectTriangle.qml",
                    popupParentItem: args.side === "left" ||  args.side === "right" ? args.popupParentVariants[2]
                        : args.popupParentVariants[1],

                    sideLength: args.sideLength,
                    gap: -1,
                    popupX: args.side === "left" ? -args.scaleHeightMin/2 :
                        args.side === "right" ? args.scaleHeightMin/2 : args.scaleHeightMin/2,
                    subtractPopupWidth: args.side === "center" ? args.scaleHeightMin : 0,

                    get palette() {
                        return {
                            bgColors: root.colors[0],
                            fgColors: root.colorsGrayscale[0]
                        }
                    },
                    get sideColors() {
                        return {
                            colors: args.side === "center" ? ["transparent","#4c7fbbb3"] :
                                args.sideIndex === args.sideLength-1 ? ["transparent",colorPick("",this.palette.bgColors,args.sideIndex)] : 
                                [colorPick("",this.palette.bgColors,args.sideIndex+1),colorPick("",this.palette.bgColors,args.sideIndex)],
                        }
                    },

                    get props() {
                        return {
                            flickableX: this.inverted ? 0 : (args?.scaleHeightMin/2 || 0),   
                            subtractRectWidth: args?.scaleHeightMin/2 || 0, 
                            defaultWidth: args?.firstChildrenWidth+(args?.scaleHeightMin*0.5),
                            popupHeight: args.side != "center" ? args.scaleHeightMin*4 : args.scaleHeightMin,
                            subtractPopupWidth: this.subtractPopupWidth,
                            popupX: this.popupX,
                            popupParentItem: this.popupParentItem,
                            primaryColor: args.side != "center" ? colorPick("",this.palette.bgColors,args?.sideIndex || 0):
                                "#4c7fbbb3",
                            secondaryColor: args.side != "center" ? this.palette.fgColors[0] : this.palette.fgColors[2],
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
                                radius:args.scaleHeightMin*0.2,
                                "border.width": args.scaleHeightMin*0.07,
                                "border.color": this.palette.fgColors[0],
                                borderColor: this.palette.fgColors[0],
                            },
                            fgSource: "../decorations/GenericDecorItem.qml",
                            fgProps: {
                                // colors: ["transparent",root.colors_grayscale[0][0]],
                                color:this.palette.fgColors[2],
                                radius:args.scaleHeightMin*0.3
                            }
                        }
                    },
                    get sliderProps() {
                        return this.inputProps
                    }
                }
            },
            get DefaultSized() {
                return {
                    source:"./decorations/GenericDecorItem.qml",
                    popupParentItem: args.side === "left" ||  args.side === "right" ? args.popupParentVariants[2]
                        : args.popupParentVariants[1],

                    subtractPopupWidth: 0,
                    addPopupWidth: args.side === "left" ? 0 :
                        args.side === "right" ? args.scaleHeightMin/2: 0,

                    sideLength: args.sideLength,
                    gap: 5,

                    get palette() {
                        return {
                            bgColors: root.colors[1],
                            fgColors: root.colorsGrayscale[1]
                        }
                    },
                    get sideColors() {
                        return {
                            colors: args.side === "center" ? ["transparent","#4c7fbbb3"] :
                                args.sideIndex === args.sideLength-1 ? ["transparent",colorPick("",this.palette.bgColors,args.sideIndex)] : 
                                [colorPick("",this.palette.bgColors,args.sideIndex+1),colorPick("",this.palette.bgColors,args.sideIndex)],
                        }
                    },

                    get props() {
                        return {
                            subtractRectWidth: args?.scaleHeightMin/2 || 0, 
                            defaultWidth: args?.firstChildrenWidth+(args?.scaleHeightMin*0.5),
                            subtractPopupWidth: this.subtractPopupWidth,
                            popupX: this.popupX,
                            popupParentItem: this.popupParentItem,
                            secondaryColor: colorPick("",this.palette.bgColors,args?.sideIndex || 0),
                            primaryColor: this.palette.fgColors[0],
                            bgColors: this.palette.bgColors,
                            fgColors: this.palette.fgColors,
                        }
                    },
                    get mainDecorProps() {
                        return {
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
                                radius:args.scaleHeightMin*0.2,
                                "border.width": args.scaleHeightMin*0.07,
                                "border.color": this.palette.fgColors[0],
                                borderColor: this.palette.fgColors[0],
                            },
                            fgSource: "../decorations/GenericDecorItem.qml",
                            fgProps: {
                                // colors: ["transparent",root.colors_grayscale[0][0]],
                                color:this.palette.fgColors[2],
                                radius:args.scaleHeightMin*0.3
                            }
                        }
                    },
                    get sliderProps() {
                        return this.inputProps
                    }
                }
            },
        }
        return configs[specialArgs.configName]
    }
}
