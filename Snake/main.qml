import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Dialogs 1.3
import "snake.js" as Snake

Window {
    id: screen
    width: 720
    height: 700
    minimumWidth: width
    maximumWidth: width
    minimumHeight: height
    maximumHeight: height

    visible: true
    title: qsTr("Snake v0.1")
    color: "#252525"

    property var time: 0
    property var iv: 0.5


    FontLoader {
        id: venusRising
        name: "Venus Rising"
        source: "qrc:/venusrising.ttf"
    }

    Rectangle {
        id: toolBar
        width: parent.width
        height: 0.1 * parent.height
        anchors.bottom: parent.bottom
        color: "#D45500"

        Button {
            id: newGameButton
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width / 4
            height: parent.height
            text: "New Game"
            font.pointSize: 10
            onClicked: {
                playArea.focus = true
                playArea.score = 0
                Snake.startNewGame()
            }
            highlighted: true
        }
        Button {
            id: beginnerButton
            anchors.left: newGameButton.right
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width / 4
            height: parent.height
            text: "Slow"
            font.pointSize: 10
            onClicked: {
                iv = 0.3
                playArea.focus = true
            }
        }
        Button {
            id: interButton
            anchors.left: beginnerButton.right
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width / 4
            height: parent.height
            text: "Medium"
            font.pointSize: 10
            onClicked: {
                iv = 0.2
                playArea.focus = true
            }
        }
        Button {
            id: expertButton
            anchors.left: interButton.right
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width / 4
            height: parent.height
            text: "Fast"
            font.pointSize: 10
            onClicked: {
                iv = 0.1
                playArea.focus = true
            }
        }
    }

    Rectangle {
        id: playArea
        focus: true
        width: parent.width
        height: 0.8 * parent.height
        anchors.bottom: toolBar.top
        color: "#252525"
        border.width: 0.5
        border.color: "lightgray"

        property var blockSize: 40
        property var score: 0

        Keys.onPressed: {
            if (event.key === Qt.Key_Left){
                Snake.turnLeft()
            }
            else if(event.key === Qt.Key_Right){
                Snake.turnRight()
            }
            else if(event.key === Qt.Key_Down){
                Snake.turnDown()
            }
            else if(event.key === Qt.Key_Up){
                Snake.turnUp()
            }
            event.accepted = true
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
        onClosed: {
            playArea.focus = true
        }

        Text {
            id: endText
            text: "Well done!\n" + playArea.score
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
        interval: iv * 500
        running: false
        repeat: true
        property var forceMove: false
        onTriggered: {
            time += iv
            forceMove = !forceMove
            if(Snake.directionChange) {
                Snake.move()
                forceMove = true
            }
            else if(forceMove){
                Snake.move()
            }

        }
    }

    Timer {
        id: timerDP
        interval: 1000
        running: false
        repeat: true
        property var countDP

        onTriggered: {
            countDP++
            textDP.text = "Double Points: " + (10 - countDP)

            if(countDP >= 10){
                Snake.iDouble = 1
                running = false
                textDP.text = ""
                countDP = 0
            }
        }
    }

    Timer {
        id: timerEL
        interval: 1000
        running: false
        repeat: true
        property var countEL

        onTriggered: {
            countEL++
            textEL.text = "Extra Life: " + (5 - countEL)
            if(countEL >= 5) {
                Snake.bExtraLife = false
                running = false
                textEL.text = ""
            }
        }
    }

    Timer {
        id: timerELSpawn
        interval: 20000 * iv
        running: false
        repeat: false
        onTriggered: {
            Snake.removeExtraLife()
            console.log("ok")
        }
    }

    Timer {
        id: timerDPSpawn
        interval: 20000 * iv
        running: false
        repeat: false
        onTriggered: {
            Snake.removeDoublePoints()
        }
    }

    Rectangle {
        id: infoRectangle
        anchors.top: parent.top
        width: parent.width
        height: 0.1 * parent.height
        color: "transparent"

        Text {
            id: scoreText
            anchors.right: infoRectangle.right
            text: playArea.score

            font.pointSize: parent.height * 0.6
            font.family: venusRising.name
            rightPadding: 30
        }

        Text {
            id: textEL
            anchors.left: infoRectangle.left
            anchors.top: infoRectangle.top
            topPadding: 0.1 * parent.height
            font.pointSize: parent.height * 0.2
            font.family: venusRising.name
            text: ""
        }

        Text {
            id: textDP
            anchors.left: infoRectangle.left
            anchors.bottom: infoRectangle.bottom
            bottomPadding: 0.1 * parent.height
            font.pointSize: parent.height * 0.2
            font.family: venusRising.name
            text: ""
        }
    }
}

