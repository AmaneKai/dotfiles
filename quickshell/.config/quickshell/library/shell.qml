import QtQuick
import Quickshell
import "notifs" as Notifs
import "osd" as Osd
import "launcher" as Launcher
import "bar" as Bar
import "screenshot" as Screenshot
import "lock" as Lock
import "overview" as Overview

ShellRoot {
    Notifs.Daemon {}
    Osd.Overlay {}
    Bar.Bar {}
    Bar.Panels {}
    Screenshot.Overlay {}
    Lock.Session {}
    Overview.Overlay {}

    Component.onCompleted: {
        Osd.Controller.init();
        Launcher.Controller.init();
        Bar.Controller.init();
        Screenshot.Controller.init();
        Overview.Controller.init();
    }
}
