import QtQuick
import Quickshell
import Quickshell.Services.Pam

Scope {
    id: root

    property string typed: ""
    property bool checking: false
    property bool failed: false

    signal accepted()

    onTypedChanged: failed = false

    function submit() {
        if (checking || typed === "") return;
        checking = true;
        pam.start();
    }

    function type(text) {
        if (!checking) typed += text;
    }

    function erase() {
        if (!checking) typed = typed.slice(0, -1);
    }

    function clear() {
        if (!checking) typed = "";
    }

    PamContext {
        id: pam
        configDirectory: Quickshell.shellPath("lock/pam")
        config: "password.conf"

        onPamMessage: {
            if (responseRequired) respond(root.typed);
        }

        onCompleted: result => {
            root.checking = false;
            root.typed = "";
            if (result === PamResult.Success) return root.accepted();
            root.failed = true;
        }
    }
}
