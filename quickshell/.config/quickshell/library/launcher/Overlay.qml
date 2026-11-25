import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import "../"
import "../components"
import "rows.js" as Rows

PanelWindow {
    id: window

    readonly property int panelWidth: 760
    readonly property int panelTop: 100
    readonly property int panelMargin: 48
    readonly property int panelPadding: 14
    readonly property int visibleRowsHeight: 392
    readonly property color dimmedBackdrop: "#47000000"

    readonly property var focusedScreen: screenFor(Hyprland.focusedMonitor)
    readonly property string query: search.text
    property int drawer: Math.max(0, Math.min(Rows.DRAWER_COUNT - 1, Controller.pendingDrawer))
    property int selected: -1

    readonly property var rows: Rows.build({
        apps: DesktopEntries.applications.values,
        windows: Hyprland.toplevels.values,
        recent: recents.ids,
        calculation: calculator.calculation
    }, query, drawer)

    function screenFor(monitor) {
        const matches = Quickshell.screens.filter(screen => monitor && screen.name === monitor.name);
        return matches.length > 0 ? matches[0] : Quickshell.screens[0];
    }

    function selectFirst() {
        selected = Rows.firstSelectable(rows);
    }

    function move(step) {
        selected = Rows.neighbourSelectable(rows, selected, step);
    }

    function changeDrawer(step) {
        drawer = (drawer + step + Rows.DRAWER_COUNT) % Rows.DRAWER_COUNT;
    }

    function accept() {
        if (!Rows.isSelectable(rows, selected)) return;
        actions.perform(rows[selected]);
        Controller.close();
    }

    function handle(intent) {
        const reactions = {
            move: () => move(intent.step),
            drawer: () => changeDrawer(intent.step),
            accept: accept,
            dismiss: Controller.close
        };
        const reaction = reactions[intent.action];
        if (reaction) reaction();
    }

    screen: focusedScreen
    color: dimmedBackdrop
    exclusionMode: ExclusionMode.Ignore
    anchors { top: true; bottom: true; left: true; right: true }
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "qs-launcher"
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

    onRowsChanged: selectFirst()

    Component.onCompleted: {
        search.text = Controller.pendingQuery;
        search.focusInput();
        selectFirst();
    }

    MouseArea {
        anchors.fill: parent
        onClicked: Controller.close()
    }

    Frame {
        id: panel
        width: Math.min(window.panelWidth, window.width - 2 * window.panelMargin)
        height: column.implicitHeight + 2 * window.panelPadding
        anchors.horizontalCenter: parent.horizontalCenter
        y: window.panelTop

        MouseArea { anchors.fill: parent }

        Column {
            id: column
            x: window.panelPadding
            y: window.panelPadding
            width: parent.width - 2 * window.panelPadding
            spacing: 8

            DrawerTabs {
                width: parent.width
                current: window.drawer
                onChosen: index => window.drawer = index
            }

            SearchField {
                id: search
                width: parent.width
                onIntended: intent => window.handle(intent)
            }

            ResultList {
                width: parent.width
                rows: window.rows
                query: window.query
                selectedIndex: window.selected
                maximumHeight: window.visibleRowsHeight
                onHovered: index => window.selected = index
                onActivated: index => { window.selected = index; window.accept(); }
            }

            Footer { width: parent.width }
        }
    }

    Calculator { id: calculator; expression: search.text }
    Recents { id: recents }
    Actions { id: actions; recents: recents }
}
