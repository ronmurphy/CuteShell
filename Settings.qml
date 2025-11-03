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
        "#e67e80", //green  
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
    property var currentConfig: configs.next().value
    
    property var configsAndThemes: ({
        Powerline: {
        },
        DefaultSized: {
            OnedarkCircled:{
                get moduleAnimProps() {
                    return {
                        duration:100,
                        easingType: 30,
                        easingAmplitude: 1.3,
                        easingPeriod: 1,
                    }
                },
                cavaTextBars: ["⠁","⠁","⠃","⠇","⡇"],
                get palette() {
                    return {
                        bgColors: root.colors[1],
                        fgColors: root.colorsGrayscale[1]
                    }
                },
            },
        },
        Highlighted: {
            Onedark:{
                get moduleAnimProps() {
                    return {
                        duration:100,
                        easingType: 30,
                        easingAmplitude: 1.3,
                        easingPeriod: 1,
                    }
                },
                cavaTextBars: ["⠁","⠁","⠃","⠇","⡇"],
                get palette() {
                    return {
                        bgColors: root.colors[1],
                        fgColors: root.colorsGrayscale[1]
                    }
                },
            }
        }
    })

    property var configs: generateConfigsIterator()

    function nextConfig() {
        currentConfig = configs.next().value
    }

    function * generateConfigsIterator() {
        const entries = Object.entries(configsAndThemes);
        let index = 0;

        while (true) {
            const [key, value] = entries[index];
            var len = Object.keys(value).length;

            if (len > 0) {
                for (const [k,val] of Object.entries(value)) {
                    yield { key, val };
                }
            } else yield { key, value }

            index++;
            if (index >= entries.length) index = 0
        }
    }

    function getConfig(args = {},specialArgs = {}) {
        const configs = {
            get DefaultSized() {
                return {
                    minHeight:50,
                    get common() {
                        return {
                            mainRectSource:"./decorations/GenericDecorItem.qml",
                            sideLength: args.sideLength,
                            scaleHeightMin: (args?.panelWidth / root.scaleWidth)*this.minHeight || this.minHeight,
                        }
                    },
                    get props() {
                        return {
                            flickableX: 0,   
                            subtractContRectWidth: 0, 
                            subtractContRectHeight: this.common.scaleHeightMin*0.2, 
                            addDefaultWidth: 0,
                            popupHeight: args.side != "center" ? this.common.scaleHeightMin*4 : this.common.scaleHeightMin,
                            // subtractPopupWidth:  root.scaleWidth-(root.scaleWidth/6),
                            addPopupWidth:  this.common.scaleHeightMin,
                            // contentPopupWidth:
                            // popupWidth: root.scaleWidth/6,
                            popupX: args.side === "left" ? -(this.common.scaleHeightMin)/2 :
                                args.side === "right" ? -(this.common.scaleHeightMin)/2 : 0,
                            popupY: args.side === "center" ? this.common.scaleHeightMin*1.2 : this.common.scaleHeightMin,
                            popupParentItem: args.side === "left" ||  args.side === "right" ? args.popupParentVariants[2]
                                : args.popupParentVariants[1],
                            primaryColor: this.palette.fgColors[1],
                            secondaryColor: colorPick("",this.palette.bgColors,args?.sideIndex || 0),
                            bgColors: this.palette.bgColors,
                            fgColors: this.palette.fgColors,
                            cavaTextBars: specialArgs.themeArgs.cavaTextBars,
                            cavaColors: this.palette.bgColors.reverse(),
                            moduleAnimProps: specialArgs.themeArgs.moduleAnimProps,
                            heightScale:1, // bar height scale
                            widthScale:1, // bar width scale
                            scaleHeightMin:this.common.scaleHeightMin, // implicit height for bar container
                            popupAnimProps: args.side != "center" ? null : this.popupAnimProps,
                            gap: this.common.scaleHeightMin/10,
                            itemsRowGap: this.common.scaleHeightMin*0.1,

                        }
                    },
                    get barProps() {
                        return {
                            source: "./decorations/GenericDecorItem.qml",
                            properties: {
                                // z:1,
                                "border.width":this.common.scaleHeightMin*0.1,
                                "border.color":Qt.darker(this.palette.fgColors[0],1.2),
                                color:this.palette.fgColors[0],
                                radius:this.common.scaleHeightMin*0.5,
                            }
                        }
                    },
                    get mainRectProps() {
                        return {
                            color: this.props.primaryColor,
                            radius:this.common.scaleHeightMin*0.5,
                            // "border.width": this.common.scaleHeightMin*0.1,
                            // "border.color": "#4c7fbbb3",
                            // "border.color": colorPick("",this.palette.bgColors,args.sideIndex),
                        }
                    },
                    get popupAnimProps() {
                        return {
                            duration: 150,
                            easingType: 30,
                            easingAmplitude: 1.3,
                            easingPeriod: 1,
                        }
                    },
                    get moduleAnimProps() {
                        return {
                            duration: 150,
                            easingType: 1,
                            easingAmplitude: 1.3,
                            easingPeriod: 1,
                        }
                    },
                    get palette() {
                        return {
                            bgColors: specialArgs.themeArgs.palette.bgColors,
                            fgColors: specialArgs.themeArgs.palette.fgColors
                        }
                    },

                    get listDelegateProps() {
                        return {
                            workspaceColor1: this.palette.bgColors[1],workspaceColor2: this.palette.bgColors[5],
                            bgColors: this.palette.bgColors,
                            fgColors: this.palette.fgColors,
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
                                radius:this.common.scaleHeightMin*0.2,
                                "border.width": this.common.scaleHeightMin*0.07,
                                "border.color": this.palette.bgColors[1],
                            },
                            borderColor:this.palette.bgColors[1],
                            borderColor:this.palette.bgColors[1],
                            fgSource: "../decorations/GenericDecorItem.qml",
                            fgProps: {
                                color:this.palette.fgColors[2],
                                radius:this.common.scaleHeightMin*0.3
                            }
                        }
                    },
                    get sliderProps() {
                        return this.inputProps
                    }
                }
            },
/////////////////////////////////////////////////////////////
            get Highlighted() {
                return {
                    minHeight:50,
                    get common() {
                        return {
                            mainRectSource:"./decorations/GenericDecorItem.qml",
                            sideLength: args.sideLength,
                            scaleHeightMin: (args?.panelWidth / root.scaleWidth)*this.minHeight || this.minHeight,
                        }
                    },
                    get props() {
                        return {
                            flickableX: 0,   
                            subtractContRectWidth: 0, 
                            subtractContRectHeight: this.common.scaleHeightMin*0.2, 
                            addDefaultWidth: 0,
                            popupHeight: args.side != "center" ? this.common.scaleHeightMin*4 : this.common.scaleHeightMin,
                            // subtractPopupWidth:  root.scaleWidth-(root.scaleWidth/6),
                            addPopupWidth:  this.common.scaleHeightMin,
                            // contentPopupWidth:
                            // popupWidth: root.scaleWidth/6,
                            popupX: args.side === "left" ? -(this.common.scaleHeightMin)/2 :
                                args.side === "right" ? -(this.common.scaleHeightMin)/2 : 0,
                            popupY: args.side === "center" ? this.common.scaleHeightMin*1.2 : this.common.scaleHeightMin,
                            popupParentItem: args.side === "left" ||  args.side === "right" ? args.popupParentVariants[2]
                                : args.popupParentVariants[1],
                            primaryColor: this.palette.fgColors[1],
                            secondaryColor: colorPick("",this.palette.bgColors,args?.sideIndex || 0),
                            bgColors: this.palette.bgColors,
                            fgColors: this.palette.fgColors,
                            cavaTextBars: specialArgs.themeArgs.cavaTextBars,
                            cavaColors: this.palette.bgColors.reverse(),
                            moduleAnimProps: specialArgs.themeArgs.moduleAnimProps,
                            heightScale:1, // bar height scale
                            widthScale:1, // bar width scale
                            scaleHeightMin:this.common.scaleHeightMin, // implicit height for bar container
                            popupAnimProps: args.side != "center" ? null : this.popupAnimProps,
                            gap: this.common.scaleHeightMin/10,
                            itemsRowGap: this.common.scaleHeightMin*0.1,

                        }
                    },
                    get barProps() {
                        return {
                            source: "./decorations/GenericDecorItem.qml",
                            properties: {
                                // z:1,
                                "border.width":this.common.scaleHeightMin*0.1,
                                "border.color":Qt.darker(this.palette.fgColors[0],1.2),
                                color:this.palette.fgColors[0],
                                radius:this.common.scaleHeightMin*0.5,
                            }
                        }
                    },
                    get mainRectProps() {
                        return {
                            color: this.props.primaryColor,
                            radius:this.common.scaleHeightMin*0.5,
                            // "border.width": this.common.scaleHeightMin*0.1,
                            // "border.color": "#4c7fbbb3",
                            // "border.color": colorPick("",this.palette.bgColors,args.sideIndex),
                        }
                    },
                    get popupAnimProps() {
                        return {
                            duration: 150,
                            easingType: 30,
                            easingAmplitude: 1.3,
                            easingPeriod: 1,
                        }
                    },
                    get moduleAnimProps() {
                        return {
                            duration: 150,
                            easingType: 1,
                            easingAmplitude: 1.3,
                            easingPeriod: 1,
                        }
                    },
                    get palette() {
                        return {
                            bgColors: specialArgs.themeArgs.palette.bgColors,
                            fgColors: specialArgs.themeArgs.palette.fgColors
                        }
                    },

                    get listDelegateProps() {
                        return {
                            workspaceColor1: this.palette.bgColors[1],workspaceColor2: this.palette.bgColors[5],
                            bgColors: this.palette.bgColors,
                            fgColors: this.palette.fgColors,
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
                                radius:this.common.scaleHeightMin*0.2,
                                "border.width": this.common.scaleHeightMin*0.07,
                                "border.color": this.palette.bgColors[1],
                            },
                            borderColor:this.palette.bgColors[1],
                            borderColor:this.palette.bgColors[1],
                            fgSource: "../decorations/GenericDecorItem.qml",
                            fgProps: {
                                color:this.palette.fgColors[2],
                                radius:this.common.scaleHeightMin*0.3
                            }
                        }
                    },
                    get sliderProps() {
                        return this.inputProps
                    }
                }
            },
////////////////////////////////////////////
            get Powerline() {
                return {

                    minHeight:45,
                    get common() {
                        return {
                            inverted: args.side === "left" || (args.side === "center" && args.sideIndex === 1) ? true : false,
                            mainRectSource:"./decorations/DirectedRectTriangle.qml",
                            sideLength: args.sideLength,
                            scaleHeightMin: (args?.panelWidth / root.scaleWidth)*this.minHeight || this.minHeight,
                        }
                    },

                    get props() {
                        return {
                            flickableX: this.common.inverted ? 0 : (this.common.scaleHeightMin/2 || 0),   
                            subtractContRectWidth: this.common.scaleHeightMin/2 || 0, 
                            subtractContRectHeight: 0, 
                            addDefaultWidth: this.common.scaleHeightMin/2,
                            popupHeight: args.side != "center" ? this.common.scaleHeightMin*4 : this.common.scaleHeightMin,
                            subtractPopupWidth: args.side === "center" ? this.common.scaleHeightMin : 0,
                            popupX: args.side === "left" ? -this.common.scaleHeightMin/2 :
                                args.side === "right" ? this.common.scaleHeightMin/2 : this.common.scaleHeightMin/2,
                            popupY: args.side === "center" ? this.common.scaleHeightMin*1.2 : this.common.scaleHeightMin,
                            popupParentItem: args.side === "left" ||  args.side === "right" ? args.popupParentVariants[2]
                                : args.popupParentVariants[1],
                            primaryColor: args.side != "center" ? colorPick("",this.palette.bgColors,args?.sideIndex || 0):
                                "#4c7fbbb3",
                            secondaryColor: args.side != "center" ? this.palette.fgColors[0] : this.palette.fgColors[2],
                            bgColors: this.palette.bgColors,
                            fgColors: this.palette.fgColors,
                            cavaTextBars: ["▁", "▂", "▃", "▄", "▅", "▆", "▇", "█"],
                            cavaColors: this.palette.bgColors.reverse(),
                            moduleAnimProps: this.moduleAnimProps,
                            popupAnimProps: args.side != "center" ? null : this.popupAnimProps,
                            gap: -1,
                            itemsRowGap: this.common.scaleHeightMin*0.1,
                            heightScale:1, // bar height scale
                            widthScale:1, // bar width scale
                            scaleHeightMin:this.common.scaleHeightMin, // implicit height for bar container

                        }
                    },
                    get mainRectProps() {
                        return {
                            inverted: this.common.inverted,
                            colors: this.sideColors.colors,
                        }
                    },
                    get popupAnimProps() {
                        return {
                            duration: 300,
                            easingType: 30,
                            easingAmplitude: 1.3,
                            easingPeriod: 1,
                        }
                    },
                    get moduleAnimProps() {
                        return {
                            duration: 150,
                            easingType: 30,
                            easingAmplitude: 1.3,
                            easingPeriod: 1,
                        }
                    },
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

                    get listDelegateProps() {
                        return {
                            workspaceColor1: this.palette.fgColors[2],workspaceColor2: this.palette.fgColors[0],
                            bgColors: this.palette.bgColors,
                            fgColors: this.palette.fgColors,
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
                                radius:this.common.scaleHeightMin*0.2,
                                "border.width": this.common.scaleHeightMin*0.07,
                                "border.color": this.palette.fgColors[0],
                            },
                            borderColor: this.palette.fgColors[0],
                            fgSource: "../decorations/GenericDecorItem.qml",
                            fgProps: {
                                color:this.palette.fgColors[2],
                                radius:this.common.scaleHeightMin*0.3
                            }
                        }
                    },
                    get sliderProps() {
                        // return this.inputProps
                        return {
                            source: "../decorations/RectTriangleItem.qml",
                            properties: {
                                colors: ["transparent",this.palette.fgColors[0]],
                            }
                        }
                    }
                }
            },
        }
        return configs[specialArgs.configName]
    }
}
