pragma Singleton
import QtQuick

Item {
    readonly property color bgMain: '#183533'

    readonly property color widgetBg: '#265c58'
    readonly property color widgetText: '#F2E8D5'

    readonly property color iconMain: '#F2E8D5'

    readonly property color sliderHandle: '#D9CDB8'
    readonly property color sliderBg: '#438984'
    readonly property color sliderRailBg: '#265c58'

    readonly property color usageNormal: '#77dda3'
    readonly property color usageHigh: '#e6b137'
    readonly property color usageVeryHigh: '#d93a3a'

    readonly property color musicVisualizer: '#77dda3'
    readonly property color musicProgress: '#77dda3'
    readonly property color musicTabText: '#F2E8D5'

    readonly property string fontFamily: "JetBrains Mono"


    FontLoader { //line 17
        source: Qt.resolvedUrl("Fonts/JetBrainsMono/JetBrainsMono-Regular.ttf")
    }

    FontLoader {
        source: Qt.resolvedUrl("Fonts/JetBrainsMono/JetBrainsMono-Medium.ttf")
    }

    FontLoader {
        source: Qt.resolvedUrl("Fonts/JetBrainsMono/JetBrainsMono-SemiBold.ttf")
    }

    FontLoader {
        source: Qt.resolvedUrl("Fonts/JetBrainsMono/JetBrainsMono-Bold.ttf")
    }

    FontLoader {
        source: Qt.resolvedUrl("Fonts/JetBrainsMono/JetBrainsMono-ExtraBold.ttf")
    }

    FontLoader {
        source: Qt.resolvedUrl("Fonts/JetBrainsMono/JetBrainsMono-Italic.ttf")
    }

    FontLoader {
        source: Qt.resolvedUrl("Fonts/JetBrainsMono/JetBrainsMono-BoldItalic.ttf")
    }

}
