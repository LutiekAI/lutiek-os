import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15

Window {
    id: appCenter
    visible: true
    width: 900
    height: 650
    title: "Lutiek App Center"
    color: "#F0F0F0"

    // Top header bar
    Rectangle {
        id: headerBar
        width: parent.width
        height: 60
        color: "#0078D4"
        anchors.top: parent.top

        Row {
            anchors.fill: parent
            anchors.leftMargin: 20
            spacing: 15

            Image {
                source: "image://icon/Lutiek-Logo"
                width: 30
                height: 30
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                text: "App Center"
                color: "#FFFFFF"
                font.pixelSize: 22
                font.bold: true
                anchors.verticalCenter: parent.verticalCenter
            }

            Item { width: 40 }

            // Search bar
            Rectangle {
                width: 300
                height: 36
                color: "#FFFFFF"
                radius: 18
                anchors.verticalCenter: parent.verticalCenter

                Row {
                    anchors.fill: parent
                    anchors.leftMargin: 12
                    spacing: 8

                    Image {
                        source: "image://icon/system-search"
                        width: 18
                        height: 18
                        anchors.verticalCenter: parent.verticalCenter
                        opacity: 0.5
                    }

                    TextInput {
                        id: searchBox
                        width: 250
                        anchors.verticalCenter: parent.verticalCenter
                        placeholderText: "Search apps..."
                        placeholderTextColor: "#999999"
                        font.pixelSize: 14
                    }
                }
            }
        }
    }

    // Category tabs
    Rectangle {
        id: categoryBar
        width: parent.width
        height: 50
        color: "#FFFFFF"
        anchors.top: headerBar.bottom

        ListView {
            id: categories
            anchors.fill: parent
            orientation: ListView.Horizontal

            model: ListModel {
                ListElement { name: "All"; icon: "applications-all" }
                ListElement { name: "Installed"; icon: "emblem-ok" }
                ListElement { name: "Recommended"; icon: "rating" }
                ListElement { name: "Development"; icon: "development" }
                ListElement { name: "Games"; icon: "games" }
                ListElement { name: "Media"; icon: "audio-video" }
                ListElement { name: "Office"; icon: "office" }
                ListElement { name: "Utilities"; icon: "utilities" }
            }

            delegate: Rectangle {
                width: 120
                height: parent.height
                color: categories.currentIndex === index ? "#E5F1FB" : "#FFFFFF"

                Text {
                    text: name
                    font.pixelSize: 14
                    color: categories.currentIndex === index ? "#0078D4" : "#666666"
                    font.bold: categories.currentIndex === index
                    anchors.centerIn: parent
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: categories.currentIndex = index
                }
            }
        }
    }

    // Apps grid
    GridView {
        id: appsGrid
        width: parent.width - 40
        height: parent.height - 140
        anchors.top: categoryBar.bottom
        anchors.topMargin: 15
        anchors.horizontalCenter: parent.horizontalCenter
        cellWidth: 180
        cellHeight: 200
        interactive: true

        model: ListModel {
            ListElement { name: "Firefox"; desc: "Web browser"; icon: "firefox"; size: "78 MB"; installed: false; category: "internet" }
            ListElement { name: "LibreOffice"; desc: "Office suite"; icon: "libreoffice"; size: "250 MB"; installed: true; category: "office" }
            ListElement { name: "VLC"; desc: "Media player"; icon: "vlc"; size: "45 MB"; installed: false; category: "media" }
            ListElement { name: "GIMP"; desc: "Image editor"; icon: "gimp"; size: "120 MB"; installed: false; category: "graphics" }
            ListElement { name: "VS Code"; desc: "Code editor"; icon: "code"; size: "95 MB"; installed: false; category: "development" }
            ListElement { name: "Blender"; desc: "3D creation"; icon: "blender"; size: "200 MB"; installed: false; category: "graphics" }
            ListElement { name: "Steam"; desc: "Gaming platform"; icon: "steam"; size: "150 MB"; installed: false; category: "games" }
            ListElement { name: "Discord"; desc: "Chat app"; icon: "discord"; size: "80 MB"; installed: false; category: "communication" }
            ListElement { name: "Thunderbird"; desc: "Email client"; icon: "thunderbird"; size: "65 MB"; installed: false; category: "internet" }
            ListElement { name: "Audacity"; desc: "Audio editor"; icon: "audacity"; size: "55 MB"; installed: false; category: "media" }
            ListElement { name: "Inkscape"; desc: "Vector graphics"; icon: "inkscape"; size: "90 MB"; installed: false; category: "graphics" }
            ListElement { name: "Okular"; desc: "PDF viewer"; icon: "okular"; size: "25 MB"; installed: true; category: "office" }
        }

        delegate: Rectangle {
            width: 170
            height: 190
            color: "#FFFFFF"
            radius: 8

            Column {
                anchors.fill: parent
                anchors.margins: 15
                spacing: 8

                // App icon
                Rectangle {
                    width: 64
                    height: 64
                    color: "#F0F0F0"
                    radius: 12
                    anchors.horizontalCenter: parent.horizontalCenter

                    Image {
                        source: "image://icon/" + icon
                        width: 40
                        height: 40
                        anchors.centerIn: parent
                        opacity: 0.7
                    }
                }

                Text {
                    text: name
                    font.pixelSize: 14
                    font.bold: true
                    color: "#333333"
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Text {
                    text: desc
                    font.pixelSize: 11
                    color: "#888888"
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Text {
                    text: size
                    font.pixelSize: 10
                    color: "#AAAAAA"
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Item { height: 5 }

                // Install button
                Rectangle {
                    width: 130
                    height: 30
                    color: installed ? "#E5E5E5" : "#0078D4"
                    radius: 15
                    anchors.horizontalCenter: parent.horizontalCenter

                    Text {
                        text: installed ? "Installed" : "Install"
                        color: installed ? "#666666" : "#FFFFFF"
                        font.pixelSize: 12
                        font.bold: true
                        anchors.centerIn: parent
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: installed = !installed
                    }
                }
            }
        }
    }

    // Bottom status bar
    Rectangle {
        id: statusBar
        width: parent.width
        height: 30
        color: "#E8E8E8"
        anchors.bottom: parent.bottom

        Text {
            text: "12 apps available"
            font.pixelSize: 11
            color: "#666666"
            anchors.left: parent.left
            anchors.leftMargin: 20
            anchors.verticalCenter: parent.verticalCenter
        }

        Row {
            anchors.right: parent.right
            anchors.rightMargin: 20
            spacing: 15

            Image {
                source: "image://icon/system-software-update"
                width: 16
                height: 16
                anchors.verticalCenter: parent.verticalCenter
                opacity: 0.5
            }

            Text {
                text: "Updates available"
                font.pixelSize: 11
                color: "#666666"
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
}