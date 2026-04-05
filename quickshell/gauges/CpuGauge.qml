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
    id: cpuGauge

    property real cpuPercent: 0
    property real _prevUsed: 0
    property real _prevTotal: 0

    function parseCpuLine(line) {
        var parts = line.trim().split("/");
        if (parts.length !== 2)
            return ;

        var used = parseFloat(parts[0]);
        var total = parseFloat(parts[1]);
        var du = used - _prevUsed;
        var dt = total - _prevTotal;
        _prevUsed = used;
        _prevTotal = total;
        if (dt > 0)
            cpuPercent = Math.round(du / dt * 100);

    }

    width: 260
    height: 280

    Process {
        id: cpuPoller

        command: ["sh", "-c", "awk '/^cpu /{u=$2+$4; t=$2+$3+$4+$5; print u\"/\"t}' /proc/stat"]

        stdout: StdioCollector {
            onStreamFinished: cpuGauge.parseCpuLine(text)
        }

    }

    Timer {
        interval: 1500
        repeat: true
        running: true
        triggeredOnStart: true
        onTriggered: cpuPoller.running = true
    }

    Column {
        anchors.centerIn: parent
        spacing: 6

        Canvas {
            id: arc

            width: 240
            height: 240
            anchors.horizontalCenter: parent.horizontalCenter
            onPaint: {
                var ctx = getContext("2d");
                ctx.clearRect(0, 0, width, height);
                var cx = width / 2, cy = height / 2, r = 100;
                ctx.beginPath();
                ctx.arc(cx, cy, r, 0, Math.PI * 2);
                ctx.strokeStyle = Theme.widgetBg;
                ctx.lineWidth = 24;
                ctx.stroke();
                var sweep = (cpuGauge.cpuPercent / 100) * Math.PI * 2;
                ctx.beginPath();
                ctx.arc(cx, cy, r, -Math.PI / 2, -Math.PI / 2 + sweep);
                ctx.strokeStyle = cpuGauge.cpuPercent > 80 ? Theme.usageVeryHigh : cpuGauge.cpuPercent > 50 ? Theme.usageHigh : Theme.usageNormal;
                ctx.lineWidth = 24;
                ctx.lineCap = "round";
                ctx.stroke();
            }

            Connections {
                function onCpuPercentChanged() {
                    arc.requestPaint();
                }

                target: cpuGauge
            }

            Text {
                anchors.centerIn: parent
                text: cpuGauge.cpuPercent + "%"
                font.pixelSize: 50
                font.weight: Font.Bold
                color: Theme.widgetText
                font.family: Theme.fontFamily
                
            }

        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "CPU"
            font.pixelSize: 50
            color: Theme.widgetText
            font.weight: Font.ExtraBold
            font.family: Theme.fontFamily
        }

    }

}
