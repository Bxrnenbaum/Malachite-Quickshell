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
    id: gpuGauge

    property real gpuPercent: 0

    function parseGpuLine(line) {
        var v = parseInt(line.trim());
        if (!isNaN(v))
            gpuPercent = v;

    }

    width: 220
    height: 240

    Process {
        id: gpuPoller

        //This approach only works for NVIDIA Gpus.
        command: ["sh", "-c", "nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits"]

        stdout: StdioCollector {
            onStreamFinished: gpuGauge.parseGpuLine(text)
        }

    }

    Timer {
        interval: 1500
        repeat: true
        running: true
        triggeredOnStart: true
        onTriggered: gpuPoller.running = true
    }

    Column {
        anchors.centerIn: parent
        spacing: 6

        Canvas {
            id: arc

            width: 200
            height: 200
            anchors.horizontalCenter: parent.horizontalCenter
            onPaint: {
                var ctx = getContext("2d");
                ctx.clearRect(0, 0, width, height);
                var cx = width / 2, cy = height / 2, r = 80;
                ctx.beginPath();
                ctx.arc(cx, cy, r, 0, Math.PI * 2);
                ctx.strokeStyle = Theme.widgetBg;
                ctx.lineWidth = 18;
                ctx.stroke();
                var sweep = (gpuGauge.gpuPercent / 100) * Math.PI * 2;
                ctx.beginPath();
                ctx.arc(cx, cy, r, -Math.PI / 2, -Math.PI / 2 + sweep);
                ctx.strokeStyle = gpuGauge.gpuPercent > 80 ? Theme.usageVeryHigh : gpuGauge.gpuPercent > 50 ? Theme.usageHigh : Theme.usageNormal;
                ctx.lineWidth = 18;
                ctx.lineCap = "round";
                ctx.stroke();
            }

            Connections {
                function onGpuPercentChanged() {
                    arc.requestPaint();
                }

                target: gpuGauge
            }

            Text {
                anchors.centerIn: parent
                text: gpuGauge.gpuPercent + "%"
                font.pixelSize: 50
                font.weight: Font.Bold
                color: Theme.widgetText
                font.family: Theme.fontFamily
            }

        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "GPU"
            font.pixelSize: 40
            color: Theme.widgetText
            font.weight: Font.Bold
            font.family: Theme.fontFamily
        }

    }

}
