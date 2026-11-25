.pragma library

const PLAYING = "Playing";

function pickPlayer(players) {
    if (!players || players.length === 0) return null;
    return players.find(player => player.isPlaying) || players[0];
}

function headline(player) {
    if (!player || !player.trackTitle) return "";
    return player.trackArtist ? player.trackTitle + " · " + player.trackArtist : player.trackTitle;
}

function progress(position, length) {
    if (!length || length <= 0 || typeof position !== "number") return 0;
    return Math.max(0, Math.min(1, position / length));
}

function clock(seconds) {
    if (typeof seconds !== "number" || seconds < 0 || isNaN(seconds)) return "0:00";
    const whole = Math.floor(seconds);
    const rest = whole % 60;
    return Math.floor(whole / 60) + ":" + (rest < 10 ? "0" : "") + rest;
}
