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
import Quickshell.Services.Pipewire
import Quickshell.Wayland

Item {
    property int drawerWidth: 80
    property alias isOpen: volumeDrawer.isOpen

    anchors.fill: parent
    enabled: true

    Rectangle {
        id: volumeDrawer

        property bool isOpen: false
        property var mediaStream: null

        clip: true
        implicitHeight: isOpen ? 150 : 1
        visible: implicitHeight > 1
        y: 33
        implicitWidth: drawerWidth
        color: Theme.bgMain
        topLeftRadius: 0
        topRightRadius: 0
        bottomLeftRadius: 12
        bottomRightRadius: 12

        // Add this inside volumeDrawer, replacing the Timer + findMediaStream function
        Repeater {
            model: Pipewire.nodes

            delegate: Item {
                required property var modelData
                property bool isMatch: modelData.isStream && modelData.audio && modelData.name && (modelData.name.toLowerCase().includes("firefox") || modelData.name.toLowerCase().includes("spotify") || modelData.name.toLowerCase().includes("chromium") || modelData.name.toLowerCase().includes("mpv"))

                onIsMatchChanged: {
                    if (isMatch)
                        volumeDrawer.mediaStream = modelData;
                    else if (volumeDrawer.mediaStream === modelData)
                        volumeDrawer.mediaStream = null;
                }
                Component.onCompleted: {
                    if (isMatch)
                        volumeDrawer.mediaStream = modelData;

                }
                Component.onDestruction: {
                    if (volumeDrawer.mediaStream === modelData)
                        volumeDrawer.mediaStream = null;

                }
            }

        }

        anchors {
            right: parent.right
            rightMargin: 124
        }

        HoverHandler {
            onHoveredChanged: {
                if (!hovered)
                    volumeDrawer.isOpen = false;

            }
        }

        PwObjectTracker {
            objects: [Pipewire.defaultAudioSink, volumeDrawer.mediaStream]
        }

        Row {
            anchors.centerIn: parent
            spacing: 20

            Slider {
                id: mainVolume

                property var sinkAudio: Pipewire.defaultAudioSink ? Pipewire.defaultAudioSink.audio : null

                orientation: Qt.Vertical
                width: 20
                height: volumeDrawer.implicitHeight - 20
                from: 0
                to: 1
                onSinkAudioChanged: {
                    if (!pressed && sinkAudio)
                        value = sinkAudio.volume;

                }
                onMoved: {
                    if (sinkAudio)
                        sinkAudio.volume = value;

                }

                Connections {
                    function onVolumesChanged() {
                        if (!musicVolume.pressed)
                            musicVolume.value = musicVolume.mediaAudio.volume;

                    }

                    target: musicVolume.mediaAudio ?? null
                    enabled: musicVolume.mediaAudio !== null
                }

                background: Rectangle {
                    x: (parent.width - width) / 2
                    y: 0
                    width: 4
                    height: parent.height
                    radius: 2
                    color: Theme.sliderRailBg

                    Rectangle {
                        width: parent.width
                        height: parent.height * mainVolume.value
                        anchors.bottom: parent.bottom
                        radius: 2
                        color: Theme.sliderBg
                    }

                }

                handle: Rectangle {
                    x: (parent.width - width) / 2
                    y: parent.topPadding + parent.visualPosition * (parent.availableHeight - height)
                    width: 16
                    height: 16
                    radius: 8
                    color: Theme.sliderHandle
                }

            }

            Slider {
                id: musicVolume

                property var mediaAudio: volumeDrawer.mediaStream ? volumeDrawer.mediaStream.audio : null

                orientation: Qt.Vertical
                width: 20
                height: volumeDrawer.implicitHeight - 20
                from: 0
                to: 1
                Component.onCompleted: {
                    if (mediaAudio)
                        value = mediaAudio.volume;

                }
                onMediaAudioChanged: {
                    if (!pressed && mediaAudio)
                        value = mediaAudio.volume;

                }
                onMoved: {
                    if (mediaAudio)
                        mediaAudio.volume = value;

                }

                Connections {
                    function onVolumesChanged() {
                        if (!musicVolume.pressed)
                            musicVolume.value = musicVolume.mediaAudio.volume;

                    }

                    target: musicVolume.mediaAudio
                }

                background: Rectangle {
                    x: (parent.width - width) / 2
                    y: 0
                    width: 4
                    height: parent.height
                    radius: 2
                    color: Theme.sliderRailBg

                    Rectangle {
                        width: parent.width
                        height: parent.height * musicVolume.value
                        anchors.bottom: parent.bottom
                        radius: 2
                        color: Theme.sliderBg
                    }

                }

                handle: Rectangle {
                    x: (parent.width - width) / 2
                    y: parent.topPadding + parent.visualPosition * (parent.availableHeight - height)
                    width: 16
                    height: 16
                    radius: 8
                    color: Theme.sliderHandle
                }

            }

        }

        Behavior on implicitHeight {
            NumberAnimation {
                duration: 300
                easing.type: Easing.OutCubic
            }

        }

    }

}
