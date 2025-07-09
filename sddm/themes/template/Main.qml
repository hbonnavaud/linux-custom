import QtQuick 2.11
import QtQuick.Layouts 1.11
import QtQuick.Controls 2.4
import QtGraphicalEffects 1.0
import QtQuick.Window 2.0
import "Components"
import SddmComponents 2.0 as SDDM

Pane {
    id: root
    SDDM.TextConstants { id: textConstants }
    height: Screen.height
    width: Screen.width
    LayoutMirroring.childrenInherit: true

    // Compute columns and rows positions.
    // The columns positions are used for horizontal positioning "left", "center", and "right".
    // The rows positions are used for vertical positioning "top", "center", and "bottom".
    property var top_position: Screen.height / 4  // y position of "top" row
    property var v_center_position: Screen.height / 2  // Y position of "center" row
    property var bottom_position: Screen.height * 3 / 4  // Y position of "bottom" row
    property var left_position: Screen.width / 4  // y position of "top" column
    property var h_center_position: Screen.width / 2  // Y position of "center" column
    property var right_position: Screen.width * 3 / 4  // Y position of "bottom" column

    function get_horizontal_offset(column_name, horizontal_offset) {
        let column_position = 0
        switch (column_name) {
            case "left":
                column_position = left_position
                break
            case "center":
                column_position = h_center_position
                break
            case "right":
                column_position = right_position
                break
            default:
                column_position = 0
                break
        }
        return column_position + horizontal_offset*1
    }

    function get_vertical_offset(row_name, vertical_offset) {
        let row_position = 0
        switch (row_name) {
            case "top":
                row_position = top_position
                break
            case "center":
                row_position = v_center_position
                break
            case "bottom":
                row_position = bottom_position
                break
            default:
                row_position = 0
                break
        }
        return row_position + vertical_offset*1
    }

    property var colors: {
        "text_color": config.text_color,
        "text_highlight_color": config.text_highlight_color,
        "text_title_color": config.text_title_color,
        "button_color": config.button_color,
        "button_text_color": config.button_text_color,
        "window_color": config.window_color,
    }

    FontLoader {
        id: font
        source: config.font_path
    }

    padding: config.ScreenPadding
    palette.button: "transparent"
    palette.highlight: config.AccentColor
    palette.text: config.MainColor
    palette.buttonText: config.MainColor
    palette.window: config.BackgroundColor

    font.family: font.name
    font.pointSize: config.FontSize !== "" ? config.FontSize : parseInt(height / 80)
    focus: true

    property bool leftleft: config.HaveFormBackground == "true" &&
                            config.PartialBlur == "false" &&
                            config.FormPosition == "left" &&
                            config.BackgroundImageHAlignment == "left"

    property bool leftcenter: config.HaveFormBackground == "true" &&
                              config.PartialBlur == "false" &&
                              config.FormPosition == "left" &&
                              config.BackgroundImageHAlignment == "center"

    property bool rightright: config.HaveFormBackground == "true" &&
                              config.PartialBlur == "false" &&
                              config.FormPosition == "right" &&
                              config.BackgroundImageHAlignment == "right"

    property bool rightcenter: config.HaveFormBackground == "true" &&
                               config.PartialBlur == "false" &&
                               config.FormPosition == "right" &&
                               config.BackgroundImageHAlignment == "center"

    Item {
        id: sizeHelper

        anchors.fill: parent
        height: parent.height
        width: parent.width

        Rectangle {
            id: tintLayer
            anchors.fill: parent
            width: parent.width
            height: parent.height
            color: "black"
            opacity: config.DimBackgroundImage
            z: 1
        }

        Clock {
            id: clock
            height: root.height / 4
            width: parent.width / 2.5
            anchors.horizontalCenter: parent.left
            anchors.verticalCenter: parent.top
            anchors.horizontalCenterOffset: get_horizontal_offset(config.clock_horizontal_alignment, config.clock_horizontal_offset)
            anchors.verticalCenterOffset: get_vertical_offset(config.clock_vertical_alignment, config.clock_vertical_offset)
            fontName: font.name
            z: 1
        }

        Input {
            id: form
            height: parent.height / 4
            width: parent.width / 3
            anchors.horizontalCenter: parent.left
            anchors.verticalCenter: parent.top
            anchors.horizontalCenterOffset: get_horizontal_offset(config.form_horizontal_alignment, config.form_horizontal_offset)
            anchors.verticalCenterOffset: get_vertical_offset(config.form_vertical_alignment, config.form_vertical_offset)
            fontName: font.name
            z: 1
        }

        SystemButtons {
            id: systemButtons
            height: root.height / 4
            anchors.horizontalCenter: parent.left
            anchors.verticalCenter: parent.top
            anchors.horizontalCenterOffset: get_horizontal_offset(config.buttons_horizontal_alignment, config.buttons_horizontal_offset)
            anchors.verticalCenterOffset: get_vertical_offset(config.buttons_vertical_alignment, config.buttons_vertical_offset)
            exposedSession: form.exposeSession
            fontName: font.name
            z: 1
        }

        Button {
            id: vkb
            onClicked: virtualKeyboard.switchState()
            visible: virtualKeyboard.status == Loader.Ready && config.ForceHideVirtualKeyboardButton == "false"
            anchors.bottom: parent.bottom
            anchors.bottomMargin: implicitHeight
            anchors.horizontalCenter: form.horizontalCenter
            z: 1
            contentItem: Text {
                text: config.TranslateVirtualKeyboardButton || "Virtual Keyboard"
                color: parent.visualFocus ? palette.highlight : palette.text
                font.pointSize: root.font.pointSize * 0.8
                font.family: fontName
            }
            background: Rectangle {
                id: vkbbg
                color: "transparent"
            }
        }

        Loader {
            id: virtualKeyboard
            source: "Components/VirtualKeyboard.qml"
            state: "hidden"
            property bool keyboardActive: item ? item.active : false
            onKeyboardActiveChanged: keyboardActive ? state = "visible" : state = "hidden"
            width: parent.width
            z: 1
            function switchState() { state = state == "hidden" ? "visible" : "hidden" }
            states: [
                State {
                    name: "visible"
                    PropertyChanges {
                        target: form
                        systemButtonVisibility: false
                        clockVisibility: false
                    }
                    PropertyChanges {
                        target: virtualKeyboard
                        y: root.height - virtualKeyboard.height
                        opacity: 1
                    }
                },
                State {
                    name: "hidden"
                    PropertyChanges {
                        target: virtualKeyboard
                        y: root.height - root.height/4
                        opacity: 0
                    }
                }
            ]
            transitions: [
                Transition {
                    from: "hidden"
                    to: "visible"
                    SequentialAnimation {
                        ScriptAction {
                            script: {
                                virtualKeyboard.item.activated = true;
                                Qt.inputMethod.show();
                            }
                        }
                        ParallelAnimation {
                            NumberAnimation {
                                target: virtualKeyboard
                                property: "y"
                                duration: 100
                                easing.type: Easing.OutQuad
                            }
                            OpacityAnimator {
                                target: virtualKeyboard
                                duration: 100
                                easing.type: Easing.OutQuad
                            }
                        }
                    }
                },
                Transition {
                    from: "visible"
                    to: "hidden"
                    SequentialAnimation {
                        ParallelAnimation {
                            NumberAnimation {
                                target: virtualKeyboard
                                property: "y"
                                duration: 100
                                easing.type: Easing.InQuad
                            }
                            OpacityAnimator {
                                target: virtualKeyboard
                                duration: 100
                                easing.type: Easing.InQuad
                            }
                        }
                        ScriptAction {
                            script: {
                                Qt.inputMethod.hide();
                            }
                        }
                    }
                }
            ]
        }

        Image {
            id: backgroundImage

            height: parent.height
            width: config.HaveFormBackground == "true" && config.FormPosition != "center" && config.PartialBlur != "true" ? parent.width - formBackground.width : parent.width
            anchors.left: leftleft ||
                          leftcenter ?
                                formBackground.right : undefined

            anchors.right: rightright ||
                           rightcenter ?
                                formBackground.left : undefined

            horizontalAlignment: config.BackgroundImageHAlignment == "left" ?
                                 Image.AlignLeft :
                                 config.BackgroundImageHAlignment == "right" ?
                                 Image.AlignRight : Image.AlignHCenter

            verticalAlignment: config.BackgroundImageVAlignment == "top" ?
                               Image.AlignTop :
                               config.BackgroundImageVAlignment == "bottom" ?
                               Image.AlignBottom : Image.AlignVCenter

            source: config.background || config.Background
            fillMode: config.ScaleImageCropped == "true" ? Image.PreserveAspectCrop : Image.PreserveAspectFit
            asynchronous: true
            cache: true
            clip: true
            mipmap: true
        }

        MouseArea {
            anchors.fill: backgroundImage
            onClicked: parent.forceActiveFocus()
        }

        ShaderEffectSource {
            id: blurMask

            sourceItem: backgroundImage
            height: parent.height * config.blur_height
            width: parent.width * config.blur_width

            anchors.horizontalCenter: parent.left
            anchors.verticalCenter: parent.top
            anchors.horizontalCenterOffset: get_horizontal_offset(config.blur_horizontal_alignment, config.blur_horizontal_offset)
            anchors.verticalCenterOffset: get_vertical_offset(config.blur_vertical_alignment, config.blur_vertical_offset)

            sourceRect: Qt.rect(x,y,width,height)
            visible: config.blur_visible.toLowerCase() === "true"
        }

        
        
        
        // blur_visible=false
        // blur_horizontal_offset=0
        // blur_horizontal_alignment="center"
        // # '-> Possible values: left/center/right
        // blur_vertical_offset=0
        // blur_vertical_alignment="center"
        // # '-> Possible values: top/center/bottom
        // blur_width=1
        // blur_height=1
        // # '-> Both sizes are fraction of the screen (1 = full screen)
        GaussianBlur {
            id: blur
            height: blurMask.height
            width: blurMask.width
            anchors.horizontalCenter: blurMask.horizontalCenter
            anchors.verticalCenter: blurMask.verticalCenter
            source: blurMask
            radius: config.blur_strength * 200
            samples: config.blur_strength * 200 * 2 + 1
            cached: true
            visible: config.blur_visible.toLowerCase() === "true"
        }
    }
}
