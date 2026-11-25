import QtQuick
import QtQuick.Shapes
import "../"

Shape {
    id: ribbon
    property color fill: Theme.accent
    width: 14
    height: 26
    ShapePath {
        strokeWidth: 0
        fillColor: ribbon.fill
        startX: 0; startY: 0
        PathLine { x: ribbon.width; y: 0 }
        PathLine { x: ribbon.width; y: ribbon.height }
        PathLine { x: ribbon.width / 2; y: ribbon.height - 7 }
        PathLine { x: 0; y: ribbon.height }
        PathLine { x: 0; y: 0 }
    }
}
