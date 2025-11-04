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
        ["#61AFEF",
        "#E06C75",
        "#E5C07B",
        "#C678DD",
        "#E06C75",
        "#61AFEF",],
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
    
    function colorPick(excludeColor,colors,idx,fallbackOffset) {
        const rm = idx % colors.length
        const rm2 = (idx + fallbackOffset) % colors.length
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
        DefaultCircled: {
        },
        DefaultRectangled: {
        
        },
        Highlighted: {
            Onedark:{
                bgColors: root.colors[1],
                fgColors: root.colorsGrayscale[1],
                get moduleAnimProps() {
                    return {
                        duration:100,
                        easingType: 1,
                        easingAmplitude: 1.3,
                        easingPeriod: 1,
                    }
                },
                cavaTextBars: ["⠁","⠁","⠃","⠇","⡇"],
                get common() {
                    return {
                        primaryColor: this.fgColors[1],
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
            get DefaultCircled() {
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
                            popupX: args.side === "left" ? -(this.common.scaleHeightMin)/2 :
                                args.side === "right" ? -(this.common.scaleHeightMin)/2 : 0,
                            popupY: args.side === "center" ? this.common.scaleHeightMin*1.2 : this.common.scaleHeightMin,
                            popupParentItem: args.side === "left" ||  args.side === "right" ? args.popupParentVariants[2]
                                : args.popupParentVariants[1],
                            primaryColor: this.palette.fgColors[1],
                            secondaryColor: colorPick("",this.palette.bgColors,args?.sideIndex || 0,2),
                            bgColors: this.palette.bgColors,
                            fgColors: this.palette.fgColors,
                            cavaTextBars: ["⠁","⠁","⠃","⠇","⡇"],
                            cavaColors: this.palette.bgColors.reverse(),
                            heightScale:1, // bar height scale
                            widthScale:1, // bar width scale
                            scaleHeightMin:this.common.scaleHeightMin, // implicit height for bar container
                            popupAnimProps: args.side != "center" ? null : this.popupAnimProps,
                            moduleAnimProps: this.moduleAnimProps,
                            gap: this.common.scaleHeightMin/10,
                            itemsRowGap: this.common.scaleHeightMin*0.1,

                        }
                    },
                    get popupProps() {
                        return {
                            source: "../decorations/GenericDecorItem.qml",
                            properties: {
                                colors: [this.palette.fgColors[0],colorPick("",this.palette.bgColors,args?.sideIndex-1 || 0,2)],
                                z:-1,
                                radius:this.common.scaleHeightMin*0.5,
                                // topRightRadius:root.scaleHeightMin/2
                                // bottomRightRadius:root.scaleHeightMin/2
                                // topLeftRadius:0
                                // bottomLeftRadius:0
                                // topLeftRadius:this.common.scaleHeightMin/10
                            },
                        }
                    },
                    get barProps() {
                        return {
                            source: "./decorations/GenericDecorItem.qml",
                            properties: {
                                "border.width":this.common.scaleHeightMin*0.1,
                                "border.color":Qt.darker(this.palette.fgColors[0],1.2),
                                color:this.palette.fgColors[0],
                            }
                        }
                    },
                    get mainRectProps() {
                        return {
                            color: this.props.primaryColor,
                            radius:this.common.scaleHeightMin,
                            // "border.width": this.common.scaleHeightMin*0.1,
                            // "border.color": "#4c7fbbb3",
                            // "border.color": colorPick("",this.palette.bgColors,args.sideIndex,2),
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
                            bgColors: root.colors[1],
                            fgColors: root.colorsGrayscale[1],
                        }
                    },

                    get listDelegateProps() {
                        return {
                            workspaceColor1: this.palette.bgColors[1],workspaceColor2: this.palette.bgColors[2],
                            bgColors: this.palette.bgColors,
                            fgColors: this.palette.bgColors,
                            source: "../decorations/GenericDecorItem.qml",
                            properties: {
                                color: this.props.primaryColor,
                                radius:this.common.scaleHeightMin*0.5,
                            }
                        }
                    },
                    get inputProps() {
                        return {
                            source: "../decorations/GenericDecorItem.qml",
                            properties: {
                                colors: [this.palette.fgColors[0]],
                                radius:this.common.scaleHeightMin*0.5,
                            }
                        }
                    },
                    get progressBarProps() {
                        return {
                            bgSource: "../decorations/GenericDecorItem.qml",
                            bgProps: {
                                color: "transparent",
                                radius:this.common.scaleHeightMin*0.2,
                                "border.width": this.common.scaleHeightMin*0.08,
                                "border.color": this.palette.fgColors[0],
                            },
                            borderColor:this.palette.bgColors[1],
                            textColor: this.palette.bgColors[1],
                            fgSource: "../decorations/GenericDecorItem.qml",
                            fgProps: {
                                color:this.palette.fgColors[0],
                                radius:this.common.scaleHeightMin*0.5
                            }
                        }
                    },
                    get sliderProps() {
                        return {
                            source: "../decorations/GenericDecorItem.qml",
                            handleWidthScale:6,
                            properties: {
                                colors: [this.palette.fgColors[0]],
                                radius:this.common.scaleHeightMin*0.5,
                            }
                        }
                    }
                }
            },
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
            get DefaultRectangled() {
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
                            flickableX: this.common?.scaleHeightMin/4 || 0,   
                            subtractContRectWidth: this.common?.scaleHeightMin/2 || 0, 
                            subtractContRectHeight: 0, 
                            addDefaultWidth: this.common.scaleHeightMin/2,

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
                            secondaryColor: colorPick("",this.palette.bgColors,args?.sideIndex || 0,2),
                            bgColors: this.palette.bgColors,
                            fgColors: this.palette.fgColors,
                            cavaTextBars: ["▁", "▂", "▃", "▄", "▅", "▆", "▇", "█"],
                            cavaColors: this.palette.bgColors.reverse(),
                            heightScale:1, // bar height scale
                            widthScale:1, // bar width scale
                            scaleHeightMin:this.common.scaleHeightMin, // implicit height for bar container
                            popupAnimProps: args.side != "center" ? null : this.popupAnimProps,
                            gap: 0,
                            itemsRowGap: this.common.scaleHeightMin*0.1,

                        }
                    },
                    get barProps() {
                        return {
                            source: "./decorations/GenericDecorItem.qml",
                            properties: {
                                // z:1,
                                "border.width":this.common.scaleHeightMin*0.1,
                                "border.color":this.palette.fgColors[1],
                                color:this.palette.fgColors[0],
                            }
                        }
                    },
                    get mainRectProps() {
                        return {
                            color: this.palette.fgColors[0],
                            "border.width":this.common.scaleHeightMin*0.15,
                            "border.color": colorPick("",this.palette.bgColors,args?.sideIndex || 0,2),
                            // radius:this.common.scaleHeightMin*0.5,
                            // "border.width": this.common.scaleHeightMin*0.1,
                            // "border.color": "#4c7fbbb3",
                            // "border.color": colorPick("",this.palette.bgColors,args.sideIndex,2),
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
                            bgColors: root.colors[0],
                            fgColors: root.colorsGrayscale[0],
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
                            textColor: this.palette.bgColors[1],
                            fgSource: "../decorations/GenericDecorItem.qml",
                            fgProps: {
                                color:this.palette.fgColors[2],
                                radius:this.common.scaleHeightMin*0.3
                            }
                        }
                    },
                    get sliderProps() {
                        return {
                            source: "../decorations/RectTriangleItem.qml",
                            handleWidthScale:6,
                            properties: {
                                colors: ["transparent",this.palette.fgColors[0]],
                            }
                        }
                    }
                }
            },
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
            get Highlighted() {
                return {
                    minHeight:45,
                    get common() {
                        return {
                            mainRectSource:"./decorations/HighlightDecorRect.qml",
                            sideLength: args.sideLength,
                            scaleHeightMin: (args?.panelWidth / root.scaleWidth)*this.minHeight || this.minHeight,
                        }
                    },
                    get props() {
                        return {
                            flickableX: this.common?.scaleHeightMin/4 || 0,   
                            subtractContRectWidth: this.common?.scaleHeightMin/2 || 0, 
                            subtractContRectHeight: 0, 
                            addDefaultWidth: this.common.scaleHeightMin/2,
                            popupHeight: args.side != "center" ? this.common.scaleHeightMin*4 : this.common.scaleHeightMin,
                            // subtractPopupWidth:  root.scaleWidth-(root.scaleWidth/6),
                            addPopupWidth:  0,
                            // contentPopupWidth:
                            // popupWidth: root.scaleWidth/6,
                            popupX: 0,
                            popupY: args.side === "center" ? this.common.scaleHeightMin*1.2 : this.common.scaleHeightMin,
                            popupParentItem: args.side === "left" ||  args.side === "right" ? args.popupParentVariants[2]
                                : args.popupParentVariants[1],
                            primaryColor: this.palette.fgColors[2],
                            secondaryColor: this.palette.fgColors[2],
                            // secondaryColor: colorPick("",this.palette.bgColors,args?.sideIndex || 0,2),
                            bgColors: this.palette.bgColors,
                            fgColors: this.palette.fgColors,
                            cavaTextBars: ["⠁","⠁","⠃","⠇","⡇"],
                            cavaColors: this.palette.bgColors.reverse(),
                            heightScale:1, // bar height scale
                            widthScale:1, // bar width scale
                            scaleHeightMin:this.common.scaleHeightMin, // implicit height for bar container
                            popupAnimProps: args.side != "center" ? null : this.popupAnimProps,
                            moduleAnimProps: this.moduleAnimProps,
                            gap: -1,
                            itemsRowGap: this.common.scaleHeightMin*0.1,

                        }
                    },
                    get barProps() {
                        return {
                            source: "./decorations/GenericDecorItem.qml",
                            properties: {
                                // z:1,
                                // "border.width":this.common.scaleHeightMin*0.1,
                                // "border.color":Qt.darker(this.palette.fgColors[0],1.2),
                                color:this.palette.fgColors[0],
                                radius:this.common.scaleHeightMin*0.5,
                            }
                        }
                    },
                    get popupProps() {
                        return {
                            source: "../decorations/HighlightDecorRect.qml",
                            properties: {
                                z:-1,
                                colors: [this.palette.fgColors[0],colorPick("",this.palette.bgColors,args?.sideIndex || 0,2)],
                                highlightBottom: true,
                            },
                        }
                    },
                    get mainRectProps() {
                        return {
                            colors: [this.palette.fgColors[0],colorPick("",this.palette.bgColors,args?.sideIndex || 0,2),this.palette.fgColors[2]],
                            highlightBottom: true,
                            highlightLeft: (args.sideIndex === 0 && args.side != "right") ||
                                (args.sideIndex === args.sideLength-1 && args.side === "right") ? false : true,
                            highlightRight: (args.sideIndex === args.sideLength-1 && args.side != "right") ||
                                (args.sideIndex === 0 && args.side === "right") ? false : true,
                            scaleHeightMin:this.common.scaleHeightMin
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
                            easingType: 6,
                            easingAmplitude: 1.3,
                            easingPeriod: 1,
                        }
                    },
                    get palette() {
                        return {
                            bgColors: root.colors[1],
                            fgColors: root.colorsGrayscale[1],
                        }
                    },

                    get listDelegateProps() {
                        return {
                            workspaceColor1: this.palette.bgColors[1],workspaceColor2: this.palette.fgColors[2],
                            bgColors: this.palette.bgColors,
                            fgColors: [this.palette.fgColors[2]],
                            source: "../decorations/HighlightDecorRect.qml",
                            properties: {
                                colors: [this.palette.fgColors[0],colorPick("",this.palette.bgColors,args?.sideIndex || 0,2)],
                                highlightBottom: true,
                            }
                        }
                    },
                    get inputProps() {
                        return {
                            source: "../decorations/GenericDecorItem.qml",
                            properties: {
                                colors: [this.palette.fgColors[1]],
                                radius: this.common.scaleHeightMin/12
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
                                "border.color": this.palette.fgColors[2],
                            },
                            borderColor:this.palette.fgColors[2],
                            textColor: this.palette.fgColors[2],
                            fgSource: "../decorations/GenericDecorItem.qml",
                            fgProps: {
                                scale:0.96,
                                color:this.palette.fgColors[1],
                                radius:this.common.scaleHeightMin*0.3
                            }
                        }
                    },
                    get sliderProps() {
                        return {
                            source: "../decorations/GenericDecorItem.qml",
                            handleWidthScale:6,
                            properties: {
                                colors: [this.palette.fgColors[2]],
                            }
                        }
                    }
                }
            },
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
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
                            subtractContRectWidth: this.common?.scaleHeightMin/2 || 0, 
                            subtractContRectHeight: 0, 
                            addDefaultWidth: this.common.scaleHeightMin/2,
                            popupHeight: args.side != "center" ? this.common.scaleHeightMin*4 : this.common.scaleHeightMin,
                            subtractPopupWidth: args.side === "center" ? this.common.scaleHeightMin : 0,
                            popupX: args.side === "left" ? -this.common.scaleHeightMin/2 :
                                args.side === "right" ? this.common.scaleHeightMin/2 : this.common.scaleHeightMin/2,
                            popupY: args.side === "center" ? this.common.scaleHeightMin*1.2 : this.common.scaleHeightMin,
                            popupParentItem: args.side === "left" ||  args.side === "right" ? args.popupParentVariants[2]
                                : args.popupParentVariants[1],
                            primaryColor: args.side != "center" ? colorPick("",this.palette.bgColors,args?.sideIndex || 0,2):
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
                    get popupProps() {
                        return {
                            source: "../decorations/HighlightDecorRect.qml",
                            properties: {
                                colors: [this.props.primaryColor,colorPick("",this.palette.bgColors,args?.sideIndex+5 || 0,2)],
                                z:-1,
                                highlightBottom: true,
                                highlightLeft: false,
                                highlightRight: false,
                                scaleHeightMin:this.common.scaleHeightMin
                            },
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
                                args.sideIndex === args.sideLength-1 ? ["transparent",colorPick("",this.palette.bgColors,args.sideIndex,2)] : 
                                [colorPick("",this.palette.bgColors,args.sideIndex+1),colorPick("",this.palette.bgColors,args.sideIndex,2)],
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
                            textColor: this.palette.fgColors[0],
                            fgSource: "../decorations/GenericDecorItem.qml",
                            fgProps: {
                                color:this.palette.fgColors[2],
                                radius:this.common.scaleHeightMin*0.3
                            }
                        }
                    },
                    get sliderProps() {
                        return {
                            source: "../decorations/RectTriangleItem.qml",
                            handleWidthScale:4,

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
