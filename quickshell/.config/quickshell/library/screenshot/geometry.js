.pragma library

const MINIMUM_SIDE = 4;

function normalise(from, to) {
    return {
        x: Math.min(from.x, to.x),
        y: Math.min(from.y, to.y),
        width: Math.abs(to.x - from.x),
        height: Math.abs(to.y - from.y)
    };
}

function clamp(rect, bounds) {
    const x = Math.max(0, Math.min(rect.x, bounds.width));
    const y = Math.max(0, Math.min(rect.y, bounds.height));
    return {
        x: x,
        y: y,
        width: Math.max(0, Math.min(rect.x + rect.width, bounds.width) - x),
        height: Math.max(0, Math.min(rect.y + rect.height, bounds.height) - y)
    };
}

function isUsable(rect) {
    return !!rect && rect.width >= MINIMUM_SIDE && rect.height >= MINIMUM_SIDE;
}

function grimGeometry(rect, origin) {
    return Math.round(origin.x + rect.x) + "," + Math.round(origin.y + rect.y)
        + " " + Math.round(rect.width) + "x" + Math.round(rect.height);
}

function label(rect) {
    return Math.round(rect.width) + " × " + Math.round(rect.height);
}
