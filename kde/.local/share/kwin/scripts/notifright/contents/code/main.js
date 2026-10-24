const MARGIN_RIGHT = 4;
const MARGIN_TOP = 4;

function snap(w) {
    if (!w.notification) return;
    const g = w.frameGeometry;
    const area = workspace.clientArea(KWin.MaximizeArea, w);
    const x = area.x + area.width - g.width - MARGIN_RIGHT;
    const y = area.y + MARGIN_TOP;
    if (Math.abs(g.x - x) < 1 && Math.abs(g.y - y) < 1) return;
    w.frameGeometry = { x: x, y: y, width: g.width, height: g.height };
}

function watch(w) {
    if (!w.notification) return;
    snap(w);
    w.frameGeometryChanged.connect(() => snap(w));
}

workspace.windowAdded.connect(watch);
