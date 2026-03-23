import "../"
import "../topBarTabs"
import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import QtQuick.Layouts
import QtSensors 5.15
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Services.Pipewire
import Quickshell.Wayland

PanelWindow {
    implicitWidth: 500
    implicitHeight: 362
    color: "transparent"
    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.exclusiveZone: -1

    anchors {
        top: true
        left: true
        right: true
    }

    Item {
        anchors.fill: parent

        Rectangle {
            id: centerDrawer

            property string activeView: "resources"
            property bool isOpen: false

            width: 900
            height: 350
            y: isOpen ? 0 : -350
            color: Theme.bgMain
            radius: 32
            anchors.horizontalCenter: parent.horizontalCenter

            Item {
                id: tabContainer

                property int tabIndex: 0

                anchors.fill: parent
                anchors.margins: 20
                clip: true
                onTabIndexChanged: {
                    centerDrawer.activeView = ["resources", "music"][tabIndex];
                }

                ResourceTab {
                    width: parent.width
                    height: parent.height
                    x: (0 - tabContainer.tabIndex) * parent.width

                    Behavior on x {
                        NumberAnimation {
                            duration: 280
                            easing.type: Easing.OutCubic
                        }

                    }

                }

                MusicTab {
                    width: parent.width
                    height: parent.height
                    x: (1 - tabContainer.tabIndex) * parent.width

                    Behavior on x {
                        NumberAnimation {
                            duration: 280
                            easing.type: Easing.OutCubic
                        }

                    }

                }


                WheelHandler {
                    acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
                    onWheel: (event) => {
                        if (event.angleDelta.y < 0)
                            tabContainer.tabIndex = Math.min(tabContainer.tabIndex + 1, 1);
                        else
                            tabContainer.tabIndex = Math.max(tabContainer.tabIndex - 1, 0);
                    }
                }

            }

            HoverHandler {
                onHoveredChanged: centerDrawer.isOpen = hovered
            }

            Behavior on y {
                NumberAnimation {
                    duration: 300
                    easing.type: Easing.OutCubic
                }

            }

        }

        Item {
            id: hoverStrip

            width: centerDrawer.width
            height: 36
            anchors.horizontalCenter: parent.horizontalCenter

            HoverHandler {
                onHoveredChanged: centerDrawer.isOpen = hovered
            }

        }

    }

    mask: Region {
        item: centerDrawer.isOpen ? centerDrawer : hoverStrip
    }

}
