import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import "mask.js" as Mask

Scope {
    id: root

    readonly property real testSeconds: Mask.parseTestSeconds(Quickshell.env("QS_LOCK_TEST_SECONDS"))

    Context {
        id: register
        onAccepted: session.locked = false
    }

    WlSessionLock {
        id: session
        onLockedChanged: if (!locked) register.clear()

        WlSessionLockSurface {
            Surface { anchors.fill: parent; context: register }
        }
    }

    Timer {
        interval: root.testSeconds * 1000
        running: session.locked && root.testSeconds > 0
        onTriggered: session.locked = false
    }

    IpcHandler {
        target: "lock"

        function lock(): void { session.locked = true; }
        function isLocked(): bool { return session.locked; }
    }
}
