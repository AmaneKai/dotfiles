.pragma library

const NOISE = /\b(Audio Controller|Audio Device|Audio Adapter|Microphone|Speakers?|Headphones?)\b/gi;
const LABEL = /\s*\[([^\]]+)\]\s*$/;
const PROFILE = /\s+(Analog|Digital|Multichannel|Pro)(\s+(Stereo|Surround[\d. ]*|Mono|Output|Input|Audio))?(\s*\(([^)]*)\))?\s*$/i;
const SEPARATOR = " · ";

function collapse(text) {
    return text.replace(/\s+/g, " ").trim();
}

function takeLabel(text) {
    const match = text.match(LABEL);
    return { rest: text.replace(LABEL, ""), label: match ? collapse(match[1]) : "" };
}

function takeProfile(text) {
    const match = text.match(PROFILE);
    if (!match) return { rest: text, profile: "" };
    return { rest: text.replace(PROFILE, ""), profile: collapse(match[5] || match[1]) };
}

function tidy(name) {
    if (typeof name !== "string" || collapse(name) === "") return "";
    const original = collapse(name);
    const labelled = takeLabel(original);
    const profiled = takeProfile(labelled.rest);
    const cleaned = collapse(profiled.rest.replace(NOISE, ""));
    const base = labelled.label || cleaned;
    if (base === "") return original;
    return profiled.profile ? base + SEPARATOR + profiled.profile : base;
}
