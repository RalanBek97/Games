import QtQuick 2.15
import "chessmoves.js" as ChessMoves

Image {
    id: blockImage
    visible: true

    property var coordinates: []
    property var pieceType: 0
    // 0 none
    // 1 white pawn
    // 2 white rook
    // 3 white knight
    // 4 white bishop
    // 5 white queen
    // 6 white king

    // 7 black pawn
    // 8 black rook
    // 9 black knight
    // 10 black bishop
    // 11 black queen
    // 12 black king

    property var blockSize: parent.width / 8



    height: blockSize * 0.8
    width: blockSize * 0.8

    fillMode: Image.PreserveAspectFit

    Drag.active: dragArea.drag.active

    MouseArea {
        id: dragArea
        anchors.fill: parent

        drag.target: parent


        onPressed: {
            var pm = ChessMoves.possibleMoves(blockImage.coordinates)
            ChessMoves.highlightBlocks(pm)
        }

        onReleased: {
            var newX = Math.floor((blockImage.x + parent.width/8)  / blockImage.parent.width * 8)
            var newY = Math.floor((blockImage.y + parent.width/8) / blockImage.parent.width * 8)

            if(ChessMoves.validate(newY, newX, blockImage.pieceType, blockImage.coordinates)){
                blockImage.coordinates = [newY, newX]
                ChessMoves.calculateAllMoves()
            }
            else {
                blockImage.y = blockImage.blockSize * blockImage.coordinates[0] + (blockImage.blockSize - blockImage.width) / 2
                blockImage.x = blockImage.blockSize * blockImage.coordinates[1] + (blockImage.blockSize - blockImage.width) / 2
            }
            ChessMoves.clearHighlights()
            ChessMoves.possible = []
        }

    }


    onPieceTypeChanged: {
        if(pieceType === 0) { // BASIC
            blockImage.visible = false
            blockImage.source = ""
        }
        else if(pieceType < 7) { // WHITE
            if(pieceType === 1){ // WHITE PAWN
                blockImage.visible = true
                blockImage.source = "qrc:/Pieces/WPawn.png"
            }
            else if(pieceType === 2) { // WHITE ROOK
                blockImage.visible = true
                blockImage.source = "qrc:/Pieces/WRook.png"
            }
            else if(pieceType === 3) { // WHITE KNIGHT
                blockImage.visible = true
                blockImage.source = "qrc:/Pieces/WKnight.png"
            }
            else if(pieceType === 4) { // WHITE BISHOP
                blockImage.visible = true
                blockImage.source = "qrc:/Pieces/WBishop.png"
            }
            else if(pieceType === 5) { // WHITE QUEEN
                blockImage.visible = true
                blockImage.source = "qrc:/Pieces/WQueen.png"
            }
            else if(pieceType === 6) { // WHITE KING
                blockImage.visible = true
                blockImage.source = "qrc:/Pieces/WKing.png"
            }
        }
        else {
            if(pieceType === 7){ // BLACK PAWN
                blockImage.visible = true
                blockImage.source = "qrc:/Pieces/BPawn.png"
            }
            else if(pieceType === 8) { // BLACK ROOK
                blockImage.visible = true
                blockImage.source = "qrc:/Pieces/BRook.png"
            }
            else if(pieceType === 9) { // BLACK KNIGHT
                blockImage.visible = true
                blockImage.source = "qrc:/Pieces/BKnight.png"
            }
            else if(pieceType === 10) { // BLACK BISHOP
                blockImage.visible = true
                blockImage.source = "qrc:/Pieces/BBishop.png"
            }
            else if(pieceType === 11) { // BLACK QUEEN
                blockImage.visible = true
                blockImage.source = "qrc:/Pieces/BQueen.png"
            }
            else if(pieceType === 12) { // BLACK KING
                blockImage.visible = true
                blockImage.source = "qrc:/Pieces/BKing.png"
            }
        }
        height = blockSize * ((pieceType === 1 || pieceType === 7) ? 0.6 : 0.8)
        width = blockSize * ((pieceType === 1 || pieceType === 7) ? 0.6 : 0.8)
        y = blockSize * coordinates[0] + (blockSize - width) / 2
        x = blockSize * coordinates[1] + (blockSize - width) / 2
    }

    onCoordinatesChanged: {
        y = blockSize * coordinates[0] + (blockSize - width) / 2
        x = blockSize * coordinates[1] + (blockSize - width) / 2
    }

    onBlockSizeChanged: {

        height = blockSize * ((pieceType === 1 || pieceType === 7) ? 0.6 : 0.8)
        width = blockSize * ((pieceType === 1 || pieceType === 7) ? 0.6 : 0.8)
        y = blockSize * coordinates[0] + (blockSize - width) / 2
        x = blockSize * coordinates[1] + (blockSize - width) / 2

    }
}


























