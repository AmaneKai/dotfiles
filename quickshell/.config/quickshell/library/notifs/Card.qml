import QtQuick
import Quickshell
import Quickshell.Services.Notifications
import Quickshell.Widgets
import "../"
import "../components"

Frame {
    id: card
    required property var notification

    readonly property bool critical: notification.urgency === NotificationUrgency.Critical

    implicitHeight: content.implicitHeight + 22
    edge: critical ? Theme.accent : Theme.hairline
    ornamented: false

    opacity: 0
    Component.onCompleted: opacity = 1
    Behavior on opacity { NumberAnimation { duration: 140 } }

    Timer {
        running: !card.critical
        interval: card.notification.expireTimeout > 0 ? card.notification.expireTimeout * 1000 : 6000
        onTriggered: card.notification.expire()
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: mouse => {
            if (mouse.button === Qt.LeftButton) {
                for (const a of card.notification.actions)
                    if (a.identifier === "default") { a.invoke(); return; }
            }
            card.notification.dismiss();
        }
    }

    Bookmark {
        visible: card.critical
        x: card.width - width - 14
        y: 0
        z: 2
    }

    Row {
        id: content
        x: 12; y: 11
        width: card.width - 24
        spacing: 10

        IconImage {
            id: icon
            readonly property string iconName: card.notification.appIcon
            readonly property string src: card.notification.image !== "" ? card.notification.image
                : iconName === "" ? ""
                : iconName.startsWith("/") ? iconName
                : Quickshell.iconPath(iconName, true)
            visible: src !== ""
            source: src
            implicitSize: visible ? 24 : 0
            width: implicitSize
            height: implicitSize
        }

        Column {
            width: parent.width - (icon.visible ? icon.width + parent.spacing : 0) - (card.critical ? 18 : 0)
            spacing: 2

            Text {
                width: parent.width
                visible: text !== ""
                text: card.notification.appName.toUpperCase()
                color: Theme.muted
                font.family: Theme.mono
                font.pixelSize: 9
                font.letterSpacing: 1.2
                elide: Text.ElideRight
                maximumLineCount: 1
            }
            Text {
                width: parent.width
                text: card.notification.summary
                color: Theme.text
                font.family: Theme.serif
                font.pixelSize: 14
                font.weight: Font.Bold
                elide: Text.ElideRight
                maximumLineCount: 1
            }
            Text {
                width: parent.width
                visible: text !== ""
                text: card.notification.body
                textFormat: Text.StyledText
                color: Theme.muted
                font.family: Theme.bodySerif
                font.pixelSize: 12
                wrapMode: Text.Wrap
                maximumLineCount: 3
                elide: Text.ElideRight
            }
        }
    }
}
