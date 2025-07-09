
import QtQuick 2.11
import QtQuick.Controls 2.4

Column {
    id: clock
    spacing: 0
    width: parent.width / 2
    
    property string fontName: ""

    Label {
        anchors.horizontalCenter: parent.horizontalCenter
        color: root.colors.text_color
        renderType: Text.QtRendering
        text: config.header_text
        font.bold: true
        font.pointSize: config.header_text_font_size
        font.family: fontName
    }

    Label {
        id: timeLabel
        anchors.horizontalCenter: parent.horizontalCenter
        color: root.colors.text_color
        renderType: Text.QtRendering
        font.bold: false
        font.pointSize: config.clock_hour_font_size
        font.family: fontName
        function updateTime() {
            text = new Date().toLocaleTimeString(Qt.locale(config.Locale), config.HourFormat == "long" ? Locale.LongFormat : config.HourFormat !== "" ? config.HourFormat : Locale.ShortFormat)
        }
    }

    Label {
        id: dateLabel
        anchors.horizontalCenter: parent.horizontalCenter
        color: root.colors.text_color
        renderType: Text.QtRendering
        font.bold: false
        font.pointSize: config.clock_date_font_size
        font.family: fontName
        function updateTime() {
            text = new Date().toLocaleDateString(Qt.locale(config.Locale), config.DateFormat == "short" ? Locale.ShortFormat : config.DateFormat !== "" ? config.DateFormat : Locale.LongFormat)
        }
    }

    Timer {
        interval: 1000
        repeat: true
        running: true
        onTriggered: {
            dateLabel.updateTime()
            timeLabel.updateTime()
        }
    }

    Component.onCompleted: {
        dateLabel.updateTime()
        timeLabel.updateTime()
    }
}
