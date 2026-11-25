const HEX_COLOUR = /^[0-9a-f]{6}$/;
const HEX_TRANSLUCENT = /^[0-9a-f]{8}$/;

function assertEntries(group, entries, pattern) {
    for (const [name, value] of Object.entries(entries)) {
        if (!pattern.test(value)) throw new Error(`palette ${group}.${name} is not valid: ${value}`);
    }
}

function validate(palette) {
    assertEntries("colours", palette.colours, HEX_COLOUR);
    assertEntries("translucent", palette.translucent, HEX_TRANSLUCENT);
    return palette;
}

function alignedLines(entries, format) {
    const width = Math.max(...Object.keys(entries).map(name => name.length));
    return Object.entries(entries).map(([name, value]) => format(name, " ".repeat(width - name.length), value));
}

function renderTheme(palette) {
    const colours = alignedLines(palette.colours, (name, pad, hex) => `    readonly property color ${name}:${pad} "#${hex}"`);
    const translucent = alignedLines(palette.translucent, (name, pad, hex) => `    readonly property color ${name}:${pad} "#${hex}"`);
    const fonts = alignedLines(palette.fonts, (name, pad, family) => `    readonly property string ${name}:${pad} "${family}"`);
    return [
        "pragma Singleton",
        "import QtQuick",
        "import Quickshell",
        "",
        "Singleton {",
        ...colours,
        "",
        ...translucent,
        "",
        ...fonts,
        "}",
        ""
    ].join("\n");
}

function renderLua(palette) {
    const colours = alignedLines(palette.colours, (name, pad, hex) => `    ${name}${pad} = "${hex}",`);
    return [
        "local palette = {",
        ...colours,
        "}",
        "",
        'local OPAQUE = "ff"',
        "",
        "function palette.rgba(colour_name, alpha_hex)",
        "    local hex = palette[colour_name]",
        '    assert(type(hex) == "string", "unknown palette colour: " .. tostring(colour_name))',
        '    return "rgba(" .. hex .. (alpha_hex or OPAQUE) .. ")"',
        "end",
        "",
        "return palette",
        ""
    ].join("\n");
}

const TOKEN = /\{\{(\w+)(?::(\w+))?(?::([\w.]+))?\}\}/g;

function channels(hex) {
    return [0, 2, 4].map(offset => parseInt(hex.slice(offset, offset + 2), 16));
}

const FORMS = {
    hash: (hex, alpha = "") => "#" + hex + alpha,
    bare: (hex, alpha = "") => hex + alpha,
    rgba: (hex, alpha = "ff") => `rgba(${hex}${alpha})`,
    rgb: hex => channels(hex).join(","),
    css: (hex, alpha = "1") => `rgba(${channels(hex).join(",")},${alpha})`
};

function renderToken(palette, name, form = "hash", argument) {
    const hex = palette.colours[name];
    if (!hex) throw new Error("template uses unknown colour: " + name);
    if (!FORMS[form]) throw new Error("template uses unknown form: " + form);
    return FORMS[form](hex, argument);
}

function renderTemplate(template, palette) {
    return template.replace(TOKEN, (_, name, form, argument) => renderToken(palette, name, form, argument));
}

module.exports = { validate, renderTheme, renderLua, renderTemplate };
