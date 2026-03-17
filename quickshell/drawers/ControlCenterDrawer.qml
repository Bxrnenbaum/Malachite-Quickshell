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

// CenterDrawer — slides down from the center of the top bar on hover
PanelWindow {
    implicitWidth: 500
    implicitHeight: 336 // 36 (bar strip) + 300 (drawer)
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
            // ── Content goes here ─────────────────────────────────

            id: centerDrawer

            property string activeView: "resources"
            property bool isOpen: false

            width: 900
            height: 300
            y: isOpen ? 0 : -300
            color: Theme.bgMain
            radius: 32
            anchors.horizontalCenter: parent.horizontalCenter

                RowLayout {
                    anchors.fill: parent

                    anchors {
                        topMargin: 20
                        leftMargin: 20
                        rightMargin: 20
                        bottomMargin: 20
                    }

                    StackLayout {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        currentIndex: ["resources", "music", "notes"].indexOf(centerDrawer.activeView)

                        ResourceTab {
                        }

                        MusicTab {
                        }

                    }

                    Column {
                        spacing: 10
                        Layout.preferredWidth: 120

                        Button {
                            implicitHeight: 30
                            implicitWidth: 120
                            highlighted: centerDrawer.activeView === "resources"
                            onClicked: centerDrawer.activeView = "resources"

                            background: Rectangle {
                                radius: 12
                                width: parent.implicitWidth
                                height: parent.implicitHeight
                                color: Theme.widgetBg
                            }

                            contentItem: Text {
                                width: parent.width
                                height: parent.height
                                color: Theme.widgetText
                                text: "Resources"
                                font.family: Theme.fontFamily
                                font.pixelSize: 18
                                font.weight: 650
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }

                        }

                        Button {
                            implicitHeight: 30
                            implicitWidth: 120
                            highlighted: centerDrawer.activeView === "music"
                            onClicked: centerDrawer.activeView = "music"

                            background: Rectangle {
                                radius: 12
                                width: parent.implicitWidth
                                height: parent.implicitHeight
                                color: Theme.widgetBg
                            }

                            contentItem: Text {
                                width: parent.width
                                height: parent.height
                                color: Theme.widgetText
                                text: "Music"
                                font.family: Theme.fontFamily
                                font.pixelSize: 18
                                font.weight: 650
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }

                        }

                        Button {
                            implicitHeight: 30
                            implicitWidth: 120
                            highlighted: centerDrawer.activeView === "Whatever"
                            onClicked: centerDrawer.activeView = "Whatever"

                            background: Rectangle {
                                radius: 12
                                width: parent.implicitWidth
                                height: parent.implicitHeight
                                color: Theme.widgetBg
                            }

                            contentItem: Text {
                                width: parent.width
                                height: parent.height
                                color: Theme.widgetText
                                text: "Whatever"
                                font.family: Theme.fontFamily
                                font.pixelSize: 18
                                font.weight: 650
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }

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
