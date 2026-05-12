import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15

Window {
    id: settingsWindow
    visible: true
    width: 900
    height: 600
    title: "Lutiek Settings"
    color: "#F0F0F0"

    // Left navigation panel
    Rectangle {
        id: navPanel
        width: 220
        height: parent.height
        color: "#FFFFFF"
        anchors.left: parent.left

        Column {
            anchors.fill: parent
            spacing: 0

            // Header
            Rectangle {
                width: parent.width
                height: 60
                color: "#0078D4"

                Row {
                    anchors.fill: parent
                    anchors.leftMargin: 15
                    spacing: 10

                    Image {
                        source: "image://icon/Lutiek-Logo"
                        width: 24
                        height: 24
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Text {
                        text: "Settings"
                        color: "#FFFFFF"
                        font.pixelSize: 20
                        font.bold: true
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }

            // Navigation items
            ListView {
                id: navList
                width: parent.width
                height: parent.height - 60
                model: ListModel {
                    ListElement { name: "System"; icon: "computer"; section: "system" }
                    ListElement { name: "Display"; icon: "video-display"; section: "display" }
                    ListElement { name: "Sound"; icon: "audio-volume-high"; section: "sound" }
                    ListElement { name: "Network"; icon: "network-wired"; section: "network" }
                    ListElement { name: "Bluetooth"; icon: "bluetooth"; section: "bluetooth" }
                    ListElement { name: "Personalization"; icon: "colors"; section: "theme" }
                    ListElement { name: "Apps"; icon: "application-x-executable"; section: "apps" }
                    ListElement { name: "Accounts"; icon: "user-identity"; section: "accounts" }
                    ListElement { name: "Time & Language"; icon: "preferences-desktop-locale"; section: "locale" }
                    ListElement { name: "Gaming"; icon: "joystick"; section: "gaming" }
                    ListElement { name: "Accessibility"; icon: "accessibility-features"; section: "accessibility" }
                    ListElement { name: "About"; icon: "help-about"; section: "about" }
                }

                delegate: Rectangle {
                    width: parent.width
                    height: 48
                    color: navList.currentIndex === index ? "#E5F1FB" : (ma.containsMouse ? "#F5F5F5" : "#FFFFFF")

                    Row {
                        anchors.fill: parent
                        anchors.leftMargin: 15
                        spacing: 12

                        Image {
                            source: "image://icon/" + icon
                            width: 22
                            height: 22
                            anchors.verticalCenter: parent.verticalCenter
                            opacity: 0.7
                        }

                        Text {
                            text: name
                            font.pixelSize: 14
                            color: "#333333"
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    MouseArea {
                        id: ma
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: navList.currentIndex = index
                    }
                }
            }
        }
    }

    // Main content area
    Rectangle {
        id: contentArea
        width: parent.width - navPanel.width
        height: parent.height
        color: "#F5F5F5"
        anchors.left: navPanel.right

        ScrollView {
            anchors.fill: parent
            anchors.margins: 20

            Column {
                width: parent.width - 40
                spacing: 20

                // Page title
                Text {
                    id: pageTitle
                    text: "System"
                    font.pixelSize: 28
                    font.bold: true
                    color: "#333333"
                }

                // System info card
                Rectangle {
                    width: parent.width
                    height: 180
                    color: "#FFFFFF"
                    radius: 8

                    Column {
                        anchors.fill: parent
                        anchors.margins: 20
                        spacing: 15

                        Row {
                            spacing: 20

                            Image {
                                source: "image://icon-computer"
                                width: 64
                                height: 64
                                opacity: 0.8
                            }

                            Column {
                                spacing: 4

                                Text {
                                    text: "Lutiek OS 2026"
                                    font.pixelSize: 18
                                    font.bold: true
                                    color: "#333333"
                                }

                                Text {
                                    text: "Version 1.0.0"
                                    font.pixelSize: 14
                                    color: "#666666"
                                }

                                Text {
                                    text: "Ubuntu 24.04 LTS"
                                    font.pixelSize: 12
                                    color: "#888888"
                                }
                            }
                        }

                        Row {
                            spacing: 40

                            Column {
                                Text { text: "Processor"; font.pixelSize: 12; color: "#888888" }
                                Text { text: "Virtual CPU 2x"; font.pixelSize: 14; color: "#333333" }
                            }

                            Column {
                                Text { text: "Memory"; font.pixelSize: 12; color: "#888888" }
                                Text { text: "4 GB"; font.pixelSize: 14; color: "#333333" }
                            }

                            Column {
                                Text { text: "Storage"; font.pixelSize: 12; color: "#888888" }
                                Text { text: "50 GB"; font.pixelSize: 14; color: "#333333" }
                            }
                        }
                    }
                }

                // Quick actions
                Text {
                    text: "Quick Actions"
                    font.pixelSize: 16
                    font.bold: true
                    color: "#333333"
                }

                Row {
                    spacing: 15

                    Rectangle {
                        width: 140
                        height: 100
                        color: "#FFFFFF"
                        radius: 8

                        Column {
                            anchors.centerIn: parent
                            spacing: 8

                            Image { source: "image://icon-update-medium"; width: 32; height: 32; opacity: 0.7 }
                            Text { text: "Update"; font.pixelSize: 12; color: "#333333" }
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            onEntered: parent.color = "#E5E5E5"
                            onExited: parent.color = "#FFFFFF"
                        }
                    }

                    Rectangle {
                        width: 140
                        height: 100
                        color: "#FFFFFF"
                        radius: 8

                        Column {
                            anchors.centerIn: parent
                            spacing: 8

                            Image { source: "image://icon-security-high"; width: 32; height: 32; opacity: 0.7 }
                            Text { text: "Security"; font.pixelSize: 12; color: "#333333" }
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            onEntered: parent.color = "#E5E5E5"
                            onExited: parent.color = "#FFFFFF"
                        }
                    }

                    Rectangle {
                        width: 140
                        height: 100
                        color: "#FFFFFF"
                        radius: 8

                        Column {
                            anchors.centerIn: parent
                            spacing: 8

                            Image { source: "image://icon-drive-harddisk"; width: 32; height: 32; opacity: 0.7 }
                            Text { text: "Storage"; font.pixelSize: 12; color: "#333333" }
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            onEntered: parent.color = "#E5E5E5"
                            onExited: parent.color = "#FFFFFF"
                        }
                    }

                    Rectangle {
                        width: 140
                        height: 100
                        color: "#FFFFFF"
                        radius: 8

                        Column {
                            anchors.centerIn: parent
                            spacing: 8

                            Image { source: "image://icon-applications-system"; width: 32; height: 32; opacity: 0.7 }
                            Text { text: "Apps"; font.pixelSize: 12; color: "#333333" }
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            onEntered: parent.color = "#E5E5E5"
                            onExited: parent.color = "#FFFFFF"
                        }
                    }
                }

                // Startup apps
                Text {
                    text: "Startup Applications"
                    font.pixelSize: 16
                    font.bold: true
                    color: "#333333"
                }

                Rectangle {
                    width: parent.width
                    height: 200
                    color: "#FFFFFF"
                    radius: 8

                    ListView {
                        anchors.fill: parent
                        anchors.margins: 10

                        model: ListModel {
                            ListElement { name: "Lutiek App Center"; enabled: true; icon: "software-manager" }
                            ListElement { name: "Bluetooth Manager"; enabled: true; icon: "bluetooth" }
                            ListElement { name: "Network Manager"; enabled: true; icon: "network-wired" }
                            ListElement { name: "Sound Settings"; enabled: false; icon: "audio-volume-high" }
                            ListElement { name: "Touchpad"; enabled: true; icon: "input-touchpad" }
                        }

                        delegate: Row {
                            width: parent.width - 20
                            height: 40

                            Switch {
                                anchors.verticalCenter: parent.verticalCenter
                                checked: enabled
                                onCheckedChanged: enabled = checked
                            }

                            Image {
                                source: "image://icon/" + icon
                                width: 24
                                height: 24
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.leftMargin: 10
                                opacity: 0.6
                            }

                            Text {
                                text: name
                                font.pixelSize: 14
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.leftMargin: 10
                            }
                        }
                    }
                }
            }
        }
    }
}