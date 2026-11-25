local BLURRED_LAYERS = {
    { name = "shell",          namespace = "^qs-",            ignore_alpha = 0.3 },
    { name = "legacy-mako",    namespace = "^notifications$", ignore_alpha = 0.3 },
    { name = "legacy-fuzzel",  namespace = "^launcher$",      ignore_alpha = 0.2, dim_around = true, animation = "popin 94%" },
}

local function blur_layer(layer)
    hl.layer_rule({
        name         = layer.name .. "-blur",
        match        = { namespace = layer.namespace },
        blur         = true,
        ignore_alpha = layer.ignore_alpha,
        dim_around   = layer.dim_around,
        animation    = layer.animation,
    })
end

hl.window_rule({
    name           = "suppress-maximize-events",
    match          = { class = ".*" },
    suppress_event = "maximize",
})

for _, layer in ipairs(BLURRED_LAYERS) do
    blur_layer(layer)
end
