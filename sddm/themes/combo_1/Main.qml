import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

// Define the main rectangle for the theme
ApplicationWindow {
    visible: true
    width: 600
    height: 400
    title: "Login Theme"

    // Clock and Date
    Rectangle {
        width: parent.width
        height: 50
        color: "#333"
        anchors.top: parent.top
        Text {
            anchors.centerIn: parent
            font.pixelSize: 20
            color: "white"
            text: Qt.formatDate(new Date(), "yyyy-MM-dd hh:mm:ss")
        }
    }

    // Login Form Container
    Rectangle {
        width: parent.width
        height: parent.height - 100
        color: "#444"
        anchors.top: parent.top
        anchors.topMargin: 60

        // Form Elements
        ColumnLayout {
            anchors.centerIn: parent

            TextField {
                id: username
                placeholderText: "Username"
                Layout.fillWidth: true
                font.pixelSize: 18
            }

            // Password input field using TextField with echoMode set to Password
            TextField {
                id: password
                placeholderText: "Password"
                Layout.fillWidth: true
                font.pixelSize: 18
                echoMode: TextInput.Password
            }

            // Login Button
            Button {
                text: "Login"
                Layout.fillWidth: true
                onClicked: {
                    // Implement login action here
                    console.log("Login clicked")
                }
            }
        }
    }

    // Action Buttons (Shutdown, Reboot, Lock, Suspend)
    Rectangle {
        width: parent.width
        height: 60
        color: "#222"
        anchors.bottom: parent.bottom
        RowLayout {
            anchors.centerIn: parent
            spacing: 20

            // Shutdown Button
            Button {
                text: "Shutdown"
                onClicked: {
                    // Implement shutdown action here
                    console.log("Shutdown clicked")
                }
            }

            // Reboot Button
            Button {
                text: "Reboot"
                onClicked: {
                    // Implement reboot action here
                    console.log("Reboot clicked")
                }
            }

            // Lock Button
            Button {
                text: "Lock"
                onClicked: {
                    // Implement lock action here
                    console.log("Lock clicked")
                }
            }

            // Suspend Button
            Button {
                text: "Suspend"
                onClicked: {
                    // Implement suspend action here
                    console.log("Suspend clicked")
                }
            }
        }
    }

    // Function to update clock every second
    Timer {
        id: clockTimer
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            clock.text = Qt.formatDate(new Date(), "yyyy-MM-dd hh:mm:ss")
        }
    }
}
