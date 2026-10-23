import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: root
    anchors.fill: parent

    // Load custom Syne font
    FontLoader {
        id: syneFont
        source: "fonts/Syne.ttf"
    }

    // Pure black background
    Rectangle {
        anchors.fill: parent
        color: "#000000"
    }

    // Top Right Status & Power Bar
    Row {
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 28
        spacing: 24
        z: 10

        Row {
            spacing: 8
            anchors.verticalCenter: parent.verticalCenter
            Rectangle {
                width: 8
                height: 8
                radius: 4
                color: "#10b981"
                anchors.verticalCenter: parent.verticalCenter
            }
            Text {
                text: "Plasma 6 (Wayland)"
                font.family: syneFont.name
                font.pixelSize: 13
                color: "#9ca3af"
            }
        }

        Text {
            id: clockDisplay
            font.family: syneFont.name
            font.pixelSize: 14
            color: "#ffffff"
            anchors.verticalCenter: parent.verticalCenter
            text: Qt.formatTime(new Date(), "hh:mm")
        }

        Timer {
            interval: 1000
            running: true
            repeat: true
            onTriggered: clockDisplay.text = Qt.formatTime(new Date(), "hh:mm")
        }

        // Reboot Button
        Text {
            text: "⟳"
            font.pixelSize: 18
            color: "#6b7280"
            anchors.verticalCenter: parent.verticalCenter
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onEntered: parent.color = "#ffffff"
                onExited: parent.color = "#6b7280"
                onClicked: if (typeof sddm !== "undefined") sddm.reboot()
            }
        }

        // Power Off Button
        Text {
            text: "⏻"
            font.pixelSize: 18
            color: "#6b7280"
            anchors.verticalCenter: parent.verticalCenter
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onEntered: parent.color = "#ef4444"
                onExited: parent.color = "#6b7280"
                onClicked: if (typeof sddm !== "undefined") sddm.powerOff()
            }
        }
    }

    // Main 2-Column Layout
    Row {
        anchors.fill: parent

        // Left Column (Sidebar)
        Item {
            id: sidebar
            width: Math.max(parent.width * 0.28, 340)
            height: parent.height

            // Right border divider line
            Rectangle {
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: 1
                color: "#262626"
            }

            // Top Logo
            Column {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.leftMargin: 48
                anchors.topMargin: 48
                spacing: 2

                Text {
                    text: "newerase"
                    font.family: syneFont.name
                    font.pixelSize: 34
                    font.weight: Font.DemiBold
                    font.letterSpacing: 4
                    color: "#ffffff"
                }

                Text {
                    text: "OS"
                    font.family: syneFont.name
                    font.pixelSize: 26
                    font.weight: Font.Bold
                    font.letterSpacing: 4
                    color: "#ffffff"
                    anchors.right: parent.right
                    anchors.rightMargin: 8
                }

                Rectangle {
                    width: 56
                    height: 1
                    color: "#525252"
                    anchors.topMargin: 8
                }
            }

            // Bottom Braille Art
            Column {
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                anchors.leftMargin: 48
                anchors.bottomMargin: 32
                spacing: 8

                Text {
                    id: braille
                    font.family: "monospace"
                    font.pixelSize: 11
                    lineHeight: 1.02
                    color: "#d4d4d4"
                    text: "⠀⠀⣿⠲⠤⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n" +
                          "⠀⣸⡏⠀⠀⠀⠉⠳⢄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n" +
                          "⠀⣿⠀⠀⠀⠀⠀⠀⠀⠉⠲⣄⠀⠀⠀⠀⠀⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n" +
                          "⢰⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠲⣄⠀⠀⠐⡰⠋⢙⣿⣦⡀⠀⠀⠀⠀⠀\n" +
                          "⠸⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣙⣦⣮⣤⡀⣸⣿⣿⣿⣆⠀⠀⠀⠀\n" +
                          "⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⣿⣿⣿⠀⣿⢟⣫⠟⠋⠀⠀⠀⠀\n" +
                          "⠀⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⣿⣿⣿⣿⣷⣷⣿⡁⠀⠀⠀⠀⠀⠀\n" +
                          "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⢹⣿⣿⣧⣿⣿⣆⡹⣖⡐⠠⠤⠠⠤\n" +
                          "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢾⣿⣤⣿⣿⣿⡟⠹⣿⣿⣿⣿⣷⡀⠄⢀\n" +
                          "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣧⣴⣿⣿⣿⣿⠏⢧⠀⠀\n" +
                          "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠀⠈⢳⡀\n" +
                          "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⡏⣸⣿⣿⣿⣿⣿⣿⣿⣿⣿⠃⠀⠀⠀⢳\n" +
                          "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⢀⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀\n" +
                          "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠸⣿⣿⣿⣿⣿⣿⣿⣿⠏⠀⠀⠀⠀⠀⠀\n" +
                          "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀\n" +
                          "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⡇⢠⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀\n" +
                          "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠃⢸⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀\n" +
                          "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣼⢸⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀\n" +
                          "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⣿⢸⣿⣿⣿⣿⣿⣿⣿⣿⡄⠀⠀⠀⠀⠀⠀\n" +
                          "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⣿⣿⣾⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀\n" +
                          "⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣇⠀⠀⠀⠀⠀⠀\n" +
                          "⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀\n" +
                          "⠀⠀⠀⠀⠀⠀⠀⠛⠻⠿⣿⣿⣿⡿⠿⠿⠿⠿⠿⢿⣿⣿⠏"
                }

                Text {
                    text: "neweraseOS // MONOCHROME EDITION"
                    font.family: syneFont.name
                    font.pixelSize: 10
                    font.letterSpacing: 2
                    color: "#525252"
                }
            }
        }

        // Right Column (Login Form)
        Item {
            width: parent.width - sidebar.width
            height: parent.height

            Column {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: Math.max(parent.width * 0.12, 60)
                width: Math.min(parent.width * 0.65, 480)
                spacing: 28

                // Header Prompt
                Text {
                    text: "Напишите название учетной записи"
                    font.family: syneFont.name
                    font.pixelSize: 22
                    font.weight: Font.Medium
                    font.letterSpacing: 1
                    color: "#ffffff"
                }

                // Username Input
                Item {
                    width: parent.width
                    height: 44

                    TextInput {
                        id: usernameInput
                        anchors.fill: parent
                        text: "liveuser"
                        font.family: syneFont.name
                        font.pixelSize: 18
                        color: "#ffffff"
                        selectByMouse: true
                        focus: true
                        verticalAlignment: TextInput.AlignVCenter

                        onAccepted: passwordInput.forceActiveFocus()
                    }

                    Rectangle {
                        anchors.bottom: parent.bottom
                        width: parent.width
                        height: usernameInput.activeFocus ? 2 : 1
                        color: usernameInput.activeFocus ? "#38bdf8" : "#ffffff"
                        Behavior on color { ColorAnimation { duration: 150 } }
                    }
                }

                // Password Section
                Column {
                    width: parent.width
                    spacing: 8

                    Text {
                        text: "ПАРОЛЬ (ПУСТО ДЛЯ LIVE-СЕССИИ)"
                        font.family: syneFont.name
                        font.pixelSize: 11
                        font.letterSpacing: 2
                        color: "#737373"
                    }

                    Item {
                        width: parent.width
                        height: 44

                        TextInput {
                            id: passwordInput
                            anchors.fill: parent
                            echoMode: TextInput.Password
                            font.family: syneFont.name
                            font.pixelSize: 18
                            color: "#ffffff"
                            selectByMouse: true
                            verticalAlignment: TextInput.AlignVCenter

                            onAccepted: doLogin()
                        }

                        Rectangle {
                            anchors.bottom: parent.bottom
                            width: parent.width
                            height: passwordInput.activeFocus ? 2 : 1
                            color: passwordInput.activeFocus ? "#38bdf8" : "#525252"
                            Behavior on color { ColorAnimation { duration: 150 } }
                        }
                    }
                }

                // Action Button & Enter Hint
                Row {
                    width: parent.width
                    spacing: 24

                    Rectangle {
                        id: loginBtn
                        width: 220
                        height: 46
                        color: btnMouse.containsMouse ? "#ffffff" : "#0f0f0f"
                        border.color: btnMouse.containsMouse ? "#ffffff" : "#404040"
                        border.width: 1

                        Behavior on color { ColorAnimation { duration: 150 } }

                        Text {
                            anchors.centerIn: parent
                            text: "ВОЙТИ В СИСТЕМУ  →"
                            font.family: syneFont.name
                            font.pixelSize: 12
                            font.weight: Font.Bold
                            font.letterSpacing: 2
                            color: btnMouse.containsMouse ? "#000000" : "#ffffff"
                        }

                        MouseArea {
                            id: btnMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: doLogin()
                        }
                    }

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: "Нажмите [Enter ↵]"
                        font.family: syneFont.name
                        font.pixelSize: 12
                        color: "#525252"
                    }
                }

                // Status Notification
                Text {
                    id: statusLabel
                    font.family: syneFont.name
                    font.pixelSize: 13
                    color: "#a3a3a3"
                    text: "Готово к авторизации в neweraseOS"
                }
            }
        }
    }

    // Login Logic
    function doLogin() {
        var user = usernameInput.text.trim();
        if (user === "") user = "liveuser";
        var pass = passwordInput.text;
        var sIndex = 0;
        
        statusLabel.color = "#10b981";
        statusLabel.text = "Авторизация [" + user + "]... Запуск KDE Plasma 6...";
        
        if (typeof sddm !== "undefined") {
            sddm.login(user, pass, sIndex);
        }
    }
}
