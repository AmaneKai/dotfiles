.pragma library

const VOLUME_GLYPHS = [
    { below: 34, glyph: String.fromCodePoint(0xF057F) },
    { below: 67, glyph: String.fromCodePoint(0xF0580) },
    { below: 101, glyph: String.fromCodePoint(0xF057E) }
];
const MUTED_GLYPH = String.fromCodePoint(0xF075F);
const BATTERY_FULL = String.fromCodePoint(0xF0079);
const BATTERY_LOW = String.fromCodePoint(0xF008E);
const BATTERY_CHARGING = String.fromCodePoint(0xF0084);
const LOW_THRESHOLD = 20;

function percent(fraction) {
    if (typeof fraction !== "number" || isNaN(fraction)) return 0;
    return Math.max(0, Math.min(100, Math.round(fraction * 100)));
}

function volumeGlyph(level, muted) {
    if (muted || level === 0) return MUTED_GLYPH;
    return VOLUME_GLYPHS.find(step => level < step.below).glyph;
}

function batteryGlyph(level, charging) {
    if (charging) return BATTERY_CHARGING;
    return level <= LOW_THRESHOLD ? BATTERY_LOW : BATTERY_FULL;
}

function isLow(level, charging) {
    return !charging && level <= LOW_THRESHOLD;
}
