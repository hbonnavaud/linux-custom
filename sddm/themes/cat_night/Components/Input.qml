import QtQuick 2.11
import QtQuick.Layouts 1.11
import QtQuick.Controls 2.4
import QtGraphicalEffects 1.0

Column {
    id: inputContainer
    Layout.fillWidth: true
    spacing: 10

    property Control exposeSession: sessionSelect.exposeSession
    property bool failed
    property string fontName: ""


    Item {
        id: usernameField

        height: root.font.pointSize * 4.5
        width: parent.width / 2
        anchors.horizontalCenter: parent.horizontalCenter

        ComboBox {

            id: selectUser

            width: parent.height
            height: parent.height
            anchors.left: parent.left

            property var popkey: config.ForceRightToLeft == "true" ? Qt.Key_Right : Qt.Key_Left
            Keys.onPressed: {
                if (event.key == Qt.Key_Down && !popup.opened)
                    username.forceActiveFocus();
                if ((event.key == Qt.Key_Up || event.key == popkey) && !popup.opened)
                    popup.open();
                }
            KeyNavigation.down: username
            KeyNavigation.right: username
            z: 2

            model: userModel
            currentIndex: model.lastIndex
            textRole: "name"
            hoverEnabled: true
            onActivated: {
                username.text = currentText
            }

            delegate: ItemDelegate {
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                contentItem: Text {
                    text: model.name
                    font.pointSize: config.form_text_font_size
                    font.family: fontName
                    font.capitalization: Font.Capitalize
                    color: selectUser.highlightedIndex === index ? root.colors.text_highlight_color : root.color.text_color
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }
                highlighted: parent.highlightedIndex === index
                background: Rectangle {
                    color: selectUser.highlightedIndex === index ? root.colors.text_highlight_color : "transparent"
                }
            }

            indicator: Button {
                    id: usernameIcon
                    width: selectUser.height * 0.8
                    height: parent.height
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: selectUser.height * 0.125
                    icon.height: parent.height * 0.25
                    icon.width: parent.height * 0.25
                    enabled: false
                    icon.color: root.colors.text_color
                    icon.source: Qt.resolvedUrl("../Assets/User.svgz")
            }

            background: Rectangle {
                color: "transparent"
                border.color: "transparent"
            }

            popup: Popup {
                y: parent.height - username.height / 3
                x: config.ForceRightToLeft == "true" ? -loginButton.width + selectUser.width : 0
                rightMargin: config.ForceRightToLeft == "true" ? root.padding + usernameField.width / 2 : undefined
                width: usernameField.width
                implicitHeight: contentItem.implicitHeight
                padding: 10

                contentItem: ListView {
                    clip: true
                    implicitHeight: contentHeight + 20
                    model: selectUser.popup.visible ? selectUser.delegateModel : null
                    currentIndex: selectUser.highlightedIndex
                    ScrollIndicator.vertical: ScrollIndicator { }
                }

                background: Rectangle {
                    radius: config.RoundCorners / 2
                    color: root.colors.window_color
                    layer.enabled: true
                    layer.effect: DropShadow {
                        transparentBorder: true
                        horizontalOffset: 0
                        verticalOffset: 10 * config.InterfaceShadowSize
                        radius: 20 * config.InterfaceShadowSize
                        samples: 41 * config.InterfaceShadowSize
                        cached: true
                        color: Qt.hsla(0,0,0,config.InterfaceShadowOpacity)
                    }
                }

                enter: Transition {
                    NumberAnimation { property: "opacity"; from: 0; to: 1 }
                }
            }

            states: [
                State {
                    name: "pressed"
                    when: selectUser.down
                    PropertyChanges {
                        target: usernameIcon
                        icon.color: Qt.lighter(root.colors.text_highlight_color, 1.1)
                    }
                },
                State {
                    name: "hovered"
                    when: selectUser.hovered
                    PropertyChanges {
                        target: usernameIcon
                        icon.color: Qt.lighter(root.colors.text_highlight_color, 1.2)
                    }
                },
                State {
                    name: "focused"
                    when: selectUser.activeFocus
                    PropertyChanges {
                        target: usernameIcon
                        icon.color: root.colors.text_highlight_color
                    }
                }
            ]

            transitions: [
                Transition {
                    PropertyAnimation {
                        properties: "color, border.color, icon.color"
                        duration: 150
                    }
                }
            ]

        }

        TextField {
            id: username
            color: root.colors.text_color
            text: config.ForceLastUser == "true" ? selectUser.currentText : null
            font.capitalization: config.AllowBadUsernames == "false" ? Font.Capitalize : Font.MixedCase
            anchors.centerIn: parent
            height: config.form_login_font_size * 3
            font.family: fontName
            font.pointSize: config.form_login_font_size
            width: parent.width
            placeholderText: config.TranslatePlaceholderUsername || textConstants.userName
            selectByMouse: true
            horizontalAlignment: TextInput.AlignHCenter
            renderType: Text.QtRendering
            onFocusChanged:{
                if(focus)
                    selectAll()
            }
            background: Rectangle {
                color: "transparent"
                border.color: root.colors.text_color
                border.width: config.form_borders_width
                radius: config.RoundCorners || 0
            }
            onAccepted: loginButton.clicked()
            KeyNavigation.down: password
            z: 1

            states: [
                State {
                    name: "focused"
                    when: username.activeFocus
                    PropertyChanges {
                        target: username.background
                        border.color: root.colors.text_highlight_color
                    }
                    PropertyChanges {
                        target: username
                        color: root.colors.text_color
                    }
                }
            ]
        }

    }

    Item {
        id: passwordField
        height: config.form_login_font_size * 4.5
        width: parent.width / 2
        anchors.horizontalCenter: parent.horizontalCenter

        TextField {
            id: password
            color: root.colors.text_color
            anchors.centerIn: parent
            height: config.form_login_font_size * 3
            font.family: fontName
            font.pointSize: config.form_login_font_size
            width: parent.width
            focus: config.ForcePasswordFocus == "true" ? true : false
            selectByMouse: true
            echoMode: revealSecret.checked ? TextInput.Normal : TextInput.Password
            placeholderText: config.TranslatePlaceholderPassword || textConstants.password
            horizontalAlignment: TextInput.AlignHCenter
            passwordCharacter: "•"
            passwordMaskDelay: config.ForceHideCompletePassword == "true" ? undefined : 1000
            renderType: Text.QtRendering
            background: Rectangle {
                color: "transparent"
                border.color: root.colors.text_color
                border.width: config.form_borders_width
                radius: config.RoundCorners || 0
            }
            onAccepted: loginButton.clicked()
            KeyNavigation.down: revealSecret
        }

        states: [
            State {
                name: "focused"
                when: password.activeFocus
                PropertyChanges {
                    target: password.background
                    border.color: root.colors.text_highlight_color
                }
                PropertyChanges {
                    target: password
                    color: root.colors.text_highlight_color
                }
            }
        ]

        transitions: [
            Transition {
                PropertyAnimation {
                    properties: "color, border.color"
                    duration: 150
                }
            }
        ]
    }

    Item {
        id: secretCheckBox
        height: root.font.pointSize * 2
        width: parent.width / 2
        anchors.horizontalCenter: parent.horizontalCenter

        CheckBox {
            id: revealSecret
            width: parent.width
            hoverEnabled: true

            indicator: Rectangle {
                id: indicator
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.topMargin: 3
                anchors.leftMargin: 4
                implicitHeight: root.font.pointSize
                implicitWidth: root.font.pointSize
                color: "transparent"
                border.color: root.colors.text_color
                border.width: parent.activeFocus ? 2 : 1
                Rectangle {
                    id: dot
                    anchors.centerIn: parent
                    implicitHeight: parent.width - 6
                    implicitWidth: parent.width - 6
                    color: root.colors.text_color
                    opacity: revealSecret.checked ? 1 : 0
                }
            }

            contentItem: Text {
                id: indicatorLabel
                text: config.TranslateShowPassword || "Show Password"
                anchors.verticalCenter: indicator.verticalCenter
                horizontalAlignment: Text.AlignLeft
                anchors.left: indicator.right
                anchors.leftMargin: indicator.width / 2
                font.pointSize: config.form_base_text_font_size
                font.family: fontName
                color: root.colors.text_color
            }

            Keys.onReturnPressed: toggle()
            Keys.onEnterPressed: toggle()
            KeyNavigation.down: loginButton


            background: Rectangle {
                color: "transparent"
                border.width: 0
                border.color: parent.activeFocus ? root.colors.text_color : "transparent"
                height: 0
                width: (indicator.width + indicatorLabel.contentWidth + indicatorLabel.anchors.leftMargin + 2)
                anchors.top: indicatorLabel.bottom
                anchors.left: parent.left
                anchors.leftMargin: 3
                anchors.topMargin: 8
            }
        }

        states: [
            State {
                name: "pressed"
                when: revealSecret.down
                PropertyChanges {
                    target: revealSecret.contentItem
                    color: Qt.darker(root.colors.text_highlight_color, 1.1)
                }
                PropertyChanges {
                    target: dot
                    color: Qt.darker(root.colors.text_highlight_color, 1.1)
                }
                PropertyChanges {
                    target: indicator
                    border.color: Qt.darker(root.colors.text_highlight_color, 1.1)
                }
                PropertyChanges {
                    target: revealSecret.background
                    border.color: Qt.darker(root.colors.text_highlight_color, 1.1)
                }
            },
            State {
                name: "hovered"
                when: revealSecret.hovered
                PropertyChanges {
                    target: indicatorLabel
                    color: Qt.lighter(root.colors.text_highlight_color, 1.1)
                }
                PropertyChanges {
                    target: indicator
                    border.color: Qt.lighter(root.colors.text_highlight_color, 1.1)
                }
                PropertyChanges {
                    target: dot
                    color: Qt.lighter(root.colors.text_highlight_color, 1.1)
                }
                PropertyChanges {
                    target: revealSecret.background
                    border.color: Qt.lighter(root.colors.text_highlight_color, 1.1)
                }
            },
            State {
                name: "focused"
                when: revealSecret.activeFocus
                PropertyChanges {
                    target: indicatorLabel
                    color: root.colors.text_highlight_color
                }
                PropertyChanges {
                    target: indicator
                    border.color: root.colors.text_highlight_color
                }
                PropertyChanges {
                    target: dot
                    color: root.colors.text_highlight_color
                }
                PropertyChanges {
                    target: revealSecret.background
                    border.color: root.colors.text_highlight_color
                }
            }
        ]

        transitions: [
            Transition {
                PropertyAnimation {
                    properties: "color, border.color, opacity"
                    duration: 150
                }
            }
        ]
    }

    Item {
        id: login
        height: config.form_login_font_size * 3
        width: parent.width / 2
        anchors.horizontalCenter: parent.horizontalCenter

        Button {
            id: loginButton
            anchors.horizontalCenter: parent.horizontalCenter
            text: config.TranslateLogin || textConstants.login
            height: config.form_login_font_size * 3
            font.family: fontName
            implicitWidth: parent.width
            enabled: config.AllowEmptyPassword == "true" || username.text != "" && password.text != "" ? true : false
            hoverEnabled: true

            contentItem: Text {
                text: parent.text
                font.family: fontName
                color: root.colors.button_text_color
                font.pointSize: config.form_login_font_size
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            background: Rectangle {
                id: buttonBackground
                color: root.colors.button_color
                opacity: 0.8
                radius: config.RoundCorners || 0
            }

            states: [
                State {
                    name: "pressed"
                    when: loginButton.down
                    PropertyChanges {
                        target: buttonBackground
                        color: Qt.darker(root.colors.text_highlight_color, 1.1)
                        opacity: 1
                    }
                    PropertyChanges {
                        target: loginButton.contentItem
                    }
                },
                State {
                    name: "hovered"
                    when: loginButton.hovered
                    PropertyChanges {
                        target: buttonBackground
                        color: Qt.lighter(root.colors.text_highlight_color, 1.15)
                        opacity: 1
                    }
                    PropertyChanges {
                        target: loginButton.contentItem
                        opacity: 1
                    }
                },
                State {
                    name: "focused"
                    when: loginButton.activeFocus
                    PropertyChanges {
                        target: buttonBackground
                        color: Qt.lighter(root.colors.text_highlight_color, 1.2)
                        opacity: 1
                    }
                    PropertyChanges {
                        target: loginButton.contentItem
                        opacity: 1
                    }
                },
                State {
                    name: "enabled"
                    when: loginButton.enabled
                    PropertyChanges {
                        target: buttonBackground;
                        color: root.colors.text_highlight_color;
                        opacity: 1
                    }
                    PropertyChanges {
                        target: loginButton.contentItem;
                        opacity: 1
                    }
                }
            ]

            transitions: [
                Transition {
                    PropertyAnimation {
                        properties: "opacity, color";
                        duration: 300
                    }
                }
            ]

            onClicked: config.AllowBadUsernames == "false" ? sddm.login(username.text.toLowerCase(), password.text, sessionSelect.selectedSession) : sddm.login(username.text, password.text, sessionSelect.selectedSession)
            Keys.onReturnPressed: clicked()
            Keys.onEnterPressed: clicked()
            KeyNavigation.down: sessionSelect.exposeSession
        }
    }

    SessionButton {
        id: sessionSelect
        textConstantSession: textConstants.session
        loginButtonWidth: loginButton.background.width
        fontName: font.name
    }

    Item {
        height: root.font.pointSize * 2.3
        width: parent.width / 2
        anchors.horizontalCenter: parent.horizontalCenter
        Label {
            id: errorMessage
            width: parent.width
            text: failed ? config.TranslateLoginFailedWarning || textConstants.loginFailed + "!" : keyboard.capsLock ? config.TranslateCapslockWarning || textConstants.capslockWarning : null
            font.family: fontName
            horizontalAlignment: Text.AlignHCenter
            font.pointSize: config.form_base_text_font_size
            font.italic: true
            color: root.colors.text_color
            opacity: 0
            states: [
                State {
                    name: "fail"
                    when: failed
                    PropertyChanges {
                        target: errorMessage
                        opacity: 1
                    }
                },
                State {
                    name: "capslock"
                    when: keyboard.capsLock
                    PropertyChanges {
                        target: errorMessage
                        opacity: 1
                    }
                }
            ]
            transitions: [
                Transition {
                    PropertyAnimation {
                        properties: "opacity"
                        duration: 100
                    }
                }
            ]
        }
    }

    Connections {
        target: sddm
        onLoginSucceeded: {}
        onLoginFailed: {
            failed = true
            resetError.running ? resetError.stop() && resetError.start() : resetError.start()
        }
    }

    Timer {
        id: resetError
        interval: 2000
        onTriggered: failed = false
        running: false
    }
}
