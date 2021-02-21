import QtQuick 2.15


Rectangle {
    id: block
    color: "transparent"

    property int blockType: 0
    property int snake: 1
    property int food: 2
    property int doublePoints: 3
    property int extraLife: 4

    Image {
        id: blockImage
        visible: false
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        source: "extralife.png"
        height: 0.8 * parent.height
        width: 0.8 * parent.width
    }

    onBlockTypeChanged: {
        if(snake === blockType){
            blockImage.source = "snake.png"
            blockImage.height = 0.9 * block.height
            blockImage.width = 0.9 * block.width
            blockImage.visible = true
        }
        else if(food === blockType) {
            blockImage.source = "lunch.png"
            blockImage.height = 0.8 * block.height
            blockImage.width = 0.8 * block.width
            blockImage.visible = true
        }
        else if(doublePoints === blockType){
            blockImage.source = "doublepoints.png"
            blockImage.height = 0.8 * block.height
            blockImage.width = 0.8 * block.width
            blockImage.visible = true
        }
        else if(extraLife === blockType){
            blockImage.source = "extralife.png"

            blockImage.height = 0.8 * block.height
            blockImage.width = 0.8 * block.width
            blockImage.visible = true
        }
        else {
            blockImage.visible = false
            blockImage.source = ""
        }
    }
}


















