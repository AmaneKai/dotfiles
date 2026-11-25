.pragma library

var KEY_ESCAPE = 0x01000000;
var KEY_TAB = 0x01000001;
var KEY_BACKTAB = 0x01000002;
var KEY_RETURN = 0x01000004;
var KEY_ENTER = 0x01000005;
var KEY_UP = 0x01000013;
var KEY_DOWN = 0x01000015;
var KEY_H = 0x48;
var KEY_J = 0x4a;
var KEY_K = 0x4b;
var KEY_L = 0x4c;
var KEY_N = 0x4e;
var KEY_P = 0x50;
var MODIFIER_CONTROL = 0x04000000;

var PLAIN_KEYS = {};
PLAIN_KEYS[KEY_ESCAPE] = { action: "dismiss" };
PLAIN_KEYS[KEY_RETURN] = { action: "accept" };
PLAIN_KEYS[KEY_ENTER] = { action: "accept" };
PLAIN_KEYS[KEY_DOWN] = { action: "move", step: 1 };
PLAIN_KEYS[KEY_UP] = { action: "move", step: -1 };
PLAIN_KEYS[KEY_TAB] = { action: "drawer", step: 1 };
PLAIN_KEYS[KEY_BACKTAB] = { action: "drawer", step: -1 };

var CONTROL_KEYS = {};
CONTROL_KEYS[KEY_J] = { action: "move", step: 1 };
CONTROL_KEYS[KEY_N] = { action: "move", step: 1 };
CONTROL_KEYS[KEY_K] = { action: "move", step: -1 };
CONTROL_KEYS[KEY_P] = { action: "move", step: -1 };
CONTROL_KEYS[KEY_L] = { action: "drawer", step: 1 };
CONTROL_KEYS[KEY_H] = { action: "drawer", step: -1 };

function intentOf(key, modifiers) {
    var table = (modifiers & MODIFIER_CONTROL) ? CONTROL_KEYS : PLAIN_KEYS;
    return table[key] || null;
}
