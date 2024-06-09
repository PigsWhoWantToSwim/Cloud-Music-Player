// 消息通知

import QtQuick 2.12
import Qt5Compat.GraphicalEffects
import QtQml 2.12

Item {
    property Item parentWindow: parent // 父控件
    id:self

    visible: false // 默认不显示
    scale: visible // 缩放

    width: 360
    height: 50

    anchors{
        top:parentWindow.top // 顶部对齐
        topMargin: 45
        horizontalCenter: parentWindow.horizontalCenter // 水平居中
    }

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
        color: "#03a9f4"
        radius: 5
        anchors.fill: parent

        // 消息内容
        Text{
            id:content
            text:"Notification..."
            color: "#eeffffff"
            font{
                family: window.mFONT_FAMILY
                pointSize: 11
            }
            width: 350
            lineHeight: 25 // 行高
            lineHeightMode: Text.FixedHeight // 固定行高
            wrapMode: Text.WordWrap // 折行
            anchors{
                left:parent.left
                leftMargin: 10
                verticalCenter: parent.verticalCenter // 垂直居中
            }
        }

        // 按钮
        MusicIconButton{
            iconSource: "qrc:/images/clear"
            iconWidth: 16
            iconHeight: 16
            toolTip: "关闭"
            anchors{
                right: parent.right
                rightMargin: 10
                verticalCenter: parent.verticalCenter // 垂直居中
            }
            onClicked: close()
        }
    }

    Behavior on scale { // 缩放效果的具体行为
        NumberAnimation{ // 数字动画
            easing.type: Easing.InOutQuad // 动画的缓动曲线
            duration: 100 // 持续
        }
    }

    Timer{ // 定时器
        id:timer
        interval: 3000 // 时间间隔
        onTriggered: close()
    }

    // 打开
    function open(text="Notification..."){
        close()
        content.text = text // 设置通知文本内容
        visible = true // 显示
        timer.start() // 启动定时器

    }

    // 打开成功
    function openSuccess(text="Notification..."){
        rect.color = "#4caf50"
        open(text)
    }
    // 打开错误
    function openError(text="Notification..."){
        rect.color = "#ff5252"
        open(text)
    }
    // 打开警告
    function openWarning(text="Notification..."){
        rect.color = "#f57c00"
        open(text)
    }
    // 打开信息
    function openInfo(text="Notification..."){
        rect.color = "#03a9f4"
        open(text)
    }

    // 关闭消息
    function close(){
        visible = false // 隐藏
        timer.stop() // 停止定时器
    }
}











