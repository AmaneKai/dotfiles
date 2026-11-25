#!/usr/bin/env bash
# Emits the current track title as a JSON array of single characters, one
# line of output per change, for eww's deflisten. eww renders one label per
# element, so the title reads as upright vertical text.
#
#   track-title.sh           follow playerctl (live mode)
#   track-title.sh --stack   read titles from stdin, one per line (offline test)

MAX=16   # elements shown including the ellipsis; longer titles are cut at the
         # last space that fits (or hard-cut if none) and end in a vertical ellipsis

stack() {
    jq -R -c --unbuffered --argjson max "$MAX" '
        # the prolonged-sound mark has a vertical form
        def vertical: {"ー":"｜"}[.] // .;

        # browser tabs: drop the unread count "(3) " and the site suffix
        gsub("^\\s*\\([0-9]+\\)\\s*"; "") | gsub("\\s+-\\s+(YouTube|Brave|Brave Origin)$"; "")
        | gsub("^\\s+|\\s+$"; "") | gsub("\\s+"; " ")
        | explode | map([.] | implode)
        | if length > $max then
            # room for $max-1 characters plus the mark; if the next character
            # is a space the window already ends on a word boundary
            .[$max - 1] as $next
            | .[:$max - 1] as $w
            | ($w | indices(" ") | last) as $s
            | (if $next == " " or $s == null or $s == 0 then $w else $w[:$s] end) + ["⋮"]
          else . end
        | map(vertical)
    '
}

if [ "$1" = "--stack" ]; then
    stack
    exit
fi

# Initial empty state, then follow the player. playerctl exits when the last
# player goes away, so restart it and show nothing in between.
echo '[]'
while true; do
    stdbuf -oL playerctl --ignore-player=plasma-browser-integration --follow metadata --format '{{title}}' 2>/dev/null \
        | awk '$0 != prev { prev = $0; print; fflush() }' \
        | stack
    echo '[]'
    sleep 2
done
