import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtQuick.Window 2.12

// 工具栏
ToolBar{

    property point point: Qt.point(x,y) // 在标题栏里按下的点坐标
    property bool isSmallWindow: false // 是否处于小窗播放

    background: Rectangle{
        color: "#00000000"
    }
    width: parent.width
    Layout.fillWidth: true
    height: 32
    RowLayout{
        anchors.fill: parent

        MusicToolButton{
            iconSource: "qrc:/images/music.png"
            toolTip: "图标"
        }
        MusicToolButton{
            iconSource: "qrc:/images/about.png"
            toolTip: "关于"
            onClicked: {
                aboutPopup.open()
            }
        }
        MusicToolButton{ // 小窗模式按钮
            id: smallWindow
            iconSource: "qrc:/images/small-window.png"
            toolTip: "小窗模式"
            visible: !isSmallWindow // 处于小窗模式时 隐藏
            onClicked: {
                isSmallWindow = true // 小窗模式
                setWindowSize(340, 540) // 调整窗口尺寸

                // 隐藏首页，显示详情页
                pageHomeView.visible = false
                pageDetailView.visible = true

                appBackground.showDefaultBackground =  pageHomeView.visible // 在首页显示 默认背景
            }
        }
        MusicToolButton{
            id: normalWindow
            iconSource: "qrc:/images/exit-small-window.png"
            toolTip: "常规模式"
            visible: isSmallWindow  // 处于小窗模式时 显示
            onClicked: {
                isSmallWindow = false // 常规模式
                setWindowSize()  // 调整窗口尺寸
                appBackground.showDefaultBackground =  pageHomeView.visible // 在首页显示 默认背景
            }
        }
        Item {
            Layout.fillWidth: true
            height: 32
            Text {
                anchors.centerIn: parent
                text: isSmallWindow? qsTr(""):qsTr("Cloud Music Player") // 小窗模式不显示标题
                font.family: window.mFONT_FAMILY
                font.pointSize: 15
                color: "#ffffff"
            }

            // 鼠标事件，用于移动窗口
            MouseArea{
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton // 只接受鼠标左键
                onPressed:  setPoint(mouseX, mouseY) // 鼠标左键按下
                onMouseXChanged: moveX(mouseX) // 左上角x改变
                onMouseYChanged: moveY(mouseY) // 左上角y改变
            }
        }
        MusicToolButton{
            iconSource: "qrc:/images/minimize-screen.png"
            toolTip: "最小化"
            onClicked: {
                window.hide()
            }
        }
        MusicToolButton{
            id: maxWindow
            iconSource: "qrc:/images/full-screen.png"
            toolTip: "最大化"
            onClicked: {
                window.visibility = Window.Maximized
                maxWindow.visible = false
                resize.visible = true
            }
        }
        MusicToolButton{
            id: resize
            iconSource: "qrc:/images/small-screen.png"
            toolTip: "向下还原"
            visible: false
            onClicked: {
                setWindowSize()
                window.visibility = Window.AutomaticVisibility
                resize.visible = false
                maxWindow.visible = true
            }
        }
        MusicToolButton{
            iconSource: "qrc:/images/power.png"
            toolTip: "退出"
            onClicked: {
                Qt.quit()
            }
        }
    }

    // 关于弹窗
    Popup{
        id: aboutPopup

        parent: Overlay.overlay

        x: (parent.width - width) / 2
        y: (parent.height - height) / 2

        width:  250
        height: 230

        background: Rectangle{
            color: "#e9f4ff"
            radius: 5
            border.color: "#2273abab"
        }

        contentItem: ColumnLayout{
            width: parent.width
            height: parent.height
            Layout.alignment: Qt.AlignHCenter

            Image{
                Layout.preferredWidth: 60
                Layout.fillWidth: true
                source: "qrc:/images/music.png"
                fillMode: Image.PreserveAspectFit
            }

            Text {
                text: qsTr("想游泳的猪")
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                color: "#8573a7ab"
                font.family: window.mFONT_FAMILY
                font.pixelSize: 18
                font.bold: true
            }
            Text {
                text: qsTr("Cloud Music Player")
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                color: "#8573a7ab"
                font.family: window.mFONT_FAMILY
                font.pixelSize: 16
                font.bold: true
            }
        }
    }

    // 设置窗口尺寸
    function setWindowSize(width = window.mWINDOW_WIDTH, height = window.mWINDOW_HEIGHT){
        window.width = width
        window.height = height
        window.x = (Screen.desktopAvailableWidth - window.width) / 2
        window.y = (Screen.desktopAvailableHeight - window.height) / 2
    }

    // 设置 坐标
    function setPoint(mouseX =0 ,mouseY = 0){
        point = Qt.point(mouseX,mouseY)
        // console.log(mouseX,mouseY)
    }

    // 窗口沿x轴移动
    function moveX(mouseX = 0 ){
        var x = window.x + mouseX-point.x // 窗口左上角的新x为旧x加上左键按下移动的水平距离
        if(x<-(window.width-70)) // 被隐藏的窗口左侧的宽度 不大于 window.width-70
            x = - (window.width-70)
        if(x>Screen.desktopAvailableWidth-70) // x不超过桌面的Screen.desktopAvailableWidth-70
            x = Screen.desktopAvailableWidth-70
        window.x = x // 移动窗口
    }
    // 窗口沿y轴移动
    function moveY(mouseY = 0 ){
        var y = window.y + mouseY-point.y // 窗口的新y为旧y加上左键按下移动的垂直距离
        if(y<=0) y = 0 // y坐标不小于0

        if(y>Screen.desktopAvailableHeight-70) y = Screen.desktopAvailableHeight-70
        window.y = y // 移动窗口
    }
}
