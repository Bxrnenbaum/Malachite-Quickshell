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
    id: ramGauge

    property real ramPercent: 0

    function parseRamLine(line) {
        var parts = line.trim().split("/");
        if (parts.length !== 2)
            return ;

        var used = parseFloat(parts[0]);
        var total = parseFloat(parts[1]);
        if (total > 0)
            ramPercent = Math.round(used / total * 100);

    }

    width: 260
    height: 280

    Process {
        id: ramPoller

        command: ["sh", "-c", "awk '/^MemTotal/{t=$2} /^MemAvailable/{a=$2} END{print (t-a)\"/\"t}' /proc/meminfo"]

        stdout: StdioCollector {
            onStreamFinished: ramGauge.parseRamLine(text)
        }

    }

    Timer {
        interval: 1500
        repeat: true
        running: true
        triggeredOnStart: true
        onTriggered: ramPoller.running = true
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
                var sweep = (ramGauge.ramPercent / 100) * Math.PI * 2;
                ctx.beginPath();
                ctx.arc(cx, cy, r, -Math.PI / 2, -Math.PI / 2 + sweep);
                ctx.strokeStyle = ramGauge.ramPercent > 80 ? Theme.usageVeryHigh : ramGauge.ramPercent > 50 ? Theme.usageHigh : Theme.usageNormal;
                ctx.lineWidth = 24;
                ctx.lineCap = "round";
                ctx.stroke();
            }

            Connections {
                function onRamPercentChanged() {
                    arc.requestPaint();
                }

                target: ramGauge
            }

            Text {
                anchors.centerIn: parent
                text: ramGauge.ramPercent + "%"
                font.pixelSize: 50
                font.weight: Font.Bold
                color: Theme.widgetText
                font.family: Theme.fontFamily
            }

        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "RAM"
            font.pixelSize: 50
            color: Theme.widgetText
            font.weight: Font.ExtraBold
            font.family: Theme.fontFamily
        }

    }

}
