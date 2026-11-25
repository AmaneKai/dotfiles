import QtQuick
import Qt.labs.folderlistmodel
import Quickshell
import "../"

Column {
    id: root
    spacing: 6

    readonly property string folder: Quickshell.env("HOME") + "/Pictures/Wallpapers"
    readonly property int columns: 2
    readonly property real cellWidth: (width - spacing * (columns - 1)) / columns

    function choose(path) {
        Controller.close();
        Quickshell.execDetached([Quickshell.env("HOME") + "/.config/hypr/scripts/wallpaper.sh", "set", path]);
    }

    PanelHeading {
        kicker: "Endpapers"
        title: "Wallpapers"
        switchable: false
    }

    Grid {
        columns: root.columns
        spacing: root.spacing

        Repeater {
            model: FolderListModel {
                folder: "file://" + root.folder
                nameFilters: ["*.png", "*.jpg", "*.jpeg"]
                showDirs: false
            }

            Rectangle {
                required property string filePath
                required property string fileName
                width: root.cellWidth
                height: root.cellWidth * 9 / 16
                color: Theme.bar
                border.width: 1
                border.color: hover.hovered ? Theme.accent : Theme.hairlineSoft

                Image {
                    anchors.fill: parent
                    anchors.margins: 2
                    source: "file://" + filePath
                    sourceSize.width: 320
                    fillMode: Image.PreserveAspectCrop
                    asynchronous: true
                }
                HoverHandler { id: hover }
                TapHandler { onTapped: root.choose(filePath) }
            }
        }
    }
}
