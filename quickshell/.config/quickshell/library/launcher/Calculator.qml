import QtQuick
import Quickshell.Io
import "calculator.js" as Math

QtObject {
    id: root
    property string expression: ""
    property string result: ""
    property string evaluating: ""

    readonly property int debounceMs: 120
    readonly property var calculation: result === "" ? null : { expression: expression.trim(), result: result }

    function evaluate() {
        evaluating = expression.trim();
        process.command = ["qalc", "-t", evaluating];
        process.running = true;
    }

    function acceptOutput(output) {
        const stillCurrent = evaluating === expression.trim();
        if (stillCurrent) result = Math.cleanResult(output);
    }

    onExpressionChanged: {
        result = "";
        if (Math.looksLikeMath(expression)) debounce.restart();
        else debounce.stop();
    }

    readonly property var debounce: Timer {
        interval: root.debounceMs
        onTriggered: root.evaluate()
    }

    readonly property var process: Process {
        stdout: StdioCollector {
            onStreamFinished: root.acceptOutput(text)
        }
    }
}
