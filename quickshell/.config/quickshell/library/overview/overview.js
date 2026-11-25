.pragma library

const FIRST = 1;
const LAST = 10;

function groups(toplevels) {
    const byWorkspace = {};
    for (let id = FIRST; id <= LAST; id++) byWorkspace[id] = [];
    for (const toplevel of toplevels) {
        const id = toplevel.workspace ? toplevel.workspace.id : 0;
        if (byWorkspace[id]) byWorkspace[id].push({ title: toplevel.title || "Untitled", address: toplevel.address });
    }
    return byWorkspace;
}

function ids() {
    const result = [];
    for (let id = FIRST; id <= LAST; id++) result.push(id);
    return result;
}

function summary(windows) {
    if (windows.length === 0) return "empty";
    return windows.length === 1 ? "1 window" : windows.length + " windows";
}
