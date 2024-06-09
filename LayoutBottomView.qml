import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtMultimedia
import QtQml 2.12

// 底部工具栏
Rectangle{

    property var playList: []
    property int current: -1

    // 进度条
    property int sliderValue: 0 // 当前进度
    property int  sliderFrom: 0 // 进度起点
    property int  sliderTo: 100 // 进度终点

    // 播放模式
    property var playModeList: [
        {icon:"single-repeat",name:"单曲循环"},
        {icon:"repeat",name:"顺序播放"},
        {icon:"random",name:"随机播放"}]
    property int currentPlayMode: 0

    // 播放状态状态改变是否调用回调
    property bool playbackStateChangeCallbackEnabled: false

    // 歌名和图片
    property string musicName: "歌曲名"
    property string musicArtist: "音乐家"
    property string musicCover: "qrc:/images/player"

    // 当前播放状态
    property int playingState: 0 // 0为暂停

    Layout.fillWidth: true
    height: 60
    color: "#1500AAAA"

    RowLayout{
        anchors.fill: parent

        Item {
            Layout.preferredWidth: parent.width / 10
            Layout.fillWidth: true
        }

        MusicIconButton{
            iconSource: "qrc:/images/previous.png"
            iconWidth: 32
            iconHeight: 32
            toolTip: "上一首"          
            onClicked: playPrevious()
        }
        MusicIconButton{
            iconSource: playingState===0?"qrc:/images/stop":"qrc:/images/pause"
            iconWidth: 32
            iconHeight: 32
            toolTip: playingState===0?"播放":"暂停"
            onClicked: playOrPause() // 播放或暂停
        }
        MusicIconButton{
            iconSource: "qrc:/images/next.png"
            iconWidth: 32
            iconHeight: 32
            toolTip: "下一首"

            onClicked: playNext("")
        }

        // 进度条区
        Item {
            Layout.preferredWidth: parent.width / 2
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.topMargin: 20

            visible: !layoutHeaderView.isSmallWindow // 不处于小窗模式就显示

            Text { // 歌名
                anchors.left: progressSlider.left
                anchors.bottom: progressSlider.top
                anchors.leftMargin: 5
                text: musicName+"-"+musicArtist
                font.family: window.mFONT_FAMILY
                color: "#ffffff"
            }
            Text { // 时间进度
                id: timeText
                anchors.right: progressSlider.right
                anchors.bottom: progressSlider.top
                anchors.rightMargin: 5
                text: qsTr("00:00/00:00")
                font.family: window.mFONT_FAMILY
                color: "#ffffff"
            }

            Slider{ // 进度条
                id: progressSlider
                width: parent.width
                Layout.fillWidth: true
                height: 25

                // 设置进度条的值
                value:sliderValue
                from: sliderFrom
                to:sliderTo

                // 进度条 拖动事件
                onMoved:{
                    // 播放器播放跳跃
                    // mediaPlayer.seek(value) // qt6已删除
                    mediaPlayer.position = value

                }

                // 进度条美化
                background: Rectangle{
                    x: progressSlider.leftPadding
                    y: progressSlider.topPadding + (progressSlider.availableHeight - height) / 2
                    width: progressSlider.availableWidth
                    height: 4
                    radius: 2
                    color: "#e9f4ff"
                    // 滑过的槽
                    Rectangle{
                        width: progressSlider.visualPosition * parent.width
                        height: parent.height
                        color: "#1b9de3"
                        radius: 2
                    }
                }
                handle: Rectangle{
                    x: progressSlider.leftPadding + (progressSlider.availableWidth - width) * progressSlider.visualPosition
                    y: progressSlider.topPadding + (progressSlider.availableHeight - height) / 2
                    width: 16
                    height: 16
                    radius: 8
                    color: "#f0f0f0"
                    border.color: "#73a7ab"
                    border.width: 0.5
                }
            }
        }

        MusicBorderImage{
            imgSrc: musicCover
            width: 50
            height: 45

            // 鼠标点击
            MouseArea{
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor // 手型光标
                onPressed: { // 按下
                    parent.scale=0.9 // 缩小

                    // 显示页面
                    pageDetailView.visible = !pageDetailView.visible
                    pageHomeView.visible = !pageHomeView.visible

                    // 将背景图片和歌曲封面切换
                    appBackground.showDefaultBackground = !appBackground.showDefaultBackground
                }

                onReleased: { // 松开
                    parent.scale=1.0 // 恢复
                }


            }
        }

        MusicIconButton{
            Layout.preferredWidth: 50
            iconSource: "qrc:/images/favorite.png"
            iconWidth: 32
            iconHeight: 32
            toolTip: "收藏"
            onClicked: saveFavorite(playList[current]) // 收藏当前的歌曲
        }
        MusicIconButton{
            iconSource: "qrc:/images/"+playModeList[currentPlayMode].icon
            iconWidth: 32
            iconHeight: 32
            toolTip: playModeList[currentPlayMode].name

            // 改变播放模式
            onClicked: changePlayMode()
        }

        Item {
            Layout.preferredWidth: parent.width / 10
            Layout.fillWidth: true
        }
    }

    // 函数区域
    Component.onCompleted: {
        // 从配置文件中获取播放模式
        currentPlayMode =settings.value("currentPlayMode",0)
    }

    // 当前播放的歌曲改变
    onCurrentChanged: {
        playbackStateChangeCallbackEnabled = false
        playMusic(current)
    }

    // 播放上一曲
    function playPrevious(){
        if(playList.length < 1) return

        // 根据当前播放模式进行播放
        switch(currentPlayMode){
        case 0: // 单曲循环，播放结束自动调用playNext，不用再次实现
        case 1: // 顺序播放
            // 获取上一曲
            current = (current-1 + playList.length)%playList.length // 避免负数
            break

        case 2: {// 随机播放
            var random = parseInt(Math.random()*playList.length)
            current = random === current? random+1:random
            break
        }
        }
    }
    // 播放或暂停
    function playOrPause() {
        if(!mediaPlayer.source) return // 无正在播放
        if(mediaPlayer.playbackState===MediaPlayer.PlayingState){ // 正在播放
            mediaPlayer.pause() // 暂停
        }else if(mediaPlayer.playbackState===MediaPlayer.PausedState){ // 正在暂停
            mediaPlayer.play() // 播放
        }
    }

    // 播放下一曲
    function playNext(type="natural"){
        if(playList.length < 1) return

        // 根据当前播放模式进行播放
        switch(currentPlayMode){
        case 0: // 单曲循环
            if(type === "natural"){ // 不是手动点击，而是自动结束
                mediaPlayer.play() // 重新播放
                break
            }
        case 1: // 顺序播放
            // 获取下一曲
            current = (current+1 + playList.length)%playList.length // 避免负数
            break

        case 2: {// 随机播放
            var random = parseInt(Math.random()*playList.length)
            current = random === current? random+1:random
            break
        }
        }

    }
    // 播放音乐
    function playMusic(){
        if(current < 0) return
        if(playList.length < current+1) return

        // 判断是网络歌曲还是本地歌曲，1是本地音乐
        if(playList[current].type === "1"){
            playLocalMusic()// 获取本地歌曲的连接，并播放
        }
        else {
            playWebMusic() // 获取网络歌曲的连接，并播放
        }

    }
    // 改变播放模式
    function changePlayMode(){
        currentPlayMode = (currentPlayMode + 1)%playModeList.length
        settings.setValue("currentPlaymode",currentPlayMode) // 记录当前播放模式
    }

    // 获取本地歌曲
    function playLocalMusic(){
        var currentItem = playList[current] // 获取当前要播放的歌曲
        mediaPlayer.source =currentItem.url // 设置到播放器里
        mediaPlayer.play() // 进行播放
        saveHistory(current) // 保存到历史记录
        // 设置歌名和歌手，并显示
        musicName = currentItem.name
        musicArtist = currentItem.artist
    }
    // 获取网络歌曲url
    function playWebMusic(){
        // 加载中
        loading.open()

        // 获取歌曲id
        var id = playList[current].id

        if(!id) return

        // 设置详情
        musicName = playList[current].name
        musicArtist = playList[current].artist

        // 函数声明
        function onReply(reply){ /* 定义onReply函数 */
            // 结束加载
            loading.close()

            /* 断开信号和槽函数的绑定，replySignal(QString reply)信号和onReply函数解绑 */
            http.onReplySignal.disconnect(onReply)

            try{
                if(reply.length < 1){ // 响应为空
                    notification.openError("请求歌曲链接为空！")
                    return
                }

                /* 将reply转成json，并获取其中的data数据 */
                var data = JSON.parse(reply).data[0]
                var url = data.url
                var time = data.time

                // 设置进度条
                setSlider(0, time, 0)

                if(!url) return // 歌曲连接为空

                // 请求封面
                var cover = playList[current].cover
                if(cover.length < 1 ){
                    getCover(id)
                }
                else{
                    musicCover = cover
                    getLyric(id) // 获取歌词
                }

                mediaPlayer.source = url // 设置播放歌曲
                mediaPlayer.play() // 播放
                saveHistory(current) // 保存历史记录

                // 播放状态回调使能
                playbackStateChangeCallbackEnabled = true
            }
            catch(err){ // 捕获错误
                notification.openError("请求歌曲链接出错！")
            }
        }

        /* 绑定信号，onReplySignal的名称与HttpUtils类的信号replySignal名称有关 */
        /* 触发replySignal(QString reply)信号，调用onReply函数 */
        http.onReplySignal.connect(onReply)
        // 连接到  http://localhost:3000/top/playlist/highquality?limit=20 ，获取20条内容返回，并自动发出replySignal信号
        http.connet("song/url?id="+id)
    }

    // 设置进度条
    function setSlider(from=0, to=100, value=0){
        // 设置属性
        sliderFrom = from
        sliderTo = to
        sliderValue = value

        // 转换时间格式 from、to单位为毫秒数
        var va_mm = parseInt((value/1000)/60) + "" // 分钟，转成字符串
        va_mm = va_mm.length<2?"0"+va_mm:va_mm // 不到两位数前加0
        var va_ss = parseInt((value/1000)%60) + "" // 秒数
        va_ss = va_ss.length<2?"0"+va_ss:va_ss

        var to_mm = parseInt((to/1000)/60) + "" // 分钟，转成字符串
        to_mm = to_mm.length<2?"0"+to_mm:to_mm // 不到两位数前加0
        var to_ss = parseInt((to/1000)%60) + "" // 秒数
        to_ss = to_ss.length<2?"0"+to_ss:to_ss

        timeText.text = va_mm+":"+va_ss +"/"+to_mm+":"+to_ss
    }
    // 获取封面
    function getCover(id){
        // 加载中
        loading.open()

        // 函数声明
        function onReply(reply){ /* 定义onReply函数 */
            // 结束加载
            loading.close()

            /* 断开信号和槽函数的绑定，replySignal(QString reply)信号和onReply函数解绑 */
            http.onReplySignal.disconnect(onReply)

            //请求歌词
            getLyric(id)

            try{
                if(reply.length<1){ // 响应为空
                    notification.openError("请求歌曲图片为空！")
                    return
                }

                // 获取歌曲和封面
                var song = JSON.parse(reply).songs[0]
                var cover = song.al.picUrl

                musicCover = cover // 设置封面
                if(musicName.length<1) musicName = song.name // 设置歌名
                if(musicArtist.length<1) musicArtist = song.ar[0].name // 设置歌手
            }
            catch(err){
                notification.openError("请求歌曲图片出错！")
            }


        }

        /* 绑定信号，onReplySignal的名称与HttpUtils类的信号replySignal名称有关 */
        /* 触发replySignal(QString reply)信号，调用onReply函数 */
        http.onReplySignal.connect(onReply)
        // 连接到  获取内容返回，并自动发出replySignal信号
        http.connet("song/detail?ids="+id)
    }
    // 获取歌词
    function getLyric(id){
        // 加载中
        loading.open()

        // 函数声明
        function onReply(reply){ /* 定义onReply函数 */
            // 结束加载
            loading.close()

            /* 断开信号和槽函数的绑定，replySignal(QString reply)信号和onReply函数解绑 */
            http.onReplySignal.disconnect(onReply)

            try{
                if(reply.length<1){ // 响应为空
                    notification.openError("请求歌曲歌词为空！")
                    return
                }

                // 获取歌曲和封面
                var lyric = JSON.parse(reply).lrc.lyric
                if(lyric.length < 1) return

                // 获取歌词内容，并划分歌词
                var lyrics = (lyric.replace(/\[.*\]/gi,"")).split("\n")

                // 设置歌词
                if(lyrics.length>0) pageDetailView.lyricsList = lyrics

                // 歌词时间数组
                var timesList = []

                // 获取匹配的时间戳，并执行回调函数
                lyric.replace(/\[.*\]/gi,function(match,index){
                    //match : [00:00.00]
                    if(match.length>2){
                        var time = match.substr(1,match.length-2) // 去掉[]，获取时间
                        var arr = time.split(":") // 划分出分钟和秒

                        // 计算总时间值
                        var timeValue = arr.length>0? parseInt(arr[0])*60*1000:0 // >0存在分钟，将分钟转成毫秒
                        arr = (arr.length>1? arr[1].split("."):[0,0]) // >1存在分钟和秒，划分出秒和小数位的秒
                        timeValue += arr.length>0? parseInt(arr[0])*1000:0 // >0存在秒，加上秒
                        timeValue += arr.length>1? parseInt(arr[1])*10:0 // >1存在小数，加上毫秒

                        timesList.push(timeValue) // 加入数组
                    }
                })

                // 设置 歌词时间列表
                mediaPlayer.times = timesList
            }
            catch(err){
                notification.openError("请求歌曲歌词出错！")
            }
        }

        /* 绑定信号，onReplySignal的名称与HttpUtils类的信号replySignal名称有关 */
        /* 触发replySignal(QString reply)信号，调用onReply函数 */
        http.onReplySignal.connect(onReply)
        // 连接到  获取内容返回，并自动发出replySignal信号
        http.connet("lyric?id="+id)
    }

    // 保存历史记录
    function saveHistory(index = 0){
        if(playList.length<index+1) return // 下标越界
        var item  = playList[index]
        if(!item||!item.id) return // 不存在或无效
        // 获取历史记录字符串，转换成json
        var readStr  = historySettings.value("history", "[]") // 从配置文件里 获取历史记录的 字符串列表
        var strList = readStr.match(/{(.*?)}/g) // 匹配{}里的内容

        // 将每一个字符串转变为json，并加入列表
        var history = []
        for(var strIndex in strList){ // 遍历字符串列表
            var jsonItem = JSON.parse(strList[strIndex]) // 转化成json
            // item 为 {'id': '***', 'name': '***'}
            history.push(jsonItem) // 添加到列表
        }

        var i =  history.findIndex(value=>value.id===item.id) // 查找对应索引
        if(i>=0){ // 对应索引 存在
            history.splice(i,1) // 从i位置开始删除1个元素，即删除原来的
        }

        history.unshift({ // 在开头重新 添加
                            id:item.id+"",
                            name:item.name+"",
                            artist:item.artist+"",
                            url:item.url?item.url:"",
                            type:item.type?item.type:"",
                            album:item.album?item.album:"本地音乐"
                        })

        if(history.length > 100){
            //限制一百条数据
            history.pop()
        }

        // 保存历史记录
        var saveStr = JSON.stringify(history) // 将list转化成字符串
        historySettings.setValue("history", saveStr)
    }
    // 保存收藏
    function saveFavorite(value={}){ // 传入歌曲
        if(!value||!value.id)return // 不存在或无效

        // 获取历史记录字符串，转换成json
        var readStr = favoriteSettings.value("favorite","[]")
        var strList = readStr.match(/{(.*?)}/g) // 匹配{}里的内容

        // 将每一个字符串转变为json，并加入列表
        var favorite = []
        for(var strIndex in strList){ // 遍历字符串列表
            var jsonItem = JSON.parse(strList[strIndex]) // 转化成json
            // item 为 {'id': '***', 'name': '***'}
            favorite.push(jsonItem) // 添加到列表
        }



        var i =  favorite.findIndex(item=>value.id === item.id) // 查找对应索引
        if(i>=0) favorite.splice(i,1) // 从i位置开始删除1个元素，即删除原来的
        favorite.unshift({ // 在开头重新 添加
                            id:value.id+"",
                            name:value.name+"",
                            artist:value.artist+"",
                            url:value.url?value.url:"",
                            type:value.type?value.type:"",
                            album:value.album?value.album:"本地音乐"
                        })

        if(favorite.length>500){
            //限制五百条数据
            favorite.pop()
        }

        // 保存收藏
        var saveStr = JSON.stringify(favorite) // 将list转化成字符串
        favoriteSettings.setValue("favorite", saveStr)
    }

}































