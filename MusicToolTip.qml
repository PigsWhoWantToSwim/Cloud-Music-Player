// 提示

import QtQuick 2.12
import QtQuick.Window 2.12

Rectangle {
    property alias text: content.text // 提示文本内容
    property int margin: 15

    id:self

    color: "white"
    radius: 4
    width: content.width+20
    height: content.height+20

    anchors{
        // 父控件下边界在屏幕的位置 加上 控件的高度和底边距 不超过 程序窗口的高度，则控件可以放在父控件下面
        top:getGlobalPositon(parent).y+parent.height+margin+height < Window.height? parent.bottom:undefined
        // 父控件下边界在屏幕的位置 加上 控件的高度和底边距 超过了 程序窗口的高度，则控件可以放在父控件上面
        bottom:getGlobalPositon(parent).y+parent.height+margin+height >= Window.height? parent.top:undefined

        left: (width-parent.width)/2 > getGlobalPositon(parent).x? parent.left:undefined
        right:width+getGlobalPositon(parent).x > Window.width? parent.right:undefined

        topMargin: margin
        bottomMargin: margin
    }

    x:(width-parent.width)/2<=parent.x && width+parent.x<=Window.width? (-width+parent.width)/2:0


    Text{ // 文本内容
        id:content
        text: "提示内容"
        lineHeight: 1.2 // 行高
        anchors.centerIn: parent // 居中
        font.family: window.mFONT_FAMILY
    }

    // 获取绝对坐标
    function getGlobalPositon(target=parent){
        var targetX = 0
        var targetY = 0
        while(target !== null){ // 要计算的控件不为空
            targetX += target.x
            targetY += target.y
            target  = target.parent // 一层一层地计算
        }
        return {
            x: targetX,
            y: targetY
        }
    }
}
















