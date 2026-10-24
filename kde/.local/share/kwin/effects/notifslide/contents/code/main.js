"use strict";

class NotificationSlide {
    constructor() {
        effects.windowAdded.connect(this.slideIn.bind(this));
    }

    slideIn(window) {
        if (!window.notification) return;
        animate({
            window: window,
            duration: 260,
            animations: [
                {
                    type: Effect.Translation,
                    from: { value1: window.width + 40, value2: 0 },
                    to: { value1: 0, value2: 0 },
                    curve: QEasingCurve.OutCubic
                },
                {
                    type: Effect.Opacity,
                    from: 0.0,
                    to: 1.0
                }
            ]
        });
    }
}

new NotificationSlide();
