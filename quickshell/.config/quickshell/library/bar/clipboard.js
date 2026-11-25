.pragma library

const IMAGE_MARKER = /^\[\[ binary data/;

function parseEntries(output) {
    const entries = [];
    for (const line of String(output || "").split("\n")) {
        const tab = line.indexOf("\t");
        if (tab <= 0) continue;
        const preview = line.slice(tab + 1).trim();
        entries.push({ id: line.slice(0, tab), preview: preview, isImage: IMAGE_MARKER.test(preview) });
    }
    return entries;
}

function label(entry) {
    return entry.isImage ? "Image" : entry.preview;
}

function filter(entries, query) {
    const needle = String(query || "").trim().toLowerCase();
    if (needle === "") return entries;
    return entries.filter(entry => label(entry).toLowerCase().includes(needle));
}
