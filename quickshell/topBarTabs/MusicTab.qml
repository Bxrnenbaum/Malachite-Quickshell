import "../"
import "../gauges"
import "../other"
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


    Connections {
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
                const secs = Math.round(player.position) % 60;
                const mins = Math.floor(player.position / 60);
                currentPositionText.text = `${mins}:${secs < 10 ? "0" + secs : secs}`;
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

            ColumnLayout {
                Layout.preferredWidth: 200
                Layout.alignment: Qt.AlignHCenter
                Layout.fillHeight: true

                Item {
                    Layout.fillHeight: true
                }

                Image {
                    id: previousIcon

                    Layout.preferredWidth: 61
                    Layout.preferredHeight: 61
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    source: "../images/backward-step.svg"
                    visible: true
                    fillMode: Image.PreserveAspectFit
                    sourceSize.width: width
                    layer.enabled: true

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if (player.position > 3)
                                player.position = 0;
                            else
                                player.previous();
                        }
                    }

                    layer.effect: ColorOverlay {
                        color: Theme.iconMain
                    }

                }

                Item {
                    Layout.fillHeight: true
                }

                ScrollingText {
                    id: titleText

                    Layout.alignment: Qt.AlignBottom | Qt.AlignHCenter
                    maxWidth: 180
                    text: player ? player.trackTitle : "Nothing playing"
                    font.family: Theme.fontFamily
                    font.pixelSize: 18
                    font.weight: Font.Bold
                    color: Theme.widgetText
                }

            }

            //Cover
            Item {
                id: coverWrapper

                Layout.alignment: Qt.AlignVCenter
                width: 201
                height: 201

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

                Rectangle {
                    id: backgroundCircle

                    anchors.centerIn: parent
                    color: Theme.widgetBg

                    width: cover.width + 10
                    height: cover.height + 10
                    radius: width / 2
                    visible: true
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

                MouseArea {
                    anchors.fill: cover
                    onClicked: {
                        if (player.playbackState === MprisPlaybackState.Playing)
                            player.pause();
                        else
                            player.play();
                    }
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

            ColumnLayout {
                Layout.preferredWidth: 200
                Layout.alignment: Qt.AlignHCenter
                Layout.fillHeight: true

                Item {
                    Layout.fillHeight: true
                }

                Image {
                    id: nextIcon

                    Layout.preferredWidth: 61
                    Layout.preferredHeight: 61
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    source: "../images/forward-step.svg"
                    visible: true
                    fillMode: Image.PreserveAspectFit
                    sourceSize.width: width
                    layer.enabled: true

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            player.next();
                        }
                    }

                    layer.effect: ColorOverlay {
                        color: Theme.iconMain
                    }

                }

                Item {
                    Layout.fillHeight: true
                }

                ScrollingText {
                    id: artistText

                    Layout.alignment: Qt.AlignBottom | Qt.AlignHCenter
                    maxWidth: 180
                    text: player ? player.trackArtist : ""
                    font.family: Theme.fontFamily
                    font.pixelSize: 18
                    font.weight: Font.Bold
                    color: Theme.widgetText
                }

            }

        }

        RowLayout {
            spacing: 10

            Text {
                id: currentPositionText

                text: {
                    if (!player)
                        return "";

                    const secs = Math.round(player.position) % 60;
                    const mins = Math.floor(player.position / 60);
                    return `${mins}:${secs < 10 ? "0" + secs : secs}`;
                }
                font.family: Theme.fontFamily
                font.pixelSize: 18
                font.weight: Font.Bold
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
                        duration: mainTimer.interval
                        easing.type: Easing.Linear
                    }

                }

            }

            Text {
                id: maxPositionText

                text: {
                    if (!player)
                        return "";

                    const secs = Math.round(player.length) % 60;
                    const mins = Math.floor(player.position / 60);
                    return `${mins}:${secs < 10 ? "0" + secs : secs}`;
                }
                font.family: Theme.fontFamily
                font.pixelSize: 18
                font.weight: Font.Bold
                color: Theme.widgetText
            }

        }

    }

}
