import "../"
import "../gauges"
import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Services.Mpris
import Quickshell.Services.Pipewire
import Quickshell.Wayland

Item {
    property var player: Mpris.players.values.find((p) => {
        return p.playbackState === MprisPlaybackState.Playing;
    }) ?? (Mpris.players.values[0] ?? null)

    anchors.fill: parent

    Connections {
        function onValuesChanged() {
            playerCountText.text = Mpris.players.values.length + " players found";
        }

        target: Mpris.players
    }

    Connections {
        function onTrackTitleChanged() {
            titleText.text = player.trackTitle;
        }

        function onTrackArtistChanged() {
            artistText.text = player.trackArtist;
        }

        function onTrackArtUrlChanged() {
            cover.source = player.trackArtUrl;
        }

        function onPlaybackStateChanged() {
            stateText.text = player.playbackState === MprisPlaybackState.Playing ? "Playing" : "Paused";
        }

        target: player
    }

    Timer {
        id: mainTimer

        interval: 1000
        running: player !== null
        repeat: true
        onTriggered: {
            if (player) {
                currentPositionText.text = `${Math.floor(player.position / 60)}:${Math.round(player.position) % 60 }`;
                progressBar.value = (player.position / player.length);
            }
        }
    }

    Column {
        anchors.centerIn: parent
        spacing: 20

        RowLayout {
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width

            Item {
                Layout.preferredWidth: 200
                Layout.alignment: Qt.AlignVCenter

                Text {
                    id: titleText

                    anchors.centerIn: parent
                    text: player ? player.trackTitle : "Nothing playing"
                    font.family: Theme.fontFamily
                    font.pixelSize: 18
                    font.weight: font.Bold
                    color: Theme.widgetText
                }

            }

            //Cover
            Item {
                id: coverWrapper

                Layout.alignment: Qt.AlignVCenter
                width: 200
                height: 200

                Image {
                    id: cover

                    source: player ? player.trackArtUrl : ""
                    width: parent.width
                    height: parent.height
                    visible: false
                    layer.enabled: true
                }

                Rectangle {
                    id: mask

                    width: cover.width
                    height: cover.height
                    radius: width / 2
                    visible: false
                    layer.enabled: true
                }

                OpacityMask {
                    source: cover
                    maskSource: mask
                    width: cover.width
                    height: cover.height
                }

                Connections {
                    function onPlaybackStateChanged() {
                        if (player.playbackState === MprisPlaybackState.Playing)
                            spinAnimation.resume();
                        else
                            spinAnimation.pause();
                    }

                    target: player
                }

                RotationAnimation on rotation {
                    id: spinAnimation

                    target: coverWrapper
                    from: 0
                    to: 360
                    duration: 7500
                    loops: Animation.Infinite
                }

            }

            Item {
                Layout.preferredWidth: 200
                Layout.alignment: Qt.AlignVCenter

                Text {
                    id: artistText

                    anchors.centerIn: parent
                    text: player ? player.trackArtist : ""
                    font.family: Theme.fontFamily
                    font.pixelSize: 18
                    font.weight: font.Bold
                    color: Theme.widgetText
                }

            }

        }

        RowLayout {
            spacing: 10

            Text {
                id: currentPositionText

                text: player ? `${Math.floor(player.position / 60)}:${Math.round(player.position) % 60 }` : ""
                font.family: Theme.fontFamily
                font.pixelSize: 18
                font.weight: font.Bold
                color: Theme.widgetText
            }

            ProgressBar {
                id: progressBar

                width: 600
                from: 0
                to: 1

                background: Rectangle {
                    anchors.fill: parent
                    radius: 12
                    width: parent.implicitWidth
                    height: parent.implicitHeight
                    color: Theme.widgetBg
                }

                contentItem: Item {
                    implicitHeight: 20

                    Rectangle {
                        width: progressBar.visualPosition * parent.width
                        radius: 12
                        height: progressBar.implicitHeight
                        color: Theme.usageNormal
                    }

                }

                Behavior on value {
                    NumberAnimation {
                        duration: mainTimer.interval // match your timer interval
                        easing.type: Easing.Linear
                    }

                }

            }

            Text {
                id: maxPositionText

                text: `${Math.floor(player.length / 60)}:${Math.round(player.length) % 60}`
                font.family: Theme.fontFamily
                font.pixelSize: 18
                font.weight: font.Bold
                color: Theme.widgetText
            }

        }

    }

}
