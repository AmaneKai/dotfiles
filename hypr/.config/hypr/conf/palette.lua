local palette = {
    bg                = "0a1626",
    bar               = "070f1c",
    surface           = "283a51",
    rule              = "3a4d68",
    text              = "f6e7c0",
    muted             = "a39682",
    heading           = "d6c8aa",
    accent            = "ce8563",
    accent2           = "a65651",
    gold              = "dfba88",
    green             = "c8cdab",
    dim               = "8e7f6b",
    cream2            = "d9c9a0",
    ansiGreen         = "9aa688",
    ansiYellow        = "c4a066",
    ansiBlue          = "5b7fa6",
    ansiBrightBlue    = "7fa3c9",
    ansiMagenta       = "9c6b86",
    ansiBrightMagenta = "bf8aa6",
    ansiCyan          = "6f9c9a",
    ansiBrightCyan    = "98c1bd",
}

local OPAQUE = "ff"

function palette.rgba(colour_name, alpha_hex)
    local hex = palette[colour_name]
    assert(type(hex) == "string", "unknown palette colour: " .. tostring(colour_name))
    return "rgba(" .. hex .. (alpha_hex or OPAQUE) .. ")"
end

return palette
