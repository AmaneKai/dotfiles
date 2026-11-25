const assert = require("assert");
const plain = value => JSON.parse(JSON.stringify(value));
const same = (actual, expected) => assert.deepStrictEqual(plain(actual), plain(expected));
const { loadLibrary } = require("./load-qml-library");

const Ranking = loadLibrary("launcher/ranking.js");
const Rows = loadLibrary("launcher/rows.js", { Ranking });
const Keys = loadLibrary("launcher/keys.js");
const Calculator = loadLibrary("launcher/calculator.js");

const app = (id, name, extra = {}) => ({ id, name, comment: "", genericName: "", icon: "", noDisplay: false, ...extra });
const apps = [app("kitty", "kitty", { comment: "Terminal" }), app("brave", "Brave Origin"), app("hidden", "Hidden", { noDisplay: true }), app("vim", "Vim")];
const windows = [{ address: "0x1", title: "tmux", workspace: { name: "1" }, lastIpcObject: { class: "kitty" } }];
const titles = rows => rows.filter(r => r.type === "row").map(r => r.title);

const tests = {
    "score orders prefix over word prefix over substring over subsequence"() {
        assert(Ranking.score("br", "Brave") > Ranking.score("or", "Brave Origin"));
        assert(Ranking.score("or", "Brave Origin") > Ranking.score("av", "Brave"));
        assert(Ranking.score("av", "Brave") > Ranking.score("bve", "Brave"));
        assert.strictEqual(Ranking.score("zzz", "Brave"), Ranking.NO_MATCH);
    },
    "score tolerates empty and missing input"() {
        assert.strictEqual(Ranking.score("", "anything"), 0);
        assert.strictEqual(Ranking.score("a", undefined), Ranking.NO_MATCH);
        assert.strictEqual(Ranking.initial(null), "?");
    },
    "highlight escapes markup and marks the match"() {
        assert.strictEqual(Ranking.highlight("a<b", "<", "#f00"), "a<font color='#f00'><b>&lt;</b></font>b");
    },
    "spine styling is stable and within bounds"() {
        assert.strictEqual(Ranking.spineColour("Brave"), Ranking.spineColour("brave"));
        const height = Ranking.spineHeight("Alacritty");
        assert(height >= 32 && height <= 38);
        assert.strictEqual(Ranking.spineInk("#ce8563"), "#0a1626");
        assert.strictEqual(Ranking.spineInk("#283a51"), "#f6e7c0");
    },
    "browsing all shows recents then shelves, hiding no-display apps"() {
        const rows = Rows.build({ apps, windows, recent: ["vim"] }, "", Rows.DRAWER_ALL);
        same(rows.filter(r => r.type === "header").map(r => r.title), ["Recently returned", "On the shelves"]);
        same(titles(rows), ["Vim", "Brave Origin", "kitty", "Vim"]);
    },
    "recents ignore ids that no longer exist"() {
        const rows = Rows.build({ apps, windows, recent: ["gone", "vim"] }, "", Rows.DRAWER_ALL);
        same(titles(rows).slice(0, 1), ["Vim"]);
    },
    "searching ranks apps and lists matching windows"() {
        const rows = Rows.build({ apps, windows, recent: [] }, "ki", Rows.DRAWER_ALL);
        same(rows.filter(r => r.type === "header").map(r => r.title), ["Best match", "Checked out"]);
        same(titles(rows)[0], "kitty");
    },
    "the windows drawer lists only windows"() {
        const rows = Rows.build({ apps, windows, recent: [] }, "", Rows.DRAWER_WINDOWS);
        same(titles(rows), ["tmux"]);
    },
    "the run drawer offers the typed command"() {
        same(Rows.build({ apps, windows }, "  htop ", Rows.DRAWER_RUN).filter(r => r.type === "row")[0].payload, "htop");
        same(Rows.build({ apps, windows }, "   ", Rows.DRAWER_RUN), []);
    },
    "a calculation becomes the first section"() {
        const rows = Rows.build({ apps, windows, calculation: { expression: "2*2", result: "4" } }, "2*2", Rows.DRAWER_ALL);
        assert.strictEqual(rows[0].title, "Marginalia");
        assert.strictEqual(rows[1].kind, "calculation");
    },
    "missing sources do not throw"() {
        same(Rows.build({}, "", Rows.DRAWER_ALL), []);
    },
    "selection skips headers and stays put at the ends"() {
        const rows = Rows.build({ apps, windows, recent: ["vim"] }, "", Rows.DRAWER_ALL);
        const first = Rows.firstSelectable(rows);
        assert.strictEqual(rows[first].type, "row");
        assert.strictEqual(Rows.neighbourSelectable(rows, first, -1), first);
        assert(Rows.neighbourSelectable(rows, first, 1) > first);
        assert.strictEqual(Rows.firstSelectable([]), -1);
    },
    "math detection accepts expressions and rejects plain words"() {
        assert(Calculator.looksLikeMath("2560/1.25"));
        assert(Calculator.looksLikeMath("sqrt(16) + 2"));
        assert(!Calculator.looksLikeMath("kitty"));
        assert(!Calculator.looksLikeMath("2048"));
        assert(!Calculator.looksLikeMath("rm -rf /; echo 2"));
        assert(!Calculator.looksLikeMath(""));
        assert(!Calculator.looksLikeMath(null));
    },
    "calculator output is trimmed and failures are dropped"() {
        assert.strictEqual(Calculator.cleanResult("2048\n"), "2048");
        assert.strictEqual(Calculator.cleanResult("Error: unknown function"), "");
        assert.strictEqual(Calculator.cleanResult(""), "");
        assert.strictEqual(Calculator.cleanResult(undefined), "");
    },
    "keys map to intents"() {
        same(Keys.intentOf(0x4a, 0x04000000), { action: "move", step: 1 });
        same(Keys.intentOf(0x4c, 0x04000000), { action: "drawer", step: 1 });
        same(Keys.intentOf(0x01000000, 0), { action: "dismiss" });
        assert.strictEqual(Keys.intentOf(0x41, 0), null);
    },
};

let failed = 0;
for (const [name, run] of Object.entries(tests)) {
    try { run(); console.log("ok    " + name); }
    catch (error) { failed++; console.log("FAIL  " + name + "\n      " + error.message); }
}
process.exit(failed === 0 ? 0 : 1);
