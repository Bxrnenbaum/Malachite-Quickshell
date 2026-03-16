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
import "drawers"
import "widgets"

ShellRoot {
    Variants {
        model: Quickshell.screens

        delegate: Component {
            Item {
                required property var modelData
                property bool hasBattery: false

                Process {
                    running: true
                    command: ["test", "-f", "/sys/class/power_supply/BAT1/capacity"]
                    onExited: (code) => {
                        return hasBattery = (code === 0);
                    }
                }

                //creates the whole visual bar on all sides.
                // other panels are used to add elements on each side and give windows restrictions where they can go.
                PanelWindow {
                    screen: modelData
                    WlrLayershell.layer: WlrLayer.Top
                    WlrLayershell.exclusiveZone: 36
                    color: "transparent"
                    visible: true

                    anchors {
                        top: true
                        left: true
                        bottom: true
                        right: true
                    }

                    Item {
                        id: container

                        anchors.fill: parent

                        Rectangle {
                            anchors.fill: parent
                            color: Theme.bgMain
                            layer.enabled: true

                            layer.effect: MultiEffect {
                                maskSource: mask
                                maskEnabled: true
                                maskInverted: true
                                maskThresholdMin: 0.5
                                maskSpreadAtMin: 1
                            }

                        }

                        Item {
                            id: mask

                            anchors.fill: parent
                            layer.enabled: true
                            visible: false

                            Rectangle {
                                anchors.fill: parent
                                anchors.leftMargin: 12
                                anchors.rightMargin: 12
                                anchors.topMargin: 36
                                anchors.bottomMargin: 12
                                radius: 20
                            }

                        }

                    }

                    mask: Region {
                        item: container
                        intersection: Intersection.Xor
                    }

                }

                // Top Bar
                PanelWindow {
                    screen: modelData
                    implicitHeight: 36
                    color: "transparent"

                    anchors {
                        top: true
                        left: true
                        right: true
                    }

                    // --------- COMPONENTS ---------
                    DateWidget {
                        id: dateWidgetInstance

                        anchors.rightMargin: 12
                        anchors.topMargin: 6

                        anchors {
                            top: parent.top
                            right: parent.right
                        }

                    }

                    BatteryWidget {
                        anchors.leftMargin: 12
                        anchors.topMargin: 6

                        anchors {
                            left: parent.left
                            top: parent.top
                        }

                    }

                    VolumeWidget {
                        id: volumeWidget

                        anchors {
                            right: dateWidgetInstance.left
                            top: parent.top
                            rightMargin: 12
                            topMargin: 6
                        }

                    }

                }

                //left sideBar
                PanelWindow {
                    screen: modelData
                    implicitWidth: 12
                    color: "transparent"

                    anchors {
                        top: true
                        left: true
                        bottom: true
                    }

                }

                //right sideBar
                PanelWindow {
                    screen: modelData
                    implicitWidth: 12
                    color: "transparent"

                    anchors {
                        top: true
                        right: true
                        bottom: true
                    }

                }

                //bottom Bar
                PanelWindow {
                    screen: modelData
                    implicitHeight: 12
                    color: "transparent"

                    anchors {
                        left: true
                        right: true
                        bottom: true
                    }

                }

                //Top bar invisible
                PanelWindow {
                    screen: modelData
                    implicitHeight: 286
                    color: "transparent"
                    WlrLayershell.layer: WlrLayer.Top
                    WlrLayershell.exclusiveZone: -1

                    anchors {
                        top: true
                        right: true
                        left: true
                    }

                    VolumeDrawer {
                        id: volumeDrawer

                        drawerWidth: volumeWidget.implicitWidth
                    }

                    // then somewhere in your top bar:
                    MouseArea {
                        onClicked: centerDrawerInstance.centerDrawer.isOpen = !centerDrawerInstance.centerDrawer.isOpen
                    }

                    mask: Region {
                        item: volumeDrawer.isOpen ? volumeDrawer : null
                    }

                }

                ClipBoardDrawer {
                }

                ControlCenterDrawer {
                    id: centerDrawerInstance
                }

            }

        }

    }

}
