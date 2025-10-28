import QtQuick
import QtQuick.Controls.Basic

pragma ComponentBehavior: Bound

BusyIndicator {
    id: root
    property color color: "red"
    implicitWidth: 50
    implicitHeight: 50
    contentItem: Item {
        width: parent.width
        height: parent.height

        Item {
            id: item
            x: parent.width / 2 - (parent.width/2)
            y: parent.height / 2 - (parent.height/2)
            width: parent.height
            height: parent.height
            opacity: root.running ? 1 : 0

            Behavior on opacity {
                OpacityAnimator {
                    duration: 250
                }
            }

            RotationAnimator {
                target: item
                running: root.visible && root.running
                from: 0
                to: 360
                loops: Animation.Infinite
                duration: 1250
            }

            Repeater {
                id: repeater
                model: 6

                Rectangle {
                    id: delegate
                    x: item.width / 2 - width / 2
                    y: item.height / 2 - height / 2
                    width: item.width/6
                    height: item.height/6
                    radius: item.height/12
                    color: root.color

                    required property int index

                    transform: [
                        Translate {
                            y: -Math.min(item.width, item.height) * 0.5 + 5
                        },
                        Rotation {
                            angle: delegate.index / repeater.count * 360
                            origin.x: item.height/12
                            origin.y: item.height/12
                        }
                    ]
                }
            }
        }
    }
}
