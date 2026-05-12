import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.15

Rectangle {
    id: launcherRoot
    visible: false
    width: 600
    height: 640
    color: "#FFFFFF"
    radius: 8
    anchors.left: parent.left
    anchors.bottom: parent.bottom
    anchors.leftMargin: 10
    anchors.bottomMargin: 50

    // Drop shadow
    layer.enabled: true
    layer.effect: DropShadow {
        radius: 20
        samples: 25
        color: "#40000000"
        spread: 0
    }

    // Subtle border
    border.width: 1
    border.color: "#E0E0E0"

    property bool searchFocused: false

    Rectangle {
        id: titleBar
        width: parent.width
        height: 50
        color: "#0078D4"
        anchors.top: parent.top
        radius: 8

        Row {
            anchors.fill: parent
            anchors.leftMargin: 15
            spacing: 0

            Image {
                source: "image://icon/Lutiek-Logo"
                width: 30
                height: 30
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                text: "Lutiek OS"
                color: "#FFFFFF"
                font.pixelSize: 18
                font.bold: true
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 10
            }
        }
    }

    // Search bar
    Rectangle {
        id: searchBar
        width: parent.width - 40
        height: 44
        color: "#F0F0F0"
        radius: 22
        anchors.top: titleBar.bottom
        anchors.topMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter

        Row {
            anchors.fill: parent
            anchors.leftMargin: 15
            spacing: 10

            Image {
                source: "image://icon/system-search"
                width: 20
                height: 20
                anchors.verticalCenter: parent.verticalCenter
                opacity: 0.5
            }

            TextInput {
                id: searchInput
                width: parent.width - 60
                anchors.verticalCenter: parent.verticalCenter
                placeholderText: "Type here to search"
                placeholderTextColor: "#999999"
                font.pixelSize: 14
                verticalAlignment: TextInput.AlignVCenter
                onFocusChanged: searchFocused = focus
            }
        }
    }

    // Pinned apps grid
    Text {
        id: pinnedLabel
        text: "Pinned"
        font.pixelSize: 14
        font.bold: true
        color: "#333333"
        anchors.top: searchBar.bottom
        anchors.topMargin: 20
        anchors.left: parent.left
        anchors.leftMargin: 20
    }

    GridView {
        id: pinnedApps
        width: parent.width - 40
        height: 300
        anchors.top: pinnedLabel.bottom
        anchors.topMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
        cellWidth: 90
        cellHeight: 90
        interactive: false

        model: ListModel {
            ListElement { name: "Files"; icon: "folder"; exe: "dolphin" }
            ListElement { name: "Settings"; icon: "preferences-system"; exe: "systemsettings" }
            ListElement { name: "Browser"; icon: "web-browser"; exe: "firefox" }
            ListElement { name: "Terminal"; icon: "utilities-terminal"; exe: "konsole" }
            ListElement { name: "App Center"; icon: "software-manager"; exe: "plasma-discover" }
            ListElement { name: "Write"; icon: "document"; exe: "kate" }
            ListElement { name: "Calculator"; icon: "calculator"; exe: "kcalc" }
            ListElement { name: "Photos"; icon: "image-viewer"; exe: " Gwenview" }
            ListElement { name: "Music"; icon: "audio-player"; exe: "elisa" }
            ListElement { name: "Videos"; icon: "video-player"; exe: "Haruna" }
        }

        delegate: Rectangle {
            width: 80
            height: 80
            color: "transparent"
            radius: 8

            Column {
                anchors.centerIn: parent
                spacing: 4

                Rectangle {
                    width: 48
                    height: 48
                    color: "#F5F5F5"
                    radius: 8
                    anchors.horizontalCenter: parent.horizontalCenter

                    Image {
                        source: "image://icon/" + icon
                        width: 32
                        height: 32
                        anchors.centerIn: parent
                        opacity: 0.7
                    }
                }

                Text {
                    text: name
                    font.pixelSize: 12
                    color: "#333333"
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: parent.color = "#E5E5E5"
                onExited: parent.color = "transparent"
                onClicked: {
                    launcherRoot.visible = false
                    Qt.openUrlExternally("app://" + exe)
                }
            }
        }
    }

    // Recent items
    Text {
        id: recentLabel
        text: "Recent"
        font.pixelSize: 14
        font.bold: true
        color: "#333333"
        anchors.top: pinnedApps.bottom
        anchors.topMargin: 15
        anchors.left: parent.left
        anchors.leftMargin: 20
    }

    ListView {
        id: recentItems
        width: parent.width - 40
        height: 80
        anchors.top: recentLabel.bottom
        anchors.topMargin: 5
        anchors.horizontalCenter: parent.horizontalCenter
        orientation: ListView.Horizontal
        interactive: false

        model: ListModel {
            ListElement { name: "Documents"; icon: "folder-documents"; path: "/home/lutiek/Documents" }
            ListElement { name: "Downloads"; icon: "folder-downloads"; path: "/home/lutiek/Downloads" }
            ListElement { name: "Pictures"; icon: "folder-pictures"; path: "/home/lutiek/Pictures" }
            ListElement { name: "Music"; icon: "folder-music"; path: "/home/lutiek/Music" }
        }

        delegate: Rectangle {
            width: 100
            height: 70
            color: "transparent"
            radius: 4

            Column {
                anchors.centerIn: parent
                spacing: 4

                Image {
                    source: "image://icon/" + icon
                    width: 32
                    height: 32
                    anchors.horizontalCenter: parent.horizontalCenter
                    opacity: 0.6
                }

                Text {
                    text: name
                    font.pixelSize: 12
                    color: "#555555"
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: parent.color = "#E5E5E5"
                onExited: parent.color = "transparent"
                onClicked: {
                    launcherRoot.visible = false
                    Qt.openUrlExternally("file://" + path)
                }
            }
        }
    }

    // Bottom bar: Power menu
    Rectangle {
        id: bottomBar
        width: parent.width
        height: 50
        color: "#F5F5F5"
        anchors.bottom: parent.bottom
        radius: 0

        Row {
            anchors.fill: parent
            anchors.leftMargin: 20
            anchors.rightMargin: 20

            // User profile
            Row {
                spacing: 10

                Rectangle {
                    width: 36
                    height: 36
                    color: "#0078D4"
                    radius: 18

                    Text {
                        text: "L"
                        color: "#FFFFFF"
                        font.pixelSize: 18
                        font.bold: true
                        anchors.centerIn: parent
                    }
                }

                Text {
                    text: "Lutiek"
                    font.pixelSize: 14
                    anchors.verticalCenter: parent.verticalCenter
                    color: "#333333"
                }
            }

            Item { Layout.fillWidth: true }

            // Power button
            ToolButton {
                icon.name: "system-shutdown"
                icon.width: 22
                icon.height: 22
                anchors.verticalCenter: parent.verticalCenter
                onClicked: powerMenu.open()

                Menu {
                    id: powerMenu
                    x: -120
                    y: -200

                    MenuItem {
                        text: "Shutdown"
                        onTriggered: Qt.quit()
                    }
                    MenuItem {
                        text: "Restart"
                        onTriggered: Qt.quit()
                    }
                    MenuItem {
                        text: "Sleep"
                        onTriggered: Qt.quit()
                    }
                }
            }
        }
    }
}