var maxCol = 30
var maxRow = 16
var board
var component
var gameEnd = true
var direction = 0
var snakeLength
var snakeLoc = []
var elLoc = []
var dpLoc = []
var bExtraLife
var iDouble
var extraLifeAdded
var doublePointsAdded
var directionChange

const SNAKE = 1
const FOOD = 2
const DOUBLEPOINTS = 3
const EXTRALIFE = 4
const BASIC  = 0

function startNewGame() {

    snakeLoc = []
    direction = 0
    popup.close()


    for(var x in board){
        for(var y in board[x]){
            board[x][y].destroy()
        }
    }

    maxCol = Math.floor(playArea.width / playArea.blockSize)
    maxRow = Math.floor(playArea.height / playArea.blockSize)

    board = new Array(maxCol)

    for(var col = 0; col < maxCol; col++){
        board[col] = new Array(maxRow)
        for(var row = 0; row < maxRow; row++){
            board[col][row] = null;
            createBlock(col, row)
        }
    }

    gameEnd = false
    snakeLength = 3

    var startCol =  Math.floor(Math.random() * maxCol)
    var startRow =  Math.floor(Math.random() * (maxRow - 6) + 2)
    for(var i = 0; i < snakeLength; i++){
        board[startCol][startRow - i].blockType = SNAKE
        snakeLoc.push([startCol, startRow - i])
    }
    addFood()
    bExtraLife = false
    iDouble = 1

    directionChange = false

    extraLifeAdded = false
    doublePointsAdded = false

    timer.running = true
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
            board[col][row] = dynamicObj
        }
        else {
            console.log("error loading block component")
            console.log(component.errorString())
            return false
        }
        return true
}

function turnLeft(){
    if(direction === 1 || direction === 3 || directionChange) return
    else{
        direction = 1
        directionChange = true
    }
}

function turnRight(){
    if(direction === 1 || direction === 3 || directionChange) return
    else {
        direction = 3
        directionChange = true
    }
}

function turnDown(){
    if(direction === 0 || direction === 2 || directionChange) return
    else {
        direction = 0
        directionChange = true
    }
}

function turnUp(){
    if(direction === 0 || direction === 2 || directionChange) return
    else{
        direction = 2
        directionChange = true
    }
}

function move(){

    var tempLoc

    if(direction === 0){

        tempLoc = [snakeLoc[0][0], Number(snakeLoc[0][1]) + 1]
    }
    else if(direction === 1){

        tempLoc = [snakeLoc[0][0] - 1, snakeLoc[0][1]]
    }
    else if(direction === 2){

        tempLoc = [snakeLoc[0][0], snakeLoc[0][1] - 1]
    }
    else {

        tempLoc = [Number(snakeLoc[0][0]) + 1, snakeLoc[0][1]]
    }

    for(var i in snakeLoc){
        if(snakeLoc[i][0] === tempLoc[0] && snakeLoc[i][1] === tempLoc[1]) {
            endGame()
            return
        }
    }

    snakeLoc.unshift(tempLoc)


    if(snakeLoc[0][0] < 0 || snakeLoc[0][0] >= maxCol || snakeLoc[0][1] < 0 || snakeLoc[0][1] >= maxRow){
        endGame()
    }
    else {
        if(board[snakeLoc[0][0]][snakeLoc[0][1]].blockType !== FOOD){
            var loc = snakeLoc.pop()
            board[loc[0]][loc[1]].blockType = BASIC

            if(board[snakeLoc[0][0]][snakeLoc[0][1]].blockType === DOUBLEPOINTS){
                iDouble = 2
                timerDP.countDP = 0
                textDP.text = "Double Points: " + (10 - timerDP.countDP)
                timerDP.running = true
                timerDPSpawn.running = false
                doublePointsAdded = false
            }

            if(board[snakeLoc[0][0]][snakeLoc[0][1]].blockType === EXTRALIFE){
                bExtraLife = true
                timerEL.countEL = 0
                textEL.text = "Extra Life: " + (5 - timerEL.countEL)
                timerEL.running = true
                timerELSpawn.running = false
                extraLifeAdded = false
            }
        }
        else{
            addFood()
            playArea.score += 5 * iDouble
            if(Math.random() < 0.08 && !extraLifeAdded){
                addExtraLife()
            }
            if(Math.random() < 0.08 && !doublePointsAdded){
                addDoublePoints()
            }
        }

        board[snakeLoc[0][0]][snakeLoc[0][1]].blockType = SNAKE
    }
    directionChange = false
}

function addFood(){

    var randomCol = Math.floor(Math.random() * maxCol)
    var randomRow = Math.floor(Math.random() * maxRow)
    while(board[randomCol][randomRow].blockType !== BASIC){
        randomCol = Math.floor(Math.random() * maxCol)
        randomRow = Math.floor(Math.random() * maxRow)
    }
    board[randomCol][randomRow].blockType = FOOD
}

function endGame(){
    timerDP.running = false
    textDP.text = ""
    if(bExtraLife){
        startNewGame()
        textEL.text = ""
        timerEL.running = false
        return
    }
    timer.running = false
    gameEnd = true
    popup.open()
}

function addExtraLife(){
    var randomCol = Math.floor(Math.random() * maxCol)
    var randomRow = Math.floor(Math.random() * maxRow)
    while(board[randomCol][randomRow].blockType !== BASIC){
        randomCol = Math.floor(Math.random() * maxCol)
        randomRow = Math.floor(Math.random() * maxRow)
    }
    board[randomCol][randomRow].blockType = EXTRALIFE
    elLoc.push([randomCol, randomRow])
    timerELSpawn.running = true
    extraLifeAdded = true
}

function addDoublePoints(){
    var randomCol = Math.floor(Math.random() * maxCol)
    var randomRow = Math.floor(Math.random() * maxRow)
    while(board[randomCol][randomRow].blockType !== BASIC){
        randomCol = Math.floor(Math.random() * maxCol)
        randomRow = Math.floor(Math.random() * maxRow)
    }
    board[randomCol][randomRow].blockType = DOUBLEPOINTS
    dpLoc.push([randomCol, randomRow])
    timerDPSpawn.running = true
    doublePointsAdded = true
}


function roundTo(x, y){
    var factor = Math.pow(10, y)

    return Math.round(x * factor) / factor
}

function removeExtraLife(){
    board[elLoc[0][0]][elLoc[0][1]].blockType = BASIC
    elLoc.shift()
    extraLifeAdded = false
}

function removeDoublePoints(){
    board[dpLoc[0][0]][dpLoc[0][1]].blockType = BASIC
    dpLoc.shift()
    doublePointsAdded = false
}
