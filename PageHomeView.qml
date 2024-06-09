// 首页
import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtQml 2.12

// 行布局
RowLayout{

    property int defaultIndex: 0

    // 间距
    spacing: 0

    // qml页面
    property var qmlList: [
        { icon: "recommend-white.png", value: "推荐内容", qml: "DelailRecommendPageView",menu:true},
        { icon: "cloud-white.png", value: "搜索内容", qml: "DelailSearchPageView",menu:true},
        { icon: "local-white.png", value: "本地音乐", qml: "DelailLocalPageView",menu:true},
        { icon: "history-white.png", value: "播放历史", qml: "DelailHistoryPageView",menu:true},
        { icon: "favorite-big-white.png", value: "我的收藏", qml: "DelailFavoritePageView",menu:true},
        { icon: "", value: "", qml: "DelailPlayListPageView",menu:false}
    ]

    // 左侧导航栏
    Pane {
        Layout.preferredWidth: 200
        Layout.fillHeight: true
        background: Rectangle{
            color: "#1000AAAA"
        }
        padding: 0

        ColumnLayout{ // 列布局
            anchors.fill: parent // 填充父容器
            // Item { // 占位，放置图片
            //     Layout.fillWidth: true
            //     Layout.preferredHeight: 10
            // }


            // Item { // 占位，放置图片
            //     Layout.fillWidth: true
            //     Layout.preferredHeight: 150
            //     MusicRoundImage{
            //         anchors.centerIn: parent
            //         height: 100
            //         width: 100
            //         borderRadius: 100
            //     }
            // }

            ListView{ // 列表，放置导航按钮
                id: menuView // 导航菜单
                height: parent.height
                Layout.fillWidth: true // 填满宽度
                Layout.fillHeight: true // 填满高度
                model: ListModel{ // 列表模式
                    id: menuViewModel
                }
                delegate: menuViewDelegate // 导航按钮
                highlight: Rectangle{ // 导航按钮选中高亮
                    color: "#3073a7ab"
                }
                highlightMoveDuration: 0 // 高亮切换持续时间
                highlightResizeDuration: 0 // 高亮变形持续时间
            }
        }

        Component{ // 导航按钮
            id: menuViewDelegate
            Rectangle{ // 矩形
                id: menuViewDelegateItem
                height: 50
                width: 200

                color: "#00000000"

                RowLayout{ // 行布局
                    anchors.fill: parent // 填充父容器
                    anchors.centerIn: parent // 居中
                    spacing: 15 // 间距
                    Item{ // 占位
                        width: 30
                    }
                    Image { // 导航按钮图标
                        source: "qrc:/images/"+icon
                        Layout.preferredHeight: 20
                        Layout.preferredWidth: 20
                    }
                    Text{ // 导航按钮文本
                        text: value
                        Layout.fillWidth: true
                        height: 50
                        font.family: window.mFONT_FAMILY
                        font.pointSize: 12
                        color: "#ffffff"
                    }
                }

                MouseArea{ // 鼠标区域
                    anchors.fill: parent // 填充父容器
                    hoverEnabled: true // 允许光标悬停
                    onEntered: { // 光标进入
                        color="#aa73a7ab"
                    }
                    onExited: { // 光标离开
                        color="#00000000"
                    }
                    onClicked: { // 鼠标点击
                        hidePlayList() // 先隐藏专辑歌单页面
                        // 将当前按钮索引对应的页面 隐藏
                        repeater.itemAt(menuViewDelegateItem.ListView.view.currentIndex).visible = false
                        // 更新当前索引
                        menuViewDelegateItem.ListView.view.currentIndex = index

                        var loader = repeater.itemAt(index) // 获取当前页面
                        loader.visible = true // 设置 可见性
                        loader.source = qmlList[index].qml+".qml" // 设置 页面资源
                    }
                }
            }
        }

        Component.onCompleted: { // 被加载时
            menuViewModel.append(qmlList.filter(item=>item.menu)) // 导航菜单列表添加 qml列表

            var loader = repeater.itemAt(defaultIndex) // 获取第一个页面，即推荐页面
            loader.visible = true // 设置 可见性
            loader.source = qmlList[defaultIndex].qml+".qml" // 设置 页面资源
            menuView.currentIndex = defaultIndex
        }
    }

    Repeater{
        id: repeater
        model: qmlList.length // 数量filter(item=>item.menu).
        Loader{
            Layout.fillWidth: true
            Layout.fillHeight: true
            visible: false
        }
    }
    
    function showPlayList(targetId="", targetType="10"){ // 默认为专辑
        // 将当前按钮索引对应的页面 隐藏
        repeater.itemAt(menuView.currentIndex).visible = false

        var loader = repeater.itemAt(5) // 获取PlayList页面

        loader.visible = true // 设置 可见

        loader.source = qmlList[5].qml+".qml" // 设置 页面资源
        loader.item.targetType = targetType
        loader.item.targetId = targetId  // id改变，调用 onTargetIdChanged()槽函数

    }
    
    function hidePlayList(){
        // 将当前按钮索引对应的页面 显示
        repeater.itemAt(menuView.currentIndex).visible = true
        
        var loader = repeater.itemAt(5) // 获取PlayList页面
        loader.visible = false // 设置 不可见
    }

}



















