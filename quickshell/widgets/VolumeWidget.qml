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

Rectangle {
    id: volumeWidget

    property string volumeIconSource: {
        var sink = Pipewire.defaultAudioSink;
        if (!sink || !sink.audio)
            return "../images/volume-zero.svg";

        var vol = Math.round(sink.audio.volume * 100);
        if (vol < 1)
            return "../images/volume-zero.svg";

        if (vol >= 50)
            return "../images/volume-max.svg";

        return "../images/volume-min.svg";
    }

    color: Theme.widgetBg
    radius: 12
    visible: true
    implicitHeight: 24
    implicitWidth: 80

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    Row {
        anchors.centerIn: parent
        spacing: 5

        Image {
            id: volumeIcon

            source: volumeIconSource
            width: 22
            height: 22
            sourceSize.width: width
            visible: true
            fillMode: Image.PreserveAspectFit
            layer.enabled: true

            layer.effect: ColorOverlay {
                color: Theme.iconMain
            }

        }

        Text {
            id: volume

            color: Theme.widgetText
            font.pixelSize: 14
            font.family: Theme.fontFamily
            verticalAlignment: Text.AlignVCenter
            text: {
                var sink = Pipewire.defaultAudioSink;
                if (sink && sink.audio)
                    return Math.round(sink.audio.volume * 100) + "%";

                return "0%";
            }
        }

    }

    MouseArea {
        anchors.fill: parent

        HoverHandler {
            onHoveredChanged: {
                if (hovered)
                    volumeDrawer.isOpen = true;
            }
        }

    }

}
