.pragma library

var NO_MATCH = -1;
var SCORE_PREFIX = 100;
var SCORE_WORD_PREFIX = 80;
var SCORE_SUBSTRING = 60;
var SCORE_SUBSEQUENCE = 30;
var WORD_SEPARATORS = /[\s\-_.]+/;

var SPINE_COLOURS = ["#ce8563", "#283a51", "#dfba88", "#c8cdab", "#68474e", "#a65651"];
var LIGHT_SPINES = ["#ce8563", "#dfba88", "#c8cdab"];
var DARK_INK = "#0a1626";
var LIGHT_INK = "#f6e7c0";
var SPINE_MIN_HEIGHT = 32;
var SPINE_HEIGHT_VARIATION = 7;
var HASH_MULTIPLIER = 31;
var HASH_SHIFT = 3;

function normalise(text) {
    if (text === undefined || text === null) return "";
    return String(text).toLowerCase();
}

function isSubsequence(needle, haystack) {
    var matched = 0;
    for (var i = 0; i < haystack.length && matched < needle.length; i++) {
        if (haystack[i] === needle[matched]) matched++;
    }
    return matched === needle.length;
}

function hasWordPrefix(needle, haystack) {
    return haystack.split(WORD_SEPARATORS).some(function (word) {
        return word.indexOf(needle) === 0;
    });
}

function score(query, text) {
    var needle = normalise(query);
    var haystack = normalise(text);

    if (needle === "") return 0;
    if (haystack.indexOf(needle) === 0) return SCORE_PREFIX;
    if (hasWordPrefix(needle, haystack)) return SCORE_WORD_PREFIX;
    if (haystack.indexOf(needle) >= 0) return SCORE_SUBSTRING;
    if (isSubsequence(needle, haystack)) return SCORE_SUBSEQUENCE;
    return NO_MATCH;
}

function bestScore(query, fields) {
    var scores = fields.map(function (field) { return score(query, field); });
    return Math.max.apply(null, scores);
}

function escapeMarkup(text) {
    return String(text).replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;");
}

function highlight(text, query, colour) {
    var needle = normalise(query);
    var start = normalise(text).indexOf(needle);
    if (needle === "" || start < 0) return escapeMarkup(text);

    var end = start + needle.length;
    return escapeMarkup(text.slice(0, start))
        + "<font color='" + colour + "'><b>" + escapeMarkup(text.slice(start, end)) + "</b></font>"
        + escapeMarkup(text.slice(end));
}

function hashOf(text) {
    var hash = 0;
    for (var i = 0; i < text.length; i++) {
        hash = (hash * HASH_MULTIPLIER + text.charCodeAt(i)) >>> 0;
    }
    return hash;
}

function spineColour(name) {
    return SPINE_COLOURS[hashOf(normalise(name)) % SPINE_COLOURS.length];
}

function spineInk(colour) {
    return LIGHT_SPINES.indexOf(colour) >= 0 ? DARK_INK : LIGHT_INK;
}

function spineHeight(name) {
    return SPINE_MIN_HEIGHT + (hashOf(normalise(name)) >>> HASH_SHIFT) % SPINE_HEIGHT_VARIATION;
}

function initial(name) {
    var trimmed = String(name === undefined || name === null ? "" : name).trim();
    return trimmed === "" ? "?" : trimmed.charAt(0).toUpperCase();
}
