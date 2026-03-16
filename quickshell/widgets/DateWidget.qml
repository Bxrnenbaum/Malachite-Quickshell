import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Io

import "../"

Rectangle {
    id: dateWidget

    color: Theme.widgetBg
    radius: 12
    visible: true
    implicitHeight: 24
    implicitWidth: 120

    Text {
        id: clock

        anchors.centerIn: parent
        font.pixelSize: 14
        font.family: Theme.fontFamily
        color: Theme.widgetText

        Timer {
            interval: 1000
            running: true
            repeat: true
            triggeredOnStart: true
            onTriggered: dateProcess.running = true
        }

        Process {
            id: dateProcess

            command: ["date", "+%d %b %H:%M"]
            running: false

            stdout: StdioCollector {
                onStreamFinished: clock.text = this.text.trim()
            }

        }

    }

}
