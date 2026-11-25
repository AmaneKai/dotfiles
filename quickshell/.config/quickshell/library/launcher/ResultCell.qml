import QtQuick

Item {
    id: root
    required property var row
    required property int index
    property int selectedIndex: -1
    property string query: ""
    signal activated(int index)
    signal hovered(int index)

    readonly property bool selected: index === selectedIndex
    readonly property bool isHeader: row.type === "header"
    readonly property bool isCalculation: row.kind === "calculation"

    implicitHeight: loader.item ? loader.item.implicitHeight : 0

    Loader {
        id: loader
        width: parent.width
        sourceComponent: root.isHeader ? headerCell : root.isCalculation ? calculationCell : resultCell
    }

    Component {
        id: headerCell
        SectionHeader { title: root.row.title; label: root.row.label }
    }

    Component {
        id: calculationCell
        CalculationRow {
            row: root.row
            selected: root.selected
            onActivated: root.activated(root.index)
            onHovered: root.hovered(root.index)
        }
    }

    Component {
        id: resultCell
        ResultRow {
            row: root.row
            query: root.query
            selected: root.selected
            onActivated: root.activated(root.index)
            onHovered: root.hovered(root.index)
        }
    }
}
