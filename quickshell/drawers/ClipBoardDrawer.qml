import "../"
import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import QtQuick.Layouts
import QtSensors 5.15
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Wayland

// SideDrawer
PanelWindow {
    visible: modelData === Quickshell.screens[0]
    implicitWidth: 312
    color: "transparent"
    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.exclusiveZone: -1 // don't push other windows, just overlay

    anchors {
        top: true
        left: true
        bottom: true
    }

    Item {
        anchors.fill: parent
        enabled: true

        Rectangle {
            id: sideDrawer

            property bool isHovered: false

            x: isHovered ? 0 : -290
            implicitWidth: 300
            implicitHeight: 350
            color: Theme.bgMain
            radius: 12

            anchors {
                top: parent.top
                topMargin: 200
            }

            HoverHandler {
                onHoveredChanged: {
                    sideDrawer.isHovered = hovered;
                    if (hovered)
                        clipProc.running = true;

                }
            }

            // ── Clipboard processes ──────────────────────────────
            Process {
                id: clipProc

                command: ["/usr/bin/cliphist", "list"]
                running: false

                stdout: StdioCollector {
                    onStreamFinished: {
                        clipModel.clear();
                        var lines = this.text.trim().split("\n");
                        for (var i = 0; i < lines.length; i++) {
                            if (lines[i].length > 0)
                                clipModel.append({
                                "entry": lines[i]
                            });

                        }
                    }
                }

            }

            Process {
                id: clipCopy

                property string selected: ""

                running: false
                onSelectedChanged: {
                    command:
                    ["bash", "-c", "printf '%s' '" + selected.replace(/'/g, "'\\''") + "' | /usr/bin/cliphist decode | wl-copy --foreground"];
                }
            }

            ListModel {
                id: clipModel
            }

            // ── UI ───────────────────────────────────────────────
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 4

                Text {
                    text: "Clipboard"
                    color: Theme.widgetText
                    font.pixelSize: 16
                    opacity: 0.6
                    Layout.leftMargin: 4
                    font.family: Theme.fontFamily
                }

                ListView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    model: clipModel
                    clip: true
                    spacing: 2

                    delegate: Rectangle {
                        width: ListView.view.width
                        height: 30
                        radius: 8
                        color: entryHover.containsMouse ? Theme.widgetBg : "transparent"

                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.margins: 8
                            text: {
                                var t = model.entry;
                                var tab = t.indexOf("\t");
                                return tab >= 0 ? t.substring(tab + 1) : t;
                            }
                            color: Theme.widgetText
                            font.pixelSize: 14
                            elide: Text.ElideRight
                            font.family: Theme.fontFamily
                        }

                        MouseArea {
                            id: entryHover

                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                clipCopy.selected = model.entry;
                                clipCopy.running = true;
                            }
                        }

                    }

                }

            }

            Behavior on x {
                NumberAnimation {
                    duration: 200
                    easing.type: Easing.OutCubic
                }

            }

        }

    }

    mask: Region {
        item: sideDrawer
    }

}
