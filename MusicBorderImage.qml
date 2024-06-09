// 带边框的圆角图片
import QtQuick 2.12
import QtQuick.Controls 2.5
import Qt5Compat.GraphicalEffects

Rectangle {
    property string imgSrc: "qrc:/images/player" // 图片路径
    property int borderRadius: 5 // 圆角大小
    property bool isRotating: false // 是否旋转
    property real rotationAngel: 0.0 // 起始角度

    // 矩形的圆角
    radius:borderRadius

    gradient: Gradient{ // 渐变
        GradientStop{
            position: 0.0 // 0.0 起点处颜色
            color: "#101010"
        }
        GradientStop{
            position: 0.5 // 0.5 中间点处颜色
            color: "#a0a0a0"
        }
        GradientStop{
            position: 1.0 // 1.0 终点处颜色
            color: "#505050"
        }
    }

    // 图片
    Image {
        id: image
        anchors.centerIn: parent
        source: imgSrc
        smooth: true
        visible: false
        width: parent.width*0.9 // 比渐变背景小，出现边框效果
        height: parent.height*0.9
        fillMode: Image.PreserveAspectCrop
        antialiasing: true
    }

    // 圆角矩形，用于遮罩层的蒙版
    Rectangle{
        id: mask
        color: "#000000" // 黑色部分显示
        anchors.fill: parent
        radius: borderRadius // 设置圆角，成为圆形
        visible: false
        smooth: true
        // border.width: 20
        // border.color: "white"
        antialiasing: true
    }

    // 遮罩
    OpacityMask{ // 遮罩层
        id:maskImage
        anchors.fill: image
        source: image // 要设置遮罩的控件
        maskSource: mask // 用于遮罩的圆角矩形
        visible: true
        antialiasing: true
    }

    // 动画 用于旋转图片
    NumberAnimation{ // 某一值做动画变化
        running: isRotating // 是否启动
        loops:Animation.Infinite // 无限重复
        target: maskImage // 要旋转的目标
        from: rotationAngel
        to: 360+rotationAngel // 旋转360°
        property: "rotation" // 要rotation 发生变化
        duration: 100000 // 100s一圈
        onStopped: {
            rotationAngel = maskImage.rotation
        }
    }
}




















