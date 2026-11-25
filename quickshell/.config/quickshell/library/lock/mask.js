.pragma library

const MARK = "·";
const MAXIMUM_MARKS = 32;

function marks(length) {
    if (typeof length !== "number" || length <= 0) return "";
    return MARK.repeat(Math.min(length, MAXIMUM_MARKS));
}

function parseTestSeconds(raw) {
    const seconds = Number(raw);
    if (!raw || isNaN(seconds) || seconds <= 0) return 0;
    return Math.min(seconds, 60);
}
