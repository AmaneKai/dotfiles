const fs = require("fs");
const path = require("path");
const vm = require("vm");

const DIRECTIVE = /^\s*\.(pragma|import)\b.*$/gm;

function loadLibrary(file, dependencies = {}) {
    const source = fs.readFileSync(path.join(__dirname, "..", file), "utf8").replace(DIRECTIVE, "");
    const sandbox = { ...dependencies };
    vm.runInNewContext(source, sandbox, { filename: file });
    return sandbox;
}

module.exports = { loadLibrary };
