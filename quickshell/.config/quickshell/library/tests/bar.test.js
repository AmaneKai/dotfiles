const assert = require("assert");
const { loadLibrary } = require("./load-qml-library");

const book = loadLibrary("bar/workspaces.js");
const gauge = loadLibrary("bar/status.js");

assert.strictEqual(book.numeral(4), "IV");
assert.strictEqual(book.numeral(11), "11");
assert.strictEqual(book.ids().length, 10);
assert.strictEqual(JSON.stringify(book.occupied([{ workspace: { id: 3 } }, { workspace: null }])), '{"3":true}');
assert.strictEqual(gauge.percent(NaN), 0);
assert.strictEqual(gauge.percent(1.7), 100);
assert.strictEqual(gauge.volumeGlyph(0, false), gauge.volumeGlyph(50, true));
assert.notStrictEqual(gauge.volumeGlyph(20, false), gauge.volumeGlyph(90, false));
assert.strictEqual(gauge.isLow(10, true), false);
assert.strictEqual(gauge.isLow(10, false), true);
console.log("bar tests passed");

const shelf = loadLibrary("bar/player.js");
const power = loadLibrary("bar/power.js");

assert.strictEqual(shelf.pickPlayer([]), null);
assert.strictEqual(shelf.pickPlayer([{ isPlaying: false, id: 1 }, { isPlaying: true, id: 2 }]).id, 2);
assert.strictEqual(shelf.headline({ trackTitle: "Haru", trackArtist: "Yorushika" }), "Haru · Yorushika");
assert.strictEqual(shelf.headline({ trackTitle: "" }), "");
assert.strictEqual(shelf.progress(30, 120), 0.25);
assert.strictEqual(shelf.progress(5, 0), 0);
assert.strictEqual(shelf.clock(65), "1:05");
assert.strictEqual(shelf.clock(-1), "0:00");
const reboot = power.actions().find(action => action.id === "reboot");
assert.strictEqual(power.needsConfirmation(reboot, ""), true);
assert.strictEqual(power.needsConfirmation(reboot, "reboot"), false);
assert.strictEqual(power.needsConfirmation(power.actions()[0], ""), false);
console.log("player and power tests passed");

const geometry = loadLibrary("screenshot/geometry.js");
const plain = value => JSON.parse(JSON.stringify(value));
assert.deepStrictEqual(plain(geometry.normalise({ x: 50, y: 40 }, { x: 10, y: 90 })), { x: 10, y: 40, width: 40, height: 50 });
assert.deepStrictEqual(plain(geometry.clamp({ x: -5, y: 10, width: 100, height: 500 }, { width: 80, height: 200 })), { x: 0, y: 10, width: 80, height: 190 });
assert.strictEqual(geometry.isUsable({ width: 2, height: 100 }), false);
assert.strictEqual(geometry.isUsable(null), false);
assert.strictEqual(geometry.grimGeometry({ x: 10.4, y: 20, width: 300, height: 200 }, { x: 2048, y: 0 }), "2058,20 300x200");
assert.strictEqual(geometry.label({ width: 300, height: 200 }), "300 × 200");
console.log("screenshot geometry tests passed");

const mask = loadLibrary("lock/mask.js");
assert.strictEqual(mask.marks(0), "");
assert.strictEqual(mask.marks(3), "···");
assert.strictEqual(mask.marks(500).length, 32);
assert.strictEqual(mask.marks(undefined), "");
assert.strictEqual(mask.parseTestSeconds(undefined), 0);
assert.strictEqual(mask.parseTestSeconds("abc"), 0);
assert.strictEqual(mask.parseTestSeconds("5"), 5);
assert.strictEqual(mask.parseTestSeconds("9999"), 60);
console.log("lock mask tests passed");

const names = loadLibrary("bar/names.js");
assert.strictEqual(names.tidy("Ryzen HD Audio Controller Analog Stereo"), "Ryzen HD · Analog");
assert.strictEqual(names.tidy("FIFINE K690 Microphone Analog Stereo"), "FIFINE K690 · Analog");
assert.strictEqual(names.tidy("Renoir/Cezanne HDMI/DP Audio Controller"), "Renoir/Cezanne HDMI/DP");
assert.strictEqual(names.tidy("Renoir/Cezanne HDMI/DP Audio Controller Digital Stereo (HDMI) [VG270 P]"), "VG270 P · HDMI");
assert.strictEqual(names.tidy("Speakers"), "Speakers");
assert.strictEqual(names.tidy(""), "");
assert.strictEqual(names.tidy(undefined), "");
console.log("name tidy tests passed");

const calendar = loadLibrary("bar/calendar.js");
assert.strictEqual(calendar.daysIn(2026, 1), 28);
assert.strictEqual(calendar.daysIn(2028, 1), 29);
assert.strictEqual(calendar.leadingBlanks(2026, 9), 3);
assert.deepStrictEqual(plain(calendar.shift(2026, 11, 1)), { year: 2027, month: 0 });
assert.deepStrictEqual(plain(calendar.shift(2026, 0, -1)), { year: 2025, month: 11 });
const october = calendar.cells(2026, 9, new Date(2026, 9, 29));
assert.strictEqual(october.length, 3 + 31);
assert.strictEqual(october.filter(cell => cell.today).length, 1);
assert.strictEqual(calendar.monthName(-1), "December");

const history = loadLibrary("notifs/history.js");
const now = 10 * 60 * 1000;
assert.strictEqual(history.push([], { summary: "", body: "" }).length, 0);
assert.strictEqual(history.push([{ summary: "old", body: "" }], { summary: "new", body: "" })[0].summary, "new");
assert.strictEqual(Array.from({ length: 60 }).reduce(list => history.push(list, { summary: "x", body: "" }), []).length, 40);
assert.strictEqual(history.remove([1, 2, 3], 1).join(), "1,3");
assert.strictEqual(history.remove([1, 2, 3], 9).length, 3);
assert.strictEqual(history.ago(now - 5000, now), "now");
assert.strictEqual(history.ago(now - 5 * 60 * 1000, now), "5m");
assert.strictEqual(history.ago(now - 3 * 3600 * 1000, now), "3h");
assert.deepStrictEqual(plain(history.parse("not json")), []);
assert.strictEqual(history.entryFrom({ appName: "a", summary: "s" }, 5).body, "");

const controls = loadLibrary("bar/controls.js");
assert.strictEqual(controls.parseBrightness("amdgpu_bl1,backlight,128,50%,255"), 50);
assert.strictEqual(controls.parseBrightness("garbage"), -1);
assert.strictEqual(controls.brightnessCommand(0)[2], "1%");
assert.strictEqual(controls.brightnessCommand(250)[2], "100%");
assert.strictEqual(controls.nightLightCommand(false)[0], "pkill");

const clipboard = loadLibrary("bar/clipboard.js");
const entries = clipboard.parseEntries("12\thello world\n13\t[[ binary data 20 KiB png 100x100 ]]\nbroken\n");
assert.strictEqual(entries.length, 2);
assert.strictEqual(entries[1].isImage, true);
assert.strictEqual(clipboard.filter(entries, "HELLO").length, 1);
assert.strictEqual(clipboard.filter(entries, "").length, 2);
assert.strictEqual(clipboard.label(entries[1]), "Image");

const overview = loadLibrary("overview/overview.js");
const grouped = overview.groups([{ workspace: { id: 2 }, title: "kitty", address: "0x1" }, { workspace: null, title: "x" }, { workspace: { id: 99 }, title: "y" }]);
assert.strictEqual(grouped[2].length, 1);
assert.strictEqual(grouped[1].length, 0);
assert.strictEqual(overview.summary([]), "empty");
assert.strictEqual(overview.summary([1, 2]), "2 windows");
console.log("feature library tests passed");
