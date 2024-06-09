/** 轮播图控件 **/

import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtQml 2.12

Frame{
    // 当前图片索引、图片列表
    property int current: 0
    property alias bannerList: bannerView.model // 将bannerList 传给 bannerView.model，就是一个json

    background: Rectangle{
        color: "#00000000" // 透明背景
    }

    // 路径控件，可以沿路径拖动控件，且循环
    PathView{
        id:bannerView
        width: parent.width
        height: parent.height

        // 超出尺寸进行 裁剪
        clip: true

        // 子项目
        delegate: Item {
            id:delegateItem
            width: bannerView.width*0.7
            height: bannerView.height
            z:PathView.z?PathView.z:0 // 设置高度
            scale: PathView.scale?PathView.scale:1.0 // 设置缩放

            MusicRoundImage{
                id:image
                imgSrc: modelData.imageUrl
                width: delegateItem.width
                height: delegateItem.height
            }

            // 鼠标区域，用于切换图片和
            MouseArea{
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor // 手形
                onClicked:{ // 点击事件
                    if(bannerView.currentIndex === index) // 点击当前
                    {
                        // 进入播放列表
                        var item = bannerView.model[index]
                        var targetId = item.targetId+"" // json内容有关

                        // 类型
                        // 1：单曲、10：专辑、100：歌手、1000：歌单、1002：用户、1004：MV、
                        // 1006：歌词、1009：电台、1014：视频、1018：综合
                        var targetType = item.targetType+"" // 转为字符串
                        switch(targetType)
                        {
                        case "1": // 单曲----播放
                            layoutBottomView.current = -1
                            layoutBottomView.playList=[{id:targetId,name:"",artist:"",cover:"",album:""}]
                            layoutBottomView.current = 0
                            break;
                        case "10": // 专辑----打开专辑
                        case "1000": // 歌单----打开播放列表
                            pageHomeView.showPlayList(targetId, targetType)
                            break
                        }
                    }
                    else
                    {
                        bannerView.currentIndex = index // 设置选中设为当前
                    }

                }
            }

        }

        pathItemCount: 3 // 可见子项目数量
        path: bannerPath // 设置路径
        // 设置中间强调
        /*preferredHighlightBegin 和 preferredHighlightEnd 属性的值是 real 类型的。
        范围 0.0 至 1.0 。preferredHighlightBegin 指定当前 item 在 view 中的首选起始位置，
        preferredHighlightEnd 指定当前 item 在 view 中的首选结束位置.
        严格地将当前 item 限制在路径的中央，设置 preferredHighlightBegin 和 preferredHighlightEnd 都为 0.5 。*/
        preferredHighlightBegin: 0.5 // 在0.5处开始设置Highlight强调
        preferredHighlightEnd: 0.5 // 在0.5处结束设置Highlight强调

        // 鼠标区域，用于切换图片和
        MouseArea{
            anchors.fill: parent
            hoverEnabled: true // 使能进入
            cursorShape: Qt.PointingHandCursor // 手形
            onEntered: { // 光标进入
                bannerTimer.stop() // 暂停定时器
            }
            onExited: { // 光标离开
                bannerTimer.start() // 启动定时器
            }
        }
    }

    // 路径
    Path{
        id:bannerPath

        // 起点
        startX: 0 // x起点
        startY: bannerView.height/2 - 10

        // 分段属性，属性名称加值
        // 第一段
        PathAttribute{name: "z";value: 0}
        PathAttribute{name: "scale";value: 0.6}

        PathLine{ // 间隔线
            x:bannerView.width/2 // 间隔线x坐标
            y:bannerView.height/2 - 10
        }

        // 第二段
        PathAttribute{name: "z";value: 2}
        PathAttribute{name: "scale";value: 0.85}

        PathLine{ // 间隔线
            x:bannerView.width // 间隔线x坐标
            y:bannerView.height/2 - 10
        }

        // 第三段
        PathAttribute{name: "z";value: 0}
        PathAttribute{name: "scale";value: 0.6}
    }

    // 底部轮播按钮
    PageIndicator{
        id:indicator
        anchors{ // 在centerImage底部，水平放置
            top:bannerView.bottom
            horizontalCenter: parent.horizontalCenter
            topMargin: -10
        }
        count: bannerView.count // 设置按钮数量
        currentIndex: bannerView.currentIndex // 设置当前索引
        spacing: 10 // 间隔


        // 按钮样式
        delegate: Rectangle{
            width: 20
            height: 5
            radius: 5
            color: index===bannerView.currentIndex?"white":"#55ffffff" // 选中为黑，未选中则为灰
            Behavior on color{ // 颜色变化行为
                ColorAnimation { // 颜色动画
                    duration: 200
                }
            }

            // 鼠标区域，用于切换图片和
            MouseArea{
                anchors.fill: parent
                hoverEnabled: true // 使能进入
                cursorShape: Qt.PointingHandCursor // 手形
                onEntered: { // 光标进入
                    bannerTimer.stop() // 暂停定时器
                    bannerView.currentIndex = index // 更改当前图片
                }
                onExited: { // 光标离开
                    bannerTimer.start() // 启动定时器
                }
            }
        }
    }

    // 定时器，用于自动轮播
    Timer{
        id:bannerTimer
        running: true // 默认启动
        interval: 4000 // 时间间隔
        repeat: true // 循环
        onTriggered: { // 到时触发，切换到下一张
            if(bannerView.count > 0)
                // 设置当前图片索引，当前为最后一张则为0，否则为后一张
                bannerView.currentIndex = ((bannerView.currentIndex+1)%bannerView.count)
        }
    }

}








/*** 轮播方法 ***/
/*    // 鼠标区域
    MouseArea{
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor // 手形
        hoverEnabled: true // 使能进入
        onEntered: {
            bannerTimer.stop() // 暂停轮播
        }
        onExited: {
            bannerTimer.start() // 启动轮播
        }
    }

    // 图片
    MusicRoundImage{
        id:leftImage
        width: parent.width*0.6
        height: parent.height*0.8
        anchors{
            left: parent.left
            bottom: parent.bottom
            bottomMargin: 20
        }

        imgSrc: getLeftImgSrc()

        // 图片改变时
        onImgSrcChanged: {
            leftImageAnim.start() // 启动动画
        }

        // 动画
        NumberAnimation{
            id:leftImageAnim
            target: leftImage
            property: "scale" // 缩放
            from: 0.8 // 起始
            to: 1.0 // 到达
            duration: 200 // 持续时间
        }

        // 鼠标区域，用于鼠标相关事件，点击上一张
        MouseArea{
            anchors.fill: parent // 填充
            cursorShape: Qt.PointingHandCursor
            onClicked: { // 点击事件
                if(bannerList.length > 0)
                    // 设置当前图片索引，当前为0则为最后一张，否则为前一张
                    current = current==0? current.length-1:current-1
            }
        }
    }

    MusicRoundImage{
        id:centerImage
        width: parent.width*0.6
        height: parent.height
        z:2 // 堆叠，在上层
        anchors.centerIn: parent
        imgSrc: getCenterImgSrc()

        // 图片改变时
        onImgSrcChanged: {
            centerImageAnim.start() // 启动动画
        }
        // 动画
        NumberAnimation{
            id:centerImageAnim
            target: centerImage
            property: "scale" // 缩放
            from: 0.8 // 起始
            to: 1.0 // 到达
            duration: 200 // 持续时间
        }

        // 鼠标区域，用于鼠标悬停
        MouseArea{
            anchors.fill: parent // 填充
            cursorShape: Qt.PointingHandCursor
        }
    }

    MusicRoundImage{
        id:rightImage
        width: parent.width*0.6
        height: parent.height*0.8
        anchors{
            right: parent.right
            bottom: parent.bottom
            bottomMargin: 20
        }
        imgSrc: getRightImgSrc()

        // 图片改变时
        onImgSrcChanged: {
            rightImageAnim.start() // 启动动画
        }
        // 动画
        NumberAnimation{
            id:rightImageAnim
            target: rightImage
            property: "scale" // 缩放
            from: 0.8 // 起始
            to: 1.0 // 到达
            duration: 200 // 持续时间
        }

        // 鼠标区域，用于鼠标相关事件，点击下一张
        MouseArea{
            anchors.fill: parent // 填充
            cursorShape: Qt.PointingHandCursor
            onClicked: { // 点击事件
                if(bannerList.length > 0)
                    // 设置当前图片索引，当前为最后一张则为0，否则为后一张
                    current = current==current.length-1? 0:current+1 // 为什么会自动更新？？？？？？？？？？？？？？？？？？
            }
        }
    }

    // 底部轮播按钮
    PageIndicator{
        anchors{ // 在centerImage底部，水平放置
            top:centerImage.bottom
            horizontalCenter: parent.horizontalCenter
        }
        count: bannerList.length // 设置按钮数量
        interactive: true
        onCurrentIndexChanged: { // 选中按钮改变，当前图片也改变
            current = currentIndex
        }
        // 按钮样式
        delegate: Rectangle{
            width: 20
            height: 5
            radius: 5
            color: current==index?"black":"gray" // 选中为黑，未选中则未灰
            // 鼠标区域
            MouseArea{
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor // 手形
                hoverEnabled: true // 使能进入
                onEntered: {
                    bannerTimer.stop() // 暂停轮播
                    current = index // 更改当前图片
                }
                onExited: {
                    bannerTimer.start() // 启动轮播
                }
            }
        }
    }

    // 定时器，自动轮播
    Timer{
        id:bannerTimer
        interval: 5000 // 时间间隔
        running: true // 默认启动
        repeat: true // 循环
        onTriggered: { // 到时触发，切换到下一张
            if(bannerList.length > 0)
                // 设置当前图片索引，当前为最后一张则为0，否则为后一张
                current = current==current.length-1? 0:current+1
        }
    }



    // 获取图片
    function getLeftImgSrc()
    {
        // 注意看json的结构
        // 当前轮播图片列表不为空，返回当前图片的前一张
        // 当前为0，换到最后一张
        return bannerList.length? bannerList[(current-1 + bannerList.length)%bannerList.length].imageUrl:""
    }

    function getCenterImgSrc()
    {
        // 当前轮播图片列表不为空，返回当前图片
        return bannerList.length? bannerList[current].imageUrl:""
    }

    function getRightImgSrc()
    {
        // 当前轮播图片列表不为空，返回当前图片的下一张
        // 当前为最后一张，换到第0张
        return bannerList.length? bannerList[(current+1 + bannerList.length)%bannerList.length].imageUrl:""
    }*/




