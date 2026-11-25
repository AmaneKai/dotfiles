.pragma library
.import "ranking.js" as Ranking

var DRAWER_ALL = 0;
var DRAWER_APPLICATIONS = 1;
var DRAWER_WINDOWS = 2;
var DRAWER_RUN = 3;
var DRAWER_COUNT = 4;
var RECENT_LIMIT = 4;

function header(title, label) {
    return { type: "header", title: title, label: label };
}

function appRow(entry) {
    return {
        type: "row", kind: "app", key: entry.id, payload: entry,
        title: entry.name,
        subtitle: entry.comment || entry.genericName || "Application",
        icon: entry.icon || ""
    };
}

function windowRow(toplevel) {
    var info = toplevel.lastIpcObject || {};
    var windowClass = info["class"] || "";
    var workspace = toplevel.workspace ? toplevel.workspace.name : "?";
    return {
        type: "row", kind: "window", key: toplevel.address, payload: toplevel,
        title: toplevel.title || windowClass || "Window",
        subtitle: "Workspace " + workspace + "  ·  " + windowClass + "  ·  Switch to window",
        icon: ""
    };
}

function runRow(command) {
    return { type: "row", kind: "run", key: command, payload: command, title: command, subtitle: "Run command", icon: "" };
}

function calculationRow(calculation) {
    return {
        type: "row", kind: "calculation", key: calculation.expression, payload: calculation.result,
        title: calculation.result, subtitle: calculation.expression, icon: ""
    };
}

function section(title, label, rows) {
    if (rows.length === 0) return [];
    return [header(title, label)].concat(rows);
}

function byTitle(first, second) {
    return first.title.localeCompare(second.title);
}

function rankedBy(rows, query) {
    var scored = rows.map(function (row) {
        return { row: row, score: Ranking.bestScore(query, [row.title, row.subtitle]) };
    });
    return scored
        .filter(function (entry) { return entry.score !== Ranking.NO_MATCH; })
        .sort(function (a, b) { return b.score - a.score || byTitle(a.row, b.row); })
        .map(function (entry) { return entry.row; });
}

function recentRows(apps, recentIds) {
    var byKey = {};
    apps.forEach(function (row) { byKey[row.key] = row; });
    return recentIds
        .filter(function (id) { return byKey[id] !== undefined; })
        .slice(0, RECENT_LIMIT)
        .map(function (id) { return byKey[id]; });
}

function browse(apps, windows, recentIds, drawer) {
    if (drawer === DRAWER_WINDOWS) return section("Checked out", "Windows", windows);

    var shelves = section("On the shelves", "Applications", apps.slice().sort(byTitle));
    if (drawer === DRAWER_APPLICATIONS) return shelves;
    return section("Recently returned", "Recent", recentRows(apps, recentIds)).concat(shelves);
}

function search(apps, windows, query, drawer) {
    var found = [];
    if (drawer !== DRAWER_WINDOWS) found = found.concat(section("Best match", "Application", rankedBy(apps, query)));
    if (drawer !== DRAWER_APPLICATIONS) found = found.concat(section("Checked out", "Windows", rankedBy(windows, query)));
    return found;
}

function runSection(query) {
    var command = query.trim();
    if (command === "") return [];
    return section("Run", "Command", [runRow(command)]);
}

function build(sources, query, drawer) {
    var apps = (sources.apps || []).filter(function (entry) { return !entry.noDisplay; }).map(appRow);
    var windows = (sources.windows || []).map(windowRow);
    var calculation = sources.calculation ? section("Marginalia", "Calculator", [calculationRow(sources.calculation)]) : [];

    if (drawer === DRAWER_RUN) return runSection(query);
    var listing = query === "" ? browse(apps, windows, sources.recent || [], drawer) : search(apps, windows, query, drawer);
    return calculation.concat(listing);
}

function isSelectable(rows, index) {
    return index >= 0 && index < rows.length && rows[index].type === "row";
}

function firstSelectable(rows) {
    for (var index = 0; index < rows.length; index++) {
        if (isSelectable(rows, index)) return index;
    }
    return -1;
}

function neighbourSelectable(rows, from, step) {
    var index = from + step;
    while (index >= 0 && index < rows.length) {
        if (isSelectable(rows, index)) return index;
        index += step;
    }
    return from;
}
