const fs = require("fs");
const path = require("path");
const { validate, renderTheme, renderLua, renderTemplate } = require("./render");

const ROOT = path.join(__dirname, "..");
const TARGETS = [
    { file: "quickshell/.config/quickshell/library/Theme.qml", render: renderTheme },
    { file: "hypr/.config/hypr/conf/palette.lua", render: renderLua }
];
const TEMPLATES = {
    "kitty.conf": "kitty/.config/kitty/kitty.conf",
    "zathurarc": "zathura/.config/zathura/zathurarc",
    "fuzzel.ini": "fuzzel/.config/fuzzel/fuzzel.ini",
    "mako.config": "mako/.config/mako/config",
    "hyprlock.conf": "hyprlock/.config/hypr/hyprlock.conf",
    "Library.colors": "kdetheme/.local/share/color-schemes/Library.colors",
    "ghostty-theme": "ghosttytheme/.config/ghostty/themes/Library"
};

function templateTargets() {
    const targets = [];
    for (const [template, files] of Object.entries(TEMPLATES)) {
        for (const file of [].concat(files)) {
            targets.push({
                file,
                render: palette => renderTemplate(fs.readFileSync(path.join(__dirname, "templates", template), "utf8"), palette)
            });
        }
    }
    return targets;
}

function build() {
    const palette = validate(JSON.parse(fs.readFileSync(path.join(__dirname, "palette.json"), "utf8")));
    for (const target of [...TARGETS, ...templateTargets()]) {
        fs.writeFileSync(path.join(ROOT, target.file), target.render(palette));
        console.log("wrote " + target.file);
    }
}

build();
