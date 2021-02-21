var maxColumn = 30
var maxRow = 16
var maxIndex = maxColumn * maxRow
var board
var component
var gameEnd = true
var firstClick = false


function startNewGame() {

    timer.running = false
    timerText.text = "0"

    for(var x in board){
        for(var y in board[x]){
            board[x][y].destroy()
        }
    }

    maxColumn = Math.floor(playArea.width / playArea.blockSize)
    maxRow = Math.floor(playArea.height / playArea.blockSize)
    maxIndex = maxRow * maxColumn
    mineText.text = playArea.minesTotal

    board = new Array(maxColumn)

    for(var col = 0; col < maxColumn; col++){
        board[col] = new Array(maxRow)
        for(var row = 0; row < maxRow; row++){
            board[col][row] = null;
            createBlock(col, row)
        }
    }

    gameEnd = false
    firstClick = true

}

function startPresetGame(numRows, numCols) {

    timer.running = false
    timerText.text = "0"
    for(var x in board){
        for(var y in board[x]){
            board[x][y].destroy()
        }
    }

    maxColumn = numCols
    maxRow = numRows
    maxIndex = maxRow * maxColumn

    board = new Array(maxColumn)

    for(var col = 0; col < maxColumn; col++){
        board[col] = new Array(maxRow)
        for(var row = 0; row < maxRow; row++){
            board[col][row] = null;
            createBlock(col, row)
        }
    }

    gameEnd = false
    firstClick = true

}

function createBlock(col, row){
    if(typeof component === 'undefined' || component === null){
        component = Qt.createComponent("Block.qml")
    }

    if(component.status === Component.Ready){
        var dynamicObj = component.createObject(playArea)

        if(dynamicObj === null){
            console.log("error creating block")
            console.log(component.errorString())
            return false
        }
        dynamicObj.x = col * playArea.blockSize
        dynamicObj.y = row * playArea.blockSize
        dynamicObj.width = playArea.blockSize
        dynamicObj.height = playArea.blockSize
        dynamicObj.count = 0
        board[col][row] = dynamicObj
    }
    else {
        console.log("error loading block component")
        console.log(component.errorString())
        return false
    }
    return true
}



function handleLeftClick(xPos, yPos){
    if(gameEnd) return
    var col = Math.floor(xPos / playArea.blockSize)
    var row = Math.floor(yPos / playArea.blockSize)
    if (col >= maxColumn || col < 0 || row >= maxRow || row < 0)
        return;
    if (typeof board[col][row] === 'undefined')
        return;

    if(firstClick) {
        firstClick = false
        addMines(col, row)
        spread(col, row)
        time = 0
        timer.running = true
        return
    }

    if(board[col][row].flagged) return

    if(board[col][row].mine){
        for(var c = 0; c < maxColumn; c++){
            for(var r = 0; r < maxRow; r++){
                board[c][r].lost = true
                gameEnd = true
                timer.running = false
                time = 0
            }
        }
    }
    else{
        spread(col, row)
    }
    gameDone()
}

function handleRightClick(xPos, yPos){
    if(gameEnd || firstClick) return

    var col = Math.floor(xPos / playArea.blockSize)
    var row = Math.floor(yPos / playArea.blockSize)
    if (col >= maxColumn || col < 0 || row >= maxRow || row < 0)
        return;
    if (typeof board[col][row] === 'undefined')
        return;

    if(board[col][row].exposed) return
    board[col][row].flagged = !board[col][row].flagged
    if(board[col][row].flagged) mineText.text = mineText.text - 1
    else mineText.text = Number(mineText.text) + 1
}




function addMines(col, row){
    for(var i = 0; i < playArea.minesTotal; i++){
        var randomRow = Math.floor(Math.random() * maxRow)
        var randomCol = Math.floor(Math.random() * maxColumn)

        while(board[randomCol][randomRow].mine || (randomCol === col && randomRow === row)){
            randomRow = Math.floor(Math.random() * maxRow)
            randomCol = Math.floor(Math.random() * maxColumn)
        }
        board[randomCol][randomRow].count = 0
        board[randomCol][randomRow].mine = true

        addNumbers(randomCol, randomRow)
    }
}

function addNumbers(col, row){

    if(col - 1 >= 0){
        if(!board[col - 1][row].mine) board[col - 1][row].count++

        if(row - 1 >= 0 && !board[col - 1][row - 1].mine){
            board[col - 1][row - 1].count++
        }

        if(row + 1 < maxRow && !board[col - 1][row + 1].mine){
            board[col - 1][row + 1].count++
        }
    }


    if(row - 1 >= 0 && !board[col][row - 1].mine){
        board[col][row - 1].count++
    }

    if(row + 1 < maxRow && !board[col][row + 1].mine){
        board[col][row + 1].count++
    }

    if(col + 1 < maxColumn){

        if(row - 1 >= 0 && !board[col + 1][row - 1].mine){
            board[col + 1][row - 1].count++
        }

        if(!board[col + 1][row].min) board[col + 1][row].count++

        if(row + 1 < maxRow && !board[col + 1][row + 1].mine){
            board[col + 1][row + 1].count++
        }
    }
}

function spread(col, row){
    if(board[col][row].mine) return

    board[col][row].exposed = true
    if(board[col][row].count !== 0) return

    for(var i = Math.max(col - 1, 0); i <= Math.min(col + 1, maxColumn - 1); i++){
        for(var j = Math.max(row - 1, 0); j <= Math.min(row + 1, maxRow - 1); j++){
            if(!board[i][j].exposed){
                spread(i, j)
            }
        }
    }
}

function gameDone(){
    for(var col = 0; col < maxColumn; col++){
        for(var row = 0; row < maxRow; row++){
            if(!board[col][row].exposed && !board[col][row].mine){
                return
            }
        }
    }
    gameEnd = true
    timer.running = false
    popup.open()
    timerText.text = "0"
}


function calculateBlockSize() {
    if(screen.screenHeight > 799){
        playArea.blockSize = 40
    }
    else {
        playArea.blockSize = 30
    }
}





















