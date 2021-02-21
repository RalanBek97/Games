import QtQuick 2.15

Rectangle {
    property var pieceType: 0

    DropArea {
        anchors.fill: parent
    }

    Rectangle {
        id: possibleRect
        visible: false
        width: parent.width
        height: parent.height
        color: "white"
        opacity: 0.2
    }

    function highlight(){
        possibleRect.visible = true
    }

    function removeHighlight(){
        possibleRect.visible = false
    }
}
