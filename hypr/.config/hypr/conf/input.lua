hl.config({
    input = {
        kb_layout      = "us",
        follow_mouse   = 1,
        sensitivity    = 0,
        accel_profile  = "adaptive",
        natural_scroll = false,
        touchpad = {
            natural_scroll       = true,
            tap_to_click         = true,
            tap_and_drag         = true,
            drag_lock            = 0,
            clickfinger_behavior = true,
            disable_while_typing = true,
        },
    },
})

hl.gesture({
    fingers   = 3,
    direction = "horizontal",
    action    = "workspace",
})
