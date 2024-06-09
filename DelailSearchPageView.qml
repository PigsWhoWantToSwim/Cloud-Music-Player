// 搜索页面
import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12

ColumnLayout {
    Layout.fillWidth: true
    Layout.fillHeight: true

    // 标题
    Rectangle{
        Layout.fillWidth: true
        width: parent.width
        height: 50
        color: "#00000000"

        Text {
            x:10
            verticalAlignment: Text.AlignBottom // 垂直方向 底部对齐
            text: qsTr("搜索音乐")
            font.family: window.mFONT_FAMILY
            font.pointSize: 18
            color: "#eeffffff"
        }
    }

    // 搜索框
    RowLayout{
        Layout.fillWidth: true

        // anchors.centerIn: parent
        Item { // 占位
            Layout.preferredWidth: 7
        }

        TextField{ // 搜索框
            id:searchInput
            font.family:window.mFONT_FAMILY
            font.pointSize:13
            color:"#eeffffff"

            selectByMouse: true // 可被鼠标选中
            selectionColor: "#999999" // 选中颜色
            placeholderText: qsTr("请输入搜索关键字")
            background: Rectangle{
                color: "#e2f0f8"
                // border.width: 1
                // border.color: "black"
                opacity: 0.5
                implicitHeight: 30
                implicitWidth: 400
            }
            focus: true

            // 快捷键，回车确认，执行搜索
            Keys.onPressed: if(event.key===Qt.Key_Enter||event.key===Qt.Key_Return) doSearch()
        }

        MusicIconButton{ // 搜索按钮
            iconSource: "qrc:/images/search"
            toolTip: "搜索"
            onClicked: doSearch()
        }
    }


    // 表格内容
    MusicListView{
        id:musicListView
        deletable: false // 删除按钮不可见
        // 加载更多 处理槽函数
        onLoadMore: doSearch(offset,current) // 搜索新内容
        Layout.topMargin: 10
    }

    function doSearch(offset = 0,current = 0){ // 传入偏移量，用于分页查询
        // 加载中效果
        loading.open()

        var keywords = searchInput.text // 获取输入框的内容
        if(keywords.length < 1) // 搜索内容为0
            return

        // 函数声明
        function onReply(reply){ /* 定义onReply函数 */
            // 结束加载
            loading.close()

            /* 断开信号和槽函数的绑定，replySignal(QString reply)信号和onReply函数解绑 */
            http.onReplySignal.disconnect(onReply)

            try{
                if(reply.length<1){
                    notification.openError("搜索结果为空！")
                    return
                }

                /* 将reply转成json，并获取其中的.result数据 */
                var result =  JSON.parse(reply).result

                /* 搜索返回表控件的列表 */
                musicListView.current = current
                musicListView.all = result.songCount
                musicListView.musicList = result.songs.map(item=>{ // 将item传入一个匿名函数
                                                            return { // 函数返回一个map
                                                                id:item.id,
                                                                name:item.name,
                                                                artist:item.artists[0].name,
                                                                album:item.album.name,
                                                                cover:""
                                                            }
                                                        })
            }
            catch(err){
                notification.openError("搜索结果出错！")
            }
        }

        /* 绑定信号，onReplySignal的名称与HttpUtils类的信号replySignal名称有关 */
        /* 触发replySignal(QString reply)信号，调用onReply函数 */
        http.onReplySignal.connect(onReply)
        // 连接到  http://localhost:3000/search?keywords= ，获取返回，并自动发出replySignal信号
        http.connet("search?keywords="+keywords+"&offset="+offset+"&limit=60") // 不偏移获取60条
    }

}

















