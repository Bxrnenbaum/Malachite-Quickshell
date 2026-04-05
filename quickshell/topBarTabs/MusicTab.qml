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
        return p.identity === "Spotify";
    }) ?? Mpris.players.values.find((p) => {
    return p.playbackState === MprisPlaybackState.Playing;
}) ?? (Mpris.players.values[0] ?? null)

Connections {
    target: Mpris.players
}

Connections {
    function onTrackTitleChanged()
    {
        titleText.text = player.trackTitle;
    }

    function onTrackArtistChanged()
    {
        artistText.text = player.trackArtist;
    }

    function onTrackArtUrlChanged()
    {
        cover.source = player.trackArtUrl;
    }

    function onPlaybackStateChanged()
    {
        stateText.text = player.playbackState === MprisPlaybackState.Playing ? "Playing" : "Paused";
    }

    target: player
}

Timer {
    id: mainTimer

    interval: { 1000 }
    running: { player !== null }
    repeat: { true }
    onTriggered: {
        if (player)
        {
            const secs = Math.round(player.position) % 60;
            const mins = Math.floor(player.position / 60);
            currentPositionText.text = `${mins}:${secs < 10 ? "0" + secs : secs}`;
            progressBar.value = (player.position / player.length);
        }
    }
}

Column {
    anchors.centerIn: parent
    spacing: { 20 }

    RowLayout {
        anchors.horizontalCenter: parent.horizontalCenter
        width: { parent.width }

        ColumnLayout {
            Layout.preferredWidth: { 200 }
            Layout.alignment: { Qt.AlignHCenter }
            Layout.fillHeight: { true }

            Item {
                Layout.fillHeight: { true }
            }

            Item {
                Layout.preferredWidth: { 70 }
                Layout.preferredHeight: { 70 }
                Layout.alignment: { Qt.AlignHCenter | Qt.AlignVCenter }

                Image {
                    id: previousIcon

                    property real size: {
                        61
                    }

                    anchors.centerIn: parent
                    width: { size }
                    height: { size }
                    source: { "../images/backward-step.svg" }
                    visible: { true }
                    fillMode: { Image.PreserveAspectFit }
                    sourceSize.width: { size }
                    layer.enabled: { true }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: { true }
                        onClicked: {
                            if (player.position > 3)
                                player.position = 0;
                            else
                                player.previous();
                            }
                            onContainsMouseChanged: {
                                previousIcon.size = containsMouse ? 70 : 61;
                            }
                        }

                        layer.effect: ColorOverlay {
                            color: { Theme.iconMain }
                        }

                        Behavior on size {
                        NumberAnimation {
                            duration: { 150 }
                            easing.type: { Easing.OutExpo }
                        }
                    }
                }
            }

            Item {
                Layout.fillHeight: { true }
            }

            ScrollingText {
                id: titleText

                Layout.alignment: { Qt.AlignBottom | Qt.AlignHCenter }
                maxWidth: { 180 }
                text: { player ? player.trackTitle : "Nothing playing" }
                font.family: { Theme.fontFamily }
                font.pixelSize: { 18 }
                font.weight: { Font.Bold }
                color: { Theme.widgetText }
            }
        }

        // Cover
        Item {
            id: coverWrapper

            property var cavaBars: {
                []
            }

            Layout.alignment: { Qt.AlignVCenter | Qt.AlignHCenter }
            width: { 201 }
            height: { 201 }

            Process {
                id: cavaProcess

                command: { ["cava", "-p", Qt.resolvedUrl("../cavaConfig").toString().replace("file://", "")] }
                running: { true }

                stdout: SplitParser {
                    onRead: (data) => {
                    const values = data.trim().split(";").filter((v) => {
                    return v !== "";
                }).map(Number);
                if (values.length > 0)
                    coverWrapper.cavaBars = values;
            }
        }
    }

    Connections {
        function onCavaBarsChanged()
        {
            visualizerCanvas.requestPaint();
        }

        target: coverWrapper
    }

    Image {
        id: cover

        source: { player ? player.trackArtUrl : "" }
        width: { parent.width }
        height: { parent.height }
        visible: { false }
        layer.enabled: { true }
    }

    Rectangle {
        id: mask

        width: { cover.width }
        height: { cover.height }
        radius: { width / 2 }
        visible: { false }
        layer.enabled: { true }
    }

    OpacityMask {
        id: coverMask

        source: { cover }
        maskSource: { mask }
        width: { cover.width }
        height: { cover.height }
    }

    Connections {
        function onPlaybackStateChanged()
        {
            if (player.playbackState === MprisPlaybackState.Playing)
                spinAnimation.resume();
            else
                spinAnimation.pause();
            }

            target: player
        }

        MouseArea {
            anchors.fill: cover
            hoverEnabled: { true }
            onClicked: {
                if (player.playbackState === MprisPlaybackState.Playing)
                    player.pause();
                else
                    player.play();
                }
                onContainsMouseChanged: {
                    coverWrapper.scale = containsMouse ? 1.05 : 1;
                }
            }

            Behavior on scale {
            NumberAnimation {
                duration: { 200 }
                easing.type: { Easing.OutCubic }
            }
        }

        Canvas {
            // uncomment the line below to stop cava from rotating
            // rotation: -coverWrapper.rotation

            id: visualizerCanvas

            anchors.centerIn: parent
            width: { 320 }
            height: { 320 }
            onPaint: {
                const ctx = getContext("2d");
                ctx.clearRect(0, 0, width, height);
                const bars = coverWrapper.cavaBars;
                if (!bars || bars.length === 0)
                    return;

                const cx = width / 2;
                const cy = height / 2;
                const innerRadius = 102;
                const maxBarHeight = 30;
                const barCount = bars.length;
                const angleStep = (2 * Math.PI) / barCount;
                const barWidth = (2 * Math.PI * innerRadius / barCount) * 0.6;
                ctx.fillStyle = Theme.musicVisualizer;
                for (let i = 0; i < barCount; i++) {
                    const angle = i * angleStep - Math.PI / 2;
                    const barHeight = (bars[i] / 100) * maxBarHeight;
                    if (barHeight < 1)
                        continue;

                    ctx.save();
                    ctx.translate(cx, cy);
                    ctx.rotate(angle);
                    ctx.fillRect(-barWidth / 2, innerRadius, barWidth, barHeight);
                    ctx.restore();
                }
            }
        }

        RotationAnimation on rotation {
        id: spinAnimation

        target: coverWrapper
        from: { 0 }
        to: { 360 }
        duration: { 7500 }
        loops: { Animation.Infinite }
    }
}

ColumnLayout {
    Layout.preferredWidth: { 200 }
    Layout.alignment: { Qt.AlignHCenter }
    Layout.fillHeight: { true }

    Item {
        Layout.fillHeight: { true }
    }

    Item {
        Layout.preferredWidth: { 70 }
        Layout.preferredHeight: { 70 }
        Layout.alignment: { Qt.AlignHCenter | Qt.AlignVCenter }

        Image {
            id: nextIcon

            property real size: {
                61
            }

            width: { size }
            height: { size }
            anchors.centerIn: parent
            source: { "../images/forward-step.svg" }
            visible: { true }
            fillMode: { Image.PreserveAspectFit }
            smooth: { true }
            sourceSize.width: { size }
            layer.enabled: { true }

            MouseArea {
                hoverEnabled: { true }
                anchors.fill: parent
                onClicked: {
                    player.next();
                }
                onContainsMouseChanged: {
                    nextIcon.size = containsMouse ? 70 : 61;
                }
            }

            layer.effect: ColorOverlay {
                color: { Theme.iconMain }
            }

            Behavior on size {
            NumberAnimation {
                duration: { 150 }
                easing.type: { Easing.OutExpo }
            }
        }
    }
}

Item {
    Layout.fillHeight: { true }
}

ScrollingText {
    id: artistText

    Layout.alignment: { Qt.AlignBottom | Qt.AlignHCenter }
    maxWidth: { 180 }
    text: { player ? player.trackArtist : "" }
    font.family: { Theme.fontFamily }
    font.pixelSize: { 18 }
    font.weight: { Font.Bold }
    color: { Theme.musicTabText }
}
}
}

RowLayout {
    spacing: { 10 }

    Text {
        id: currentPositionText

        text: {
            if (!player)
                return "";

            const secs = Math.round(player.position) % 60;
            const mins = Math.floor(player.position / 60);
            return `${mins}:${secs < 10 ? "0" + secs : secs}`;
        }
        font.family: { Theme.fontFamily }
        font.pixelSize: { 18 }
        font.weight: { Font.Bold }
        color: { Theme.widgetText }
    }

    ProgressBar {
        id: progressBar

        width: { 700 }
        from: { 0 }
        to: { 1 }

        background: Rectangle {
            anchors.fill: parent
            radius: { 12 }
            width: { parent.implicitWidth }
            height: { parent.implicitHeight }
            color: { Theme.widgetBg }
        }

        contentItem: Item {
            implicitHeight: { 20 }

            Rectangle {
                width: { progressBar.visualPosition * parent.width }
                radius: { 12 }
                height: { progressBar.implicitHeight }
                color: { Theme.usageNormal }
            }
        }

        Behavior on value {
        NumberAnimation {
            duration: { mainTimer.interval }
            easing.type: { Easing.Linear }
        }
    }
}

Text {
    id: maxPositionText

    text: {
        if (!player)
            return "";

        const secs = Math.round(player.length) % 60;
        const mins = Math.floor(player.length / 60);
        return `${mins}:${secs < 10 ? "0" + secs : secs}`;
    }
    font.family: { Theme.fontFamily }
    font.pixelSize: { 18 }
    font.weight: { Font.Bold }
    color: { Theme.widgetText }
}
}
}
}