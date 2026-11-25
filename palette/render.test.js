const assert = require("assert");
const { validate, renderTheme, renderLua, renderTemplate } = require("./render");

const sample = {
    colours: { bg: "0a1626", text: "f6e7c0" },
    translucent: { panel: "ff243650" },
    fonts: { mono: "JetBrainsMono Nerd Font" }
};

assert.throws(() => validate({ ...sample, colours: { bg: "zzz" } }), /colours\.bg/);
assert.throws(() => validate({ ...sample, translucent: { panel: "243650" } }), /translucent\.panel/);
assert.match(renderTheme(sample), /readonly property color bg:   "#0a1626"/);
assert.match(renderTheme(sample), /readonly property string mono: "JetBrainsMono Nerd Font"/);
assert.match(renderLua(sample), /bg   = "0a1626",/);
assert.strictEqual(renderTemplate("{{bg}} {{bg:bare:f4}} {{bg:rgba:dd}} {{bg:css:0.5}}", sample), "#0a1626 0a1626f4 rgba(0a1626dd) rgba(10,22,38,0.5)");
assert.strictEqual(renderTemplate("{{bg:rgb}}", sample), "10,22,38");
assert.throws(() => renderTemplate("{{nope}}", sample), /unknown colour/);
assert.throws(() => renderTemplate("{{bg:wat}}", sample), /unknown form/);
console.log("palette tests passed");
