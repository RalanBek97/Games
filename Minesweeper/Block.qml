import QtQuick 2.15

Rectangle {
    id: block
    property int count: 10
    color: "#D45500"
    property bool mine: false
    property bool lost: false
    property bool exposed: false
    property bool flagged: false

    Text {
        id: blockValue
        text: ""
        font.family: "Helvetica"
        font.pointSize: 24 * (block.width / 40)
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
    }

    Image {
        id: blockImage
        visible: mine
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        height: 0.8 * parent.width
        width: 0.8 * parent.height
    }

    onLostChanged: {
        if(mine && lost){
            blockImage.source = "/mine.png"
            blockImage.visible = true
            blockValue.visible = false
            block.color = "#252525"
            return
        }
    }

    onCountChanged: {

        if(count == 10 || !exposed){
            block.color = "#D45500"
            block.border.width = 0
            blockValue.visible = false
            blockImage.visible = false

            return
        }
    }

    onExposedChanged: {
        blockValue.text = count
        block.color = "#252525"
        block.border.width = 0.5
        block.border.color = "black"

        if(count === 1){
            blockValue.color = "blue"
        }
        else if(count === 2){
            blockValue.color = "green"
        }
        else if(count === 3){
            blockValue.color = "red"
        }
        else if(count === 4){
            blockValue.color = "darkblue"
        }
        else if(count === 5){
            blockValue.color = "maroon"
        }
        else if(count === 6){
            blockValue.color = "darkcyan"
        }
        else if(count === 7){
            blockValue.color = "black"
        }
        else if(count === 8){
            blockValue.color = "gray"
        }

        if(count === 0){
            blockValue.visible = false
            blockImage.visible = false
        }

        else{
            blockValue.visible = true
            blockImage.visible = false
        }
    }

    onFlaggedChanged: {
        if(flagged){
            blockImage.source = "/flag.png"
            blockImage.visible = true
            blockValue.visible = false
        }
        else{
            blockImage.visible = false
        }
    }
}





































