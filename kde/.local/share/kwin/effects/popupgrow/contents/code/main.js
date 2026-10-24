"use strict";

class PopupSlide {
    constructor() {
        effects.windowAdded.connect(this.slide.bind(this));
    }

    slide(window) {
        if (window.notification) return;
        if (String(window.windowClass).indexOf("plasmashell") === -1) return;
        if (window.desktopWindow || window.dock) return;
        const screenWidth = effects.virtualScreenSize.width;
        const fromLeft = window.x + window.width / 2 < screenWidth / 2;
        const offset = Math.min(window.width * 0.6, 320);
        animate({
            window: window,
            duration: 200,
            animations: [
                {
                    type: Effect.Translation,
                    from: { value1: fromLeft ? -offset : offset, value2: 0 },
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

new PopupSlide();
