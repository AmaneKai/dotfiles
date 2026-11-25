pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import "history.js" as Log

Singleton {
    id: root

    property var entries: []

    function record(notification) {
        entries = Log.push(entries, Log.entryFrom(notification, Date.now()));
        save();
    }

    function remove(index) {
        entries = Log.remove(entries, index);
        save();
    }

    function clear() {
        entries = [];
        save();
    }

    function ago(time) {
        return Log.ago(time, Date.now());
    }

    function save() {
        store.setText(JSON.stringify(entries));
    }

    FileView {
        id: store
        path: Quickshell.statePath("notification-history.json")
        onLoaded: root.entries = Log.parse(store.text())
        onLoadFailed: root.entries = []
    }
}
