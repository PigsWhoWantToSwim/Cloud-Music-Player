// 本地音乐页面
import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12
import Qt.labs.platform 1.0
import Qt.labs.settings 1.1
import QtQml 2.12
import QtQuick.Dialogs

ColumnLayout {

    Settings{ // 使用配置文件
        id:localSettings
        fileName: "conf/local.ini"
    }

    Rectangle{
        Layout.fillWidth: true
        width: parent.width
        height: 50
        color: "#00000000"

        Text {
            x:10
            verticalAlignment: Text.AlignBottom // 垂直方向 底部对齐
            text: qsTr("本地音乐")
            font.family: window.mFONT_FAMILY
            font.pointSize: 18
            color: "#eeffffff"
        }
    }

    RowLayout{
        height: 80

        // 占位
        Item{
            width: 5
        }

        // 按钮
        MusicTextButton{
            btnText: "添加本地音乐"

            btnHeight: 50
            btnWidth: 120

            onClicked: fileDialog.open() // 打开文件对话框
        }
        // 按钮
        MusicTextButton{
            btnText: "刷新记录"

            btnHeight: 50
            btnWidth: 120

            onClicked: getLocal() // 重新读取
        }
        // 按钮
        MusicTextButton{
            btnText: "清空记录"

            btnHeight: 50
            btnWidth: 120

            onClicked: saveLocal() // 保存空列表
        }
    }

    MusicListView{
        id:localListView
        onDeleteItem: deleteLocal(index) // 删除信号处理槽函数
    }

    Component.onCompleted: {
        getLocal()
    }

    // 从配置文件里 获取本地音乐
    function getLocal(){
        var list = readLocalSettings()
        localListView.musicList = list // 设置本地的播放列表
        return list // 返回
    }

    // 保存本地音乐
    function saveLocal(list = []){
        // list 为 [{'id': '***', 'name': '***'}, {'id': '***', 'name': '***'}]

        var str = JSON.stringify(list) // 将list转化成字符串
        // str为 "[{'id': '***', 'name': '***'}, {'id': '***', 'name': '***'}]"

        localSettings.setValue("local", str) // 写入配置文件

        getLocal() // 获取本地播放列表进行配置
    }


    // 删除本地音乐
    function deleteLocal(index){
        var list = readLocalSettings()
        if(list.length < index+1) return // 下标越界
        list.splice(index,1) // 删除选择的歌曲
        saveLocal(list) // 保存
    }

    // 读取 配置文件的字符串，返回json
    function readLocalSettings(){
        var str  = localSettings.value("local", "[]") // 从配置文件里 获取本地音乐的 字符串列表
        // str为 "[{'id': '***', 'name': '***'}, {'id': '***', 'name': '***'}]"

        // 匹配{}里的内容
        var strList = str.match(/{(.*?)}/g)
        // strList 为 ["{'id': '***', 'name': '***'}", "{'id': '***', 'name': '***'}"]

        // 将每一个字符串转变为json，并加入列表
        var list = []
        for(var strIndex in strList){ // 遍历字符串列表
            var item = JSON.parse(strList[strIndex]) // 转化成json
            // item 为 {'id': '***', 'name': '***'}
            list.push(item) // 添加到列表
        }

        return list // 返回
    }


    // 打开文件对话框
    FileDialog{
        id:fileDialog
        fileMode: FileDialog.OpenFiles // 打开文件
        nameFilters: ["MP3 Music Files(*mp3)","FLAC Music Files(*.flac)"] // 文件类型过滤器

        currentFolder: StandardPaths.standardLocations(StandardPaths.MusicLocation)[0] // 默认路径

        // 按钮名称
        acceptLabel: "确定"
        rejectLabel: "取消"

        // 接受
        onAccepted: {
            var list = getLocal() // 获取本地播放
            for(var index in selectedFiles){ // files是选择的文件列表
                var path = selectedFiles[index].toString() // 文件路径，如"file:///E:/Wake_Me_Up-Avicii.320.mp3"
                path = path.substring(8,path.length) // 去掉前缀，得到"E:/Wake_Me_Up-Avicii.320.mp3"
                path = path.replace(/_+/g, " ") // 将下划线替换从空格
                path = path.replace(/ +/g, " ") // 将多个空格替换成1个空格

                var arr = path.split("/") // 划分路径
                var fileNameArr = arr[arr.length-1].split(".") // 划分文件名称
                // 如"倒数-G.E.M.邓紫棋-320.mp3"--->["倒数-G","E","M","邓紫棋-320","mp3"]
                fileNameArr.pop() //去掉后缀
                var fileName = fileNameArr.join(".") // 重新合并 --->倒数-G.E.M.邓紫棋-320
                // 名称-歌手.mp3
                var nameArr = fileName.split("-")// "倒数-G.E.M.邓紫棋.320"--->["倒数","G.E.M.邓紫棋","320"]
                var name = "未知歌曲" // 默认名称
                var artist = "未知歌手"

                if(nameArr.length>1){ // 存在名称和歌手
                    name = nameArr[0] // 获取歌名
                    nameArr.shift() // 删除第一个歌名，只存在歌手，["G.E.M.邓紫棋","320"]

                    artist = nameArr.join("-") // 合并，G.E.M.邓紫棋-320
                }
                else if(nameArr.length === 1){ // 只存在名称
                    name = nameArr[0] // 获取歌名
                }

                if(list.filter(item=>item.id === path).length<1) // 过滤器，先将已经存在的歌曲中等于要添加的歌曲的个数
                    // <1，未存在这首歌曲，可以添加
                    // list的每一项为 {id: "", name, artist, url: "", album: "", type: ""}
                    list.push({ // 追加入到本地播放列表
                                id:path+"",
                                name,artist,
                                url:path+"",
                                album:"本地音乐",
                                type:"1"//1表示本地音乐，0表示网络
                            })
                // saveLocal(list) // 保存 本地播放列表
            }
            saveLocal(list) // 保存 本地播放列表
        }
    }



}






















