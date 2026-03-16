import "../"
import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Io

Rectangle {
    id: batteryWidget

    color: "#265c58"
    radius: 12
    visible: hasBattery
    implicitHeight: 24
    implicitWidth: 60

    Text {
        id: battery

        anchors.centerIn: parent
        font.family: Theme.fontFamily
        font.pixelSize: 14
        color: "#F2E8D5"

        Timer {
            interval: 30000
            running: true
            repeat: true
            triggeredOnStart: true
            onTriggered: batteryProcess.running = true
        }

        Process {
            id: batteryProcess

            command: ["cat", "/sys/class/power_supply/BAT1/capacity"]
            running: true

            stdout: StdioCollector {
                onStreamFinished: battery.text = this.text.trim() + "%"
            }

        }

    }

}
