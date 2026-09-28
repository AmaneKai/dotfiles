readonly ROFI_THEME="$HOME/.config/rofi/rose-pine.rasi"
readonly FIELD_SEPARATOR="###"

menu_entry() {
    local label=$1 action=$2 value=${3:-}
    printf '%s%s%s%s%s\n' "$label" "$FIELD_SEPARATOR" "$action" "$FIELD_SEPARATOR" "$value"
}

menu_header() {
    menu_entry "$1" header
}

entry_field() {
    local field_number=$1 entry=$2
    awk -F"$FIELD_SEPARATOR" -v n="$field_number" '{print $n}' <<< "$entry"
}

entry_label()  { entry_field 1 "$1"; }
entry_action() { entry_field 2 "$1"; }
entry_value()  { entry_field 3 "$1"; }

choose_menu_entry() {
    local prompt=$1 entries header_rows chosen_index
    entries=$(cat)
    header_rows=$(awk -F"$FIELD_SEPARATOR" '$2 == "header" {printf "%s%d", sep, NR - 1; sep = ","}' <<< "$entries")

    local rofi_arguments=(-dmenu -i -p "$prompt" -theme "$ROFI_THEME" -format i)
    [[ -n "$header_rows" ]] && rofi_arguments+=(-a "$header_rows")

    chosen_index=$(awk -F"$FIELD_SEPARATOR" '{print $1}' <<< "$entries" | rofi "${rofi_arguments[@]}") || return 1
    [[ -n "$chosen_index" ]] || return 1

    local chosen_entry
    chosen_entry=$(sed -n "$((chosen_index + 1))p" <<< "$entries")
    [[ "$(entry_action "$chosen_entry")" != "header" ]] || return 1
    printf '%s\n' "$chosen_entry"
}

set_default_audio_device() {
    local kind=$1 device=$2 streams move_command
    case "$kind" in
        sink)   streams="sink-inputs";    move_command="move-sink-input" ;;
        source) streams="source-outputs"; move_command="move-source-output" ;;
        *)      return 1 ;;
    esac

    pactl "set-default-$kind" "$device"
    pactl list "$streams" short | awk '{print $1}' | while read -r stream; do
        pactl "$move_command" "$stream" "$device" 2>/dev/null || true
    done
}
