// 圆角图片
import QtQuick 2.12
import QtQuick.Controls 2.5
import Qt5Compat.GraphicalEffects

Item {
    property string imgSrc: "qrc:/images/player" // 图片路径
    property int borderRadius: 5 // 圆角大小

    // 图片
    Image {
        id: image
        anchors.centerIn: parent
        source: imgSrc
        smooth: true
        visible: false
        width: parent.width
        height: parent.height
        fillMode: Image.PreserveAspectCrop
        antialiasing: true
    }

    // 圆角矩形，用于遮罩
    Rectangle{
        id: mask
        color: "#000000"
        anchors.fill: parent
        radius: borderRadius
        visible: false
        smooth: true
        antialiasing: true
    }

    // 遮罩
    OpacityMask{
        anchors.fill: image
        source: image
        maskSource: mask // 用于遮罩的矩形
        visible: true
        antialiasing: true
    }
}











