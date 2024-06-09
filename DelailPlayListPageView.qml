// 播放列表页面
import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12

ColumnLayout {
    
    property string targetId: "" // 播放列表歌曲或专辑id，用于获取内容
    property string targetType: "10"
    property string name: "-" // 歌曲或专辑名称

    onTargetIdChanged:{// 播放列表歌曲或专辑id改变
        if(targetType == "10") // 专辑
            loadAlbum()
        else if(targetType == "1000")
            loadPlayList() // 加载播放列表
    }
    
    // 标题
    Rectangle{
        Layout.fillWidth: true
        width: parent.width
        height: 50
        color: "#00000000"

        Text {
            x:10
            verticalAlignment: Text.AlignBottom // 垂直方向 底部对齐
            text: qsTr((targetId=="10"? "专辑":"歌单")+name)
            font.family: window.mFONT_FAMILY
            font.pointSize: 18
            color: "#eeffffff"
        }
    }
    
    RowLayout{
        height: 200
        width: parent.width
        
        // 图片
        MusicBorderImage{
            id:playListCover
            width: 180
            height: 180
            Layout.leftMargin: 15
        }
        
        // 描述
        Item {
            Layout.fillWidth: true
            height: parent.height
            
            Text{
                id:playListDesc
                width: parent.width*0.95
                anchors.centerIn: parent
                wrapMode: Text.WrapAnywhere
                font.family: window.mFONT_FAMILY
                font.pointSize: 14
                maximumLineCount: 4 // 最大行数
                elide: Text.ElideRight // 隐藏右边
                lineHeight: 1.5 // 1.5倍行高

                color: "#eeffffff"
            }
        }
    }
    
    // 播放列表
    MusicListView{
        id:playListListView
        deletable: false // 删除按钮不可见
        
    }

    // 加载专辑
    function loadAlbum(){
        // 加载中
        loading.open()

        /* 获取播放列表 */
        // 根据类型选择url
        var url = "album?id="+(targetId.length<1?"32311":targetId)

        function onReply(reply){ /* 定义onReply函数 */
            // 加载结束
            loading.close()

            /* 断开信号和槽函数的绑定，replySignal(QString reply)信号和onReply函数解绑 */
            http.onReplySignal.disconnect(onReply)

            try{
                if(reply.length<1){ // 响应为空
                    notification.openError("获取专辑列表为空！")
                    return
                }

                /* 将reply转成json，并获取其中的banner数据 */
                var album = JSON.parse(reply).album
                var songs = JSON.parse(reply).songs


                // 设置歌曲或专辑的详细信息
                playListCover.imgSrc = album.blurPicUrl
                playListDesc.text = album.description
                name = "-"+album.name

                // 设置播放列表
                playListListView.musicList = songs.map(item=>{
                                                       return {
                                                               id:item.id,
                                                               name:item.name,
                                                               artist:item.ar[0].name,
                                                               album:item.al.name,
                                                               cover:item.al.picUrl
                                                           }
                                                       })
            }
            catch(err){
                notification.openError("获取专辑列表出错！")
            }
        }

        /* 绑定信号，onReplySignal的名称与HttpUtils类的信号replySignal名称有关 */
        /* 触发replySignal(QString reply)信号，调用onReply函数 */
        http.onReplySignal.connect(onReply)
        http.connet(url) // 连接到  url ，获取返回，并自动发出replySignal信号
    }


    function loadPlayList(){
        // 加载中
        loading.open()
        /* 获取播放列表 */
        // 根据类型选择url
        var url = "playlist/detail?id="+(targetId.length<1?"32311":targetId)

        // 函数声明
        function onSongDetailReply(reply){ /* 定义onReply函数 */
            // 加载结束
            loading.close()

            /* 断开信号和槽函数的绑定，replySignal(QString reply)信号和onReply函数解绑 */
            http.onReplySignal.disconnect(onSongDetailReply)

            try{
                if(reply.length<1){ // 响应为空
                    notification.openError("获取歌单列表详情为空！")
                    return
                }

                /* 将reply转成json，并获取其中的banner数据 */
                var songs = JSON.parse(reply).songs

                playListListView.musicList = songs.map(item=>{
                                                       return {
                                                               id:item.id,
                                                               name:item.name,
                                                               artist:item.ar[0].name,
                                                               album:item.al.name,
                                                               cover:item.al.picUrl
                                                           }
                                                       })
            }
            catch(err){
                notification.openError("获取歌单列表详情出错！")
            }
        }

        // 函数声明
        function onReply(reply){ /* 定义onReply函数 */
            // 加载结束
            loading.close()

            /* 断开信号和槽函数的绑定，replySignal(QString reply)信号和onReply函数解绑 */
            http.onReplySignal.disconnect(onReply)

            try{
                if(reply.length<1){ // 响应为空
                    notification.openError("获取歌单列表为空！")
                    return
                }

                /* 将reply转成json，并获取其中的banner数据 */
                var playlist = JSON.parse(reply).playlist


                // 设置歌曲或专辑的详细信息
                playListCover.imgSrc = playlist.coverImgUrl
                playListDesc.text = playlist.description
                name = "-"+playlist.name

                var ids = playlist.trackIds.map(item=>item.id).join(",")

                /* 绑定信号，onReplySignal的名称与HttpUtils类的信号replySignal名称有关 */
                /* 触发replySignal(QString reply)信号，调用onReply函数 */
                http.onReplySignal.connect(onSongDetailReply)
                http.connet("song/detail?ids="+ids) // 连接到  url ，获取返回，并自动发出replySignal信号

                // 加载中
                loading.open()
            }
            catch(err){
                notification.openError("获取歌单列表出错！")
            }
        }

        /* 绑定信号，onReplySignal的名称与HttpUtils类的信号replySignal名称有关 */
        /* 触发replySignal(QString reply)信号，调用onReply函数 */
        http.onReplySignal.connect(onReply)
        http.connet(url) // 连接到  url ，获取返回，并自动发出replySignal信号
    }
}





























