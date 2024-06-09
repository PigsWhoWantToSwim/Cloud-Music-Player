// 加载控件

import QtQuick 2.12
import Qt5Compat.GraphicalEffects
import QtQml 2.12

Item {
    property Item parentWindow: parent // 父控件
    id:self

    visible: false // 默认不显示
    scale: visible // 缩放

    width: 200
    height: 180

    anchors.centerIn: parentWindow // 居中

    DropShadow{ // 阴影效果
        anchors.fill: rect
        radius: 8
        horizontalOffset: 1 // 水平偏移
        verticalOffset:1 // 垂直偏移
        spread: 16
        color: "#60000000"
        source: rect // 为rect添加阴影
    }

    Rectangle{
        id:rect
        color: "#4003a9f4"
        radius: 5
        anchors.fill: parent

        Image{ // 图片
            id:image
            source: "qrc:/images/loading"
            width: 50
            height: 50
            anchors.centerIn: parent // 居中
            NumberAnimation { // 数字变化引起的动画
                property: "rotation" // 要变化的属性是旋转
                from:0 // 从0开始
                to:360 // 到360
                target: image // 发生变化的目标
                loops:Animation.Infinite // 无限
                running: self.visible // 根据是否显示判断是否运行
                duration: 1000 // 持续
            }
        }

        // 消息内容
        Text{
            id:content
            text:"Loading..."
            color: "#eeffffff"
            font{
                family: window.mFONT_FAMILY
                pointSize: 11
            }


            anchors{
                top:image.bottom // 在图片的下面
                topMargin: 10
                horizontalCenter: parent.horizontalCenter // 水平居中
            }
        }
    }

    // 打开
    function open(){
        visible = true // 显示
    }
    // 关闭消息
    function close(){
        visible = false // 隐藏
    }
}











