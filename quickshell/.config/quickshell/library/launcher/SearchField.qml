import QtQuick
import "../"
import "../components"
import "keys.js" as KeyMap

Item {
    id: root
    property alias text: input.text
    signal intended(var intent)

    readonly property string placeholder: "Search the catalog"

    implicitHeight: 46

    function focusInput() {
        input.forceActiveFocus();
    }

    function forwardKey(event) {
        const intent = KeyMap.intentOf(event.key, event.modifiers);
        if (intent === null) return;
        event.accepted = true;
        root.intended(intent);
    }

    Text {
        id: glyph
        anchors.left: parent.left
        anchors.leftMargin: 6
        anchors.verticalCenter: parent.verticalCenter
        text: String.fromCodePoint(0xF002)
        color: Theme.muted
        font.family: Theme.mono
        font.pixelSize: 16
    }

    TextInput {
        id: input
        anchors.left: glyph.right
        anchors.leftMargin: 12
        anchors.right: escapeKey.left
        anchors.rightMargin: 12
        anchors.verticalCenter: parent.verticalCenter
        color: Theme.text
        selectionColor: Theme.accent
        font.family: Theme.sans
        font.pixelSize: 22
        clip: true
        cursorDelegate: Rectangle { width: 2; color: Theme.accent }
        Keys.onPressed: event => root.forwardKey(event)

        Text {
            visible: input.text === ""
            text: root.placeholder
            color: Theme.muted
            font: input.font
        }
    }

    Keycap {
        id: escapeKey
        anchors.right: parent.right
        anchors.rightMargin: 6
        anchors.verticalCenter: parent.verticalCenter
        keys: "esc"
    }
}
