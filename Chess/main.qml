import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Dialogs 1.3
import "chessmoves.js" as ChessMoves
import "chessai.js" as ChessAI

Window {
    id: screen
    height: 640
    width: height / 0.8

    visible: true
    title: qsTr("Chess v0.1")
    color: "#252525"


    property var block: Qt.createComponent("Block.qml")
    property var boardBlocks: []
    property var temp: []

    property var piece: Qt.createComponent("Piece.qml")
    property var white: []
    property var black: []



    Item {
        id: playArea
        width: parent.height
        height: parent.height
        anchors.left: parent.left
        anchors.bottom: parent.bottom
    }

    onHeightChanged: {
        resizeBoard()
    }



    function fillBoard(){
        playArea.width = screen.height
        playArea.height = screen.height
        boardBlocks = []
        for(var x = 0; x < 8; x++){
            temp = []
            for(var y = 0; y < 8; y++){
                temp.push(block.createObject(playArea))
                temp[y].width = playArea.height / 8
                temp[y].height = playArea.height / 8
                temp[y].y = playArea.height / 8 * x
                temp[y].x = playArea.height / 8 * y
                if((y + x) % 2 === 0){
                    temp[y].color = "#4E5F6E"
                }
                else {
                   temp[y].color = "#6E5D4E"
                }
            }
            boardBlocks.push(temp)
        }
    }

    function createPieces(){
        for(var x = 0; x < 8; x++){
            white.push(piece.createObject(playArea))
            white[x].coordinates = [1, x]
            white[x].pieceType = 1

            black.push(piece.createObject(playArea))
            black[x].coordinates = [6, x]
            black[x].pieceType = 7

            boardBlocks[1][x].pieceType = 1
            boardBlocks[6][x].pieceType = 7
        }


        white.push(piece.createObject(playArea))
        white[white.length - 1].coordinates = [0, 0]
        white[white.length - 1].pieceType = 2

        white.push(piece.createObject(playArea))
        white[white.length - 1].coordinates = [0, 7]
        white[white.length - 1].pieceType = 2

        boardBlocks[0][0].pieceType = 2
        boardBlocks[0][7].pieceType = 2


        white.push(piece.createObject(playArea))
        white[white.length - 1].coordinates = [0, 1]
        white[white.length - 1].pieceType = 3

        white.push(piece.createObject(playArea))
        white[white.length - 1].coordinates = [0, 6]
        white[white.length - 1].pieceType = 3

        boardBlocks[0][1].pieceType = 3
        boardBlocks[0][6].pieceType = 3



        white.push(piece.createObject(playArea))
        white[white.length - 1].coordinates = [0, 2]
        white[white.length - 1].pieceType = 4

        white.push(piece.createObject(playArea))
        white[white.length - 1].coordinates = [0, 5]
        white[white.length - 1].pieceType = 4

        boardBlocks[0][2].pieceType = 4
        boardBlocks[0][5].pieceType = 4



        white.push(piece.createObject(playArea))
        white[white.length - 1].coordinates = [0, 4]
        white[white.length - 1].pieceType = 5

        white.push(piece.createObject(playArea))
        white[white.length - 1].coordinates = [0, 3]
        white[white.length - 1].pieceType = 6

        boardBlocks[0][4].pieceType = 5
        boardBlocks[0][3].pieceType = 6



        black.push(piece.createObject(playArea))
        black[black.length - 1].coordinates = [7, 0]
        black[black.length - 1].pieceType = 8

        black.push(piece.createObject(playArea))
        black[black.length - 1].coordinates = [7, 7]
        black[black.length - 1].pieceType = 8

        boardBlocks[7][0].pieceType = 8
        boardBlocks[7][7].pieceType = 8



        black.push(piece.createObject(playArea))
        black[black.length - 1].coordinates = [7, 1]
        black[black.length - 1].pieceType = 9

        black.push(piece.createObject(playArea))
        black[black.length - 1].coordinates = [7, 6]
        black[black.length - 1].pieceType = 9

        boardBlocks[7][1].pieceType = 9
        boardBlocks[7][6].pieceType = 9



        black.push(piece.createObject(playArea))
        black[black.length - 1].coordinates = [7, 2]
        black[black.length - 1].pieceType = 10

        black.push(piece.createObject(playArea))
        black[black.length - 1].coordinates = [7, 5]
        black[black.length - 1].pieceType = 10

        boardBlocks[7][2].pieceType = 10
        boardBlocks[7][5].pieceType = 10


        black.push(piece.createObject(playArea))
        black[black.length - 1].coordinates = [7, 4]
        black[black.length - 1].pieceType = 11

        black.push(piece.createObject(playArea))
        black[black.length - 1].coordinates = [7, 3]
        black[black.length - 1].pieceType = 12

        boardBlocks[7][4].pieceType = 11
        boardBlocks[7][3].pieceType = 12

    }

    function resizeBoard(){
        playArea.width = screen.height
        playArea.height = screen.height

        for(var x = 0; x < 8; x++){
            for(var y = 0; y < 8; y++){
                boardBlocks[x][y].width = playArea.height / 8
                boardBlocks[x][y].height = playArea.height / 8
                boardBlocks[x][y].y = playArea.height / 8 * x
                boardBlocks[x][y].x = playArea.height / 8 * y
            }
        }
    }


    Component.onCompleted:  {
        fillBoard()
        createPieces()
    }
}
