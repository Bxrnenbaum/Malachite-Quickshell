import QtQuick

Item {
    property alias text: textItem.text
    property alias font: textItem.font
    property alias color: textItem.color
    property int maxWidth: 180
    property int scrollSpeed: 30 // pixels per second

    width: maxWidth
    height: textItem.height
    clip: true
    onVisibleChanged: {
        if (!visible)
            textItem.x = 0;
    }

    Text {
        id: textItem

        function updatePosition() {
            if (textItem.width > maxWidth) {
                scrollAnimation.restart();
            } else {
                scrollAnimation.stop();
                textItem.x = (maxWidth - textItem.width) / 2;
            }
        }

        color: Theme.widgetText
        onWidthChanged: updatePosition()
        Component.onCompleted: updatePosition()
    }

    Text {
        id: textItem2

        text: textItem.text
        font: textItem.font
        color: textItem.color
        x: textItem.x + Math.max(textItem.width, maxWidth) + 20
    }

    NumberAnimation {
        id: scrollAnimation

        target: textItem
        property: "x"
        from: 0
        to: -(Math.max(textItem.width, maxWidth) + 20)
        duration: ((Math.max(textItem.width, maxWidth) + 20) / scrollSpeed) * 1000
        loops: Animation.Infinite
        running: textItem.width > maxWidth
    }

}
