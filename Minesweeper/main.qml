import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Dialogs 1.3
import "minesweeper.js" as MineSweeper

Window {
    id: screen
    width: 640
    height: 480
    visible: true
    title: qsTr("Minesweeper v0.1")
    color: "#252525"

    property var screenHeight: Screen.height
    property var time: 0

    Component.onCompleted: {
        console.log(screenHeight)
    }

    FontLoader {
        id: venusRising
        name: "Venus Rising"
        source: "qrc:/venusrising.ttf"
    }

    Rectangle {
        id: toolBar
        width: parent.width
        height: 40
        anchors.bottom: parent.bottom
        color: "#D45500"

        Button {
            id: newGameButton
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width / 4
            text: "New Game"
            font.pointSize: 10
            onClicked: MineSweeper.startNewGame()
            highlighted: true
        }
        Button {
            id: beginnerButton
            anchors.left: newGameButton.right
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width / 4
            text: "Beginner"
            font.pointSize: 10
            onClicked: {
                playArea.blockSize = 40
                playArea.minesTotal = 10
                mineText.text = 10
                screen.width = 320
                screen.height = 320 / 0.8
                MineSweeper.startPresetGame(8, 8)
            }
        }
        Button {
            id: interButton
            anchors.left: beginnerButton.right
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width / 4
            text: "Intermediate"
            font.pointSize: 10
            onClicked: {
                MineSweeper.calculateBlockSize()
                playArea.minesTotal = 40
                mineText.text = 40
                screen.width = 16 * playArea.blockSize
                screen.height = 16 * playArea.blockSize / 0.8
                MineSweeper.startPresetGame(16, 16)
            }
        }
        Button {
            id: expertButton
            anchors.left: interButton.right
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width / 4
            text: "Expert"
            font.pointSize: 10
            onClicked: {
                MineSweeper.calculateBlockSize()
                playArea.minesTotal = 99
                mineText.text = 99
                screen.width = 30 * playArea.blockSize
                screen.height = 16 * playArea.blockSize / 0.8
                MineSweeper.startPresetGame(16, 30)
            }
        }
    }

    Rectangle {
        id: playArea
        width: parent.width
        height: 0.8 * parent.height
        anchors.bottom: toolBar.top
        color: "#252525"
        property var blockSize: 40
        property var minesTotal: 40

        MouseArea {
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            anchors.fill: parent
            onPressed: {

                if(pressedButtons === Qt.LeftButton){
                    MineSweeper.handleLeftClick(mouse.x, mouse.y)
                }
                else if(pressedButtons === Qt.RightButton){
                    MineSweeper.handleRightClick(mouse.x, mouse.y)
                }
            }
        }

    }

    Popup {
        id: popup
        x: Math.round((parent.width - width) / 2)
        y: Math.round((parent.height - height) / 2)
        width: endText.width
        height: endText.height
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        horizontalPadding: 40
        verticalPadding: 20

        background: Rectangle {
            anchors.fill: parent
            color: "#303030"
        }

        Text {
            id: endText
            text: "Well done!\nYour time: " + time + " seconds"
            font.pointSize: 24 * screen.width / 640
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            horizontalAlignment: Text.AlignHCenter
            font.family: venusRising.name
            padding: 20
        }
    }
    Timer {
        id: timer
        interval: 500
        running: false
        repeat: true
        onTriggered: {
            time = time + 0.5
            if(time % 1 === 0) timerText.text = time
        }
    }
    Rectangle {
        id: infoRectangle
        anchors.top: parent.top
        width: parent.width
        height: parent.height - playArea.height - toolBar.height
        color: "transparent"

        Text {
            id: mineText
            anchors.right: infoRectangle.right
            text: playArea.minesTotal
            font.pointSize: parent.height * 0.6
            font.family: venusRising.name
            rightPadding: 30
        }

        Text {
            id: timerText
            anchors.left: infoRectangle.left
            text: "0"
            font.pointSize: parent.height * 0.6
            font.family: venusRising.name
            leftPadding: 30
        }

    }
}
