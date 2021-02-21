var moveHistory = []
var possible = []

function validate(newY, newX, type, old){
    for(var x in possible){
        if(possible[x][0] === newY && possible[x][1] === newX){
            if(boardBlocks[newY][newX].pieceType !== 0){
                removePiece(newY, newX, boardBlocks[newY][newX].pieceType)
            }

            boardBlocks[newY][newX].pieceType = type
            boardBlocks[old[0]][old[1]].pieceType = 0

            moveHistory.push([newY, newX, old[0], old[1]])

            return true
        }
    }
    return false
}

function possibleMoves(coordinates){
    var type = boardBlocks[coordinates[0]][coordinates[1]].pieceType
    var pm = []
    if(type === 0) return
    if(type < 7){
        switch(type){
            case 1:
                pm = pawn(1, coordinates)
                break
            case 2:
                pm = rook(0, coordinates)
                break
            case 3:
                pm = knight(0, coordinates)
                break
            case 4:
                pm = bishop(0, coordinates)
                break
            case 5:
                pm = queen(0, coordinates)
                break
            case 6:
                pm = king(0, coordinates)
                break

        }
    }
    else {
        switch(type){
            case 7:
                pm =  pawn(-1, coordinates)
                break
            case 8:
                pm = rook(1, coordinates)
                break
            case 9:
                pm = knight(1, coordinates)
                break
            case 10:
                pm = bishop(1, coordinates)
                break
            case 11:
                pm = queen(1, coordinates)
                break
            case 12:
                pm = king(1, coordinates)
                break

        }
    }
    return pm
}

function pawn(side, coordinates){
    possible = []

    if(boardBlocks[Number(coordinates[0]) + 1 * side][coordinates[1]].pieceType === 0){
        possible.push([Number(coordinates[0]) + 1 * side, coordinates[1]])

        if((coordinates[0] === 1 && side === 1 || coordinates[0] === 6 && side === -1) && boardBlocks[Number(coordinates[0]) + 2 * side][coordinates[1]].pieceType === 0){
            possible.push([Number(coordinates[0]) + 2 * side, coordinates[1]])
        }
    }

    var piece
    if(Number(coordinates[1]) + 1 < 8){
        piece = boardBlocks[Number(coordinates[0]) + 1 * side][Number(coordinates[1]) + 1].pieceType
        var range = ((side === -1) ? 0 : 6)
        if(piece !== 0 && piece > range && piece <= range + 6){
            possible.push([Number(coordinates[0]) + 1 * side, Number(coordinates[1]) + 1])
        }
    }
    if(Number(coordinates[1]) - 1 > -1 ){
        piece = boardBlocks[Number(coordinates[0]) + 1 * side][Number(coordinates[1]) - 1].pieceType
        if(piece !== 0 && piece > range && piece <= range + 6){
            possible.push([Number(coordinates[0]) + 1 * side, Number(coordinates[1]) - 1])
        }
    }
    // add en passanr rule using prev move log
    //if((coordinates[0] === 5 && side === 1 || coordinates[0] ===  3 && side === -1) && boardBlocks[coordinates[0]][Number(coordinates[1]) + 1].pieceType % 6 === 1 && boardBlocks[Number(coordinates[0]) + 1 * side][Number(coordinates[1]) + 1].pieceType === 0){}

    return possible

}

function rook(side, coordinates){
    var poss = [[1, 0], [-1, 0], [0, 1], [0, -1]]

    return multiples(poss, coordinates, (Number(side) + 1) % 2)

}

function knight(side, coordinates){
    var poss = [[2, 1], [2, -1], [-2, 1], [-2, -1], [1, 2], [1, -2], [-1, 2], [-1, -2]]
    possible = []
    var coY
    var coX
    var oponent = (Number(side) + 1) % 2
    for(var x in poss){
        coY = coordinates[0] + poss[x][0]
        coX = coordinates[1] + poss[x][1]
        console.log(coY, coX)
        if(coY > 7 || coX > 7 || coY < 0 || coX < 0){
        }
        else if(boardBlocks[coY][coX].pieceType !== 0) {
            if(boardBlocks[coY][coX].pieceType > oponent * 6 && boardBlocks[coY][coX].pieceType <= oponent * 6 + 6){
                possible.push([coY, coX])
            }
        }
        else {
            possible.push([coY, coX])
        }
    }
    return possible
}

function bishop(side, coordinates){
    var poss = [[1, 1], [1, -1], [-1, 1], [-1, -1]]

    return multiples(poss, coordinates, (Number(side) + 1) % 2)

}

function queen(side, coordinates){
    var poss = [[1, 1], [1, -1], [-1, 1], [-1, -1], [1, 0], [-1, 0], [0, 1], [0, -1]]

    return multiples(poss, coordinates, (Number(side) + 1) % 2)
}

function king(side, coordinates){

    var forbidden = []
    if(side === 0){
        for(var a in black){
            if(black[a].pieceType !== 12){
                forbidden.push(possibleMoves(black[a].coordinates))
            }
        }
    }

    possible = []

    var poss = [[1, 1], [1, -1], [-1, 1], [-1, -1], [1, 0], [-1, 0], [0, 1], [0, -1]]
    var coY
    var coX
    var oponent = (Number(side) + 1) % 2

    for(var x in poss){
        coY = coordinates[0] + poss[x][0]
        coX = coordinates[1] + poss[x][1]
        var incl = false
        for(var meh in forbidden){
            for(var ok in forbidden[meh])
            if(forbidden[meh][ok][0] === coY && forbidden[meh][ok][1] === coX){
                incl = true
            }
        }

        if(coY < 8 && coY > -1 && coX < 8 && coX > -1 && !incl){
            if(boardBlocks[coY][coX].pieceType !== 0){
                if(boardBlocks[coY][coX].pieceType > oponent * 6 && boardBlocks[coY][coX].pieceType <= oponent * 6 + 6){
                    possible.push([coY, coX])
                }
            }
            else {
                possible.push([coY, coX])
            }
        }
    }
    return possible
}

function clearHighlights(){
    for(var y in boardBlocks){
        for(var x in boardBlocks[y]){
            boardBlocks[y][x].removeHighlight()
        }
    }
}


function removePiece(y, x, type){
    if(type < 7){
        for(var i in white){
            if(y === white[i].coordinates[0] && x === white[i].coordinates[1]){
                white[i].pieceType = 0
                white[i].coordinates = [-1, -1]
            }
        }
    }
    else {
        for(i in black){
            if(y === black[i].coordinates[0] && x === black[i].coordinates[1]){
                black[i].pieceType = 0
                black[i].coordinates = [-1, -1]
            }
        }

    }
}


function multiples(poss, coordinates, oponent){
    var coY
    var coX
    var count

    possible = []

    for(var x in poss){
        count = 1
        coY = coordinates[0] + poss[x][0] * count
        coX = coordinates[1] + poss[x][1] * count
        while(coY < 8 && coY > -1 && coX < 8 && coX > -1){
            if(boardBlocks[coY][coX].pieceType !== 0){
                if(boardBlocks[coY][coX].pieceType > oponent * 6 && boardBlocks[coY][coX].pieceType <= oponent * 6 + 6){
                    possible.push([coY, coX])
                }
                break
            }
            else {
                possible.push([coY, coX])
            }
            count++
            coY = coordinates[0] + poss[x][0] * count
            coX = coordinates[1] + poss[x][1] * count
        }
    }
    return possible
}

function calculateAllMoves(){
    var allWhiteMoves = []
    var allBlackMoves = []

    for(var m in black){
        if(black[m].pieceType === 12) {//KING
            break
        }
    }

    for(var n in white){
        if(white[n].pieceType === 6) {//KING
            break
        }
    }

    for(var x in white){
        if(white[x].coordinates[0] !== -1 && white[x].coordinates[1] !== -1 && n !== x){
            allWhiteMoves = possibleMoves(white[x].coordinates)
            for(var a in allWhiteMoves){
                if(allWhiteMoves[a][0] === black[m].coordinates[0] && allWhiteMoves[a][1] === black[m].coordinates[1]){
                    check(1, m)
                }
            }
        }
    }



    for(var y in black){
        if(black[y].coordinates[0] !== -1 && black[y].coordinates[1] !== -1 && m !== x){
            allBlackMoves = possibleMoves(black[y].coordinates)
            for(var b in allBlackMoves){
                if(allBlackMoves[b][0] === white[n].coordinates[0] && allBlackMoves[b][1] === white[n].coordinates[1]){
                    check(0, n)
                }
            }
        }
    }

    console.log(allWhiteMoves)
    console.log(allBlackMoves)
}


function highlightBlocks(pm){
    for(var x in pm){
        boardBlocks[pm[x][0]][pm[x][1]].highlight()
    }
}


function check(side, posKing){
    var pm = []
    if(side === 0){
        pm = king(0, white[posKing].coordinates)

        if(pm.length === 0){
            console.log("game over")
        }
    }
    else {
        pm = king(1, black[posKing].coordinates)

        if(pm.length === 0){
            console.log("game over")
        }
    }
}












