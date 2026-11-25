import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    id: root
    readonly property int limit: 8
    readonly property var ids: store.adapter.ids

    function remember(id) {
        if (typeof id !== "string" || id === "") return;
        const others = ids.filter(existing => existing !== id);
        store.adapter.ids = [id].concat(others).slice(0, limit);
        store.writeAdapter();
    }

    readonly property var store: FileView {
        path: Quickshell.statePath("launcher-recent.json")
        onLoadFailed: writeAdapter()
        adapter: JsonAdapter {
            property list<string> ids: []
        }
    }
}
