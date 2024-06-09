// 历史页面
import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12
import Qt.labs.platform 1.0
import Qt.labs.settings 1.1
import QtQml 2.12
import QtQuick.Dialogs

ColumnLayout {
    Rectangle{
        Layout.fillWidth: true
        width: parent.width
        height: 50
        color: "#00000000"

        Text {
            x:10
            verticalAlignment: Text.AlignBottom // 垂直方向 底部对齐
            text: qsTr("历史播放")
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
            btnText: "刷新记录"

            btnHeight: 50
            btnWidth: 120

            onClicked: getHistory() // 重新读取
        }
        // 按钮
        MusicTextButton{
            btnText: "清空记录"

            btnHeight: 50
            btnWidth: 120

            onClicked: clearHistory() // 保存空列表
        }
    }

    MusicListView{
        id:historyListView
        onDeleteItem: deleteHistory(index)
    }

    Component.onCompleted: {
        getHistory()
    }

    // 从配置文件里 获取获取记录
    function getHistory(){
        var list = readHistorySettings()
        historyListView.musicList = list // 设置本地的播放列表
    }

    // 清空历史记录
    function clearHistory(){
        historySettings.setValue("history", "[]") // 写入配置文件
        getHistory() // 获取本地播放列表进行配置
    }

    // 删除历史音乐
    function deleteHistory(index){
        var list = readHistorySettings()
        if(list.length < index+1) return // 下标越界
        list.splice(index,1) // 删除选择的歌曲
        var str = JSON.stringify(list) // 将list转化成字符串
        localSettings.setValue("local", str) // 写入配置文件
        getHistory(list) // 重新设置
    }


    // 读取 配置文件的字符串，返回json
    function readHistorySettings(){
        var str  = historySettings.value("history", "[]") // 从配置文件里 获取本地音乐的 字符串列表
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


}






















