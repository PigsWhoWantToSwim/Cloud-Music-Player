// 推荐页面
import QtQuick 2.12
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.12
import QtQml 2.12

// 滚动布局
ScrollView{
    // 超出范围，进行裁剪
    clip: true
    // 取消滚动条
    ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
    ScrollBar.vertical.policy: ScrollBar.AlwaysOff

    // 垂直布局
    ColumnLayout {
        // 页面标题
        Rectangle{
            Layout.fillWidth: true
            width: parent.width
            height: 50
            color: "#00000000"

            Text {
                x:10
                verticalAlignment: Text.AlignBottom // 垂直方向 底部对齐
                text: qsTr("推荐内容")
                font.family: window.mFONT_FAMILY
                font.pointSize: 18
                color: "#eeffffff"
            }
        }

        // 轮播图控件
        MusicBannerView{
            id:bannerView
            Layout.preferredWidth: window.width-200
            Layout.preferredHeight: (window.width-200)*0.3
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        // 次标题
        Rectangle{
            Layout.fillWidth: true
            width: parent.width
            height: 50
            color: "#00000000"

            Text {
                x:10
                verticalAlignment: Text.AlignBottom // 垂直方向 底部对齐
                text: qsTr("热门歌单")
                font.family: window.mFONT_FAMILY
                font.pointSize: 18

                color: "#eeffffff"
            }
        }

        // 网格热门控件
        MusicGridHotView{
            id:hotView
            Layout.fillWidth: true
            Layout.fillHeight: true
            // 左侧导航栏为200，控件的总间距为50（上下左右均为5，共5个控件）
            // 每一个控件宽度为(window.width - 200 - 50)*0.2，
            // 高度为宽度加文本内容的30
            // 一共有4行
            Layout.preferredHeight: (window.width - 200 - 50)*0.2*4 + 30*4 + 20
            Layout.bottomMargin: 20
        }

        // 次标题
        Rectangle{
            Layout.fillWidth: true
            width: parent.width
            height: 50
            color: "#00000000"

            Text {
                x:10
                verticalAlignment: Text.AlignBottom // 垂直方向 底部对齐
                text: qsTr("新歌推荐")
                font.family: window.mFONT_FAMILY
                font.pointSize: 18

                color: "#eeffffff"
            }
        }

        // 新歌
        MusicGridLatestView{
            id:latesView
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredHeight: (window.width - 230)*0.1*10+20
            Layout.bottomMargin: 20
        }

    }

    /* 加载时调用 */
    Component.onCompleted: {
        getBannerList() /* 获取图片列表 */
    }

    /* 获取轮播列表 */
    function getBannerList(){
        // 加载中
        loading.open()

        // 函数声明
        function onReply(reply){ /* 定义onReply函数 */
            // 加载结束
            loading.close()

            /* 断开信号和槽函数的绑定，replySignal(QString reply)信号和onReply函数解绑 */
            http.onReplySignal.disconnect(onReply)

            try{
                if(reply.length<1){ // 响应为空
                    notification.openError("请求轮播图为空！")
                    return
                }

                /* 将reply转成json，并获取其中的banner数据 */
                var banners = JSON.parse(reply).banners

                /* 轮播图控件的图片列表 */
                bannerView.bannerList = banners

                // 网络请求是异步的，需要一个接一个地请求数据
                // 获取轮播图列表后，再获取热门列表
                getHotList()
            }
            catch(err){
                notification.openError("请求轮播图出错！")
            }
        }

        /* 绑定信号，onReplySignal的名称与HttpUtils类的信号replySignal名称有关 */
        /* 触发replySignal(QString reply)信号，调用onReply函数 */
        http.onReplySignal.connect(onReply)
        http.connet("banner") // 连接到  http://localhost:3000/banner ，获取返回，并自动发出replySignal信号
    }
    /* 获取热门列表 */
    function getHotList(){
        // 加载中
        loading.open()

        // 函数声明
        function onReply(reply){ /* 定义onReply函数 */
            // 加载结束
            loading.close()

            /* 断开信号和槽函数的绑定，replySignal(QString reply)信号和onReply函数解绑 */
            http.onReplySignal.disconnect(onReply)


            try{
                if(reply.length<1){
                    notification.openError("请求热门推荐为空！")
                    return
                }

                /* 将reply转成json，并获取其中的banner数据 */
                var playlists = JSON.parse(reply).playlists

                /* 热门控件的图片列表 */
                hotView.list = playlists

                getLatestList()
            }
            catch(err){
                notification.openError("请求热门推荐出错！")
            }
        }

        /* 绑定信号，onReplySignal的名称与HttpUtils类的信号replySignal名称有关 */
        /* 触发replySignal(QString reply)信号，调用onReply函数 */
        http.onReplySignal.connect(onReply)
        // 连接到  http://localhost:3000/top/playlist/highquality?limit=20 ，获取20条内容返回，并自动发出replySignal信号
        http.connet("top/playlist/highquality?limit=20")
    }
    /* 获取最新列表 */
    function getLatestList(){
        // 加载中
        loading.open()

        // 函数声明
        function onReply(reply){ /* 定义onReply函数 */
            // 加载结束
            loading.close()

            /* 断开信号和槽函数的绑定，replySignal(QString reply)信号和onReply函数解绑 */
            http.onReplySignal.disconnect(onReply)

            try{
                if(reply.length<1){ // 响应为空
                    notification.openError("请求最新歌曲为空！")
                    return
                }

                /* 将reply转成json，并获取其中的banner数据 */
                var latestlist = JSON.parse(reply).data

                /* 热门控件的图片列表 */
                latesView.list = latestlist.slice(0, 30) // 从0开始删除30个元素
            }
            catch(err){
                notification.openError("请求最新歌曲出错！")
            }
        }

        /* 绑定信号，onReplySignal的名称与HttpUtils类的信号replySignal名称有关 */
        /* 触发replySignal(QString reply)信号，调用onReply函数 */
        http.onReplySignal.connect(onReply)
        // 连接到  http://localhost:3000/top/playlist/highquality?limit=20 ，获取20条内容返回，并自动发出replySignal信号
        http.connet("top/song")
    }
}

















