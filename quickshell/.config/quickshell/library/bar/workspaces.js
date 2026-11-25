.pragma library

const FIRST = 1;
const LAST = 10;
const NUMERALS = ["I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX", "X"];

function numeral(id) {
    if (id < FIRST || id > LAST) return String(id);
    return NUMERALS[id - FIRST];
}

function ids() {
    const result = [];
    for (let id = FIRST; id <= LAST; id++) result.push(id);
    return result;
}

function occupied(toplevels) {
    const found = {};
    for (const toplevel of toplevels) {
        if (toplevel.workspace) found[toplevel.workspace.id] = true;
    }
    return found;
}
