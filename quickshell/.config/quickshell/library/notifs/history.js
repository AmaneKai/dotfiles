.pragma library

const LIMIT = 40;

function entryFrom(notification, now) {
    return {
        app: String(notification.appName || ""),
        summary: String(notification.summary || ""),
        body: String(notification.body || ""),
        time: now
    };
}

function push(entries, entry) {
    if (!entry || (entry.summary === "" && entry.body === "")) return entries;
    return [entry].concat(entries).slice(0, LIMIT);
}

function remove(entries, index) {
    if (index < 0 || index >= entries.length) return entries;
    return entries.slice(0, index).concat(entries.slice(index + 1));
}

function ago(time, now) {
    const seconds = Math.max(0, Math.floor((now - time) / 1000));
    if (seconds < 60) return "now";
    if (seconds < 3600) return Math.floor(seconds / 60) + "m";
    if (seconds < 86400) return Math.floor(seconds / 3600) + "h";
    return Math.floor(seconds / 86400) + "d";
}

function parse(text) {
    try {
        const value = JSON.parse(text);
        return Array.isArray(value) ? value.slice(0, LIMIT) : [];
    } catch (error) {
        return [];
    }
}
