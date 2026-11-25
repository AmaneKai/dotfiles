.pragma library

var ALLOWED_CHARACTERS = /^[0-9a-zA-Z_+\-*\/^().,%\s]+$/;
var HAS_DIGIT = /\d/;
var HAS_OPERATION = /[+\-*\/^%(]|sqrt|sin|cos|tan|log|ln/;
var FAILURE_PREFIXES = ["error", "warning"];

function looksLikeMath(text) {
    var expression = String(text === undefined || text === null ? "" : text).trim();
    if (expression === "") return false;
    return ALLOWED_CHARACTERS.test(expression) && HAS_DIGIT.test(expression) && HAS_OPERATION.test(expression);
}

function isFailure(line) {
    var lowered = line.toLowerCase();
    return FAILURE_PREFIXES.some(function (prefix) { return lowered.indexOf(prefix) === 0; });
}

function cleanResult(output) {
    var lines = String(output === undefined || output === null ? "" : output).trim().split("\n");
    var last = lines[lines.length - 1].trim();
    return last === "" || isFailure(last) ? "" : last;
}
