import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import MyUtils 1.0
import QtMultimedia
import QtQml 2.12
import Qt.labs.settings 1.1

ApplicationWindow {
    id: window

    property int mWINDOW_WIDTH: 1100
    property int mWINDOW_HEIGHT: 540

    property string mFONT_FAMILY: "微软雅黑"

    width: mWINDOW_WIDTH
    height: mWINDOW_HEIGHT
    visible: true
    title: qsTr("CloudMusicPlayer")

    // 背景
    background: Background{
        id:appBackground
    }

    // 无边框
    flags: Qt.Window|Qt.FramelessWindowHint

    // 系统托盘
    AppSystemTrayIcon{

    }

    // 网络请求 对象
    HttpUtils{
        id:http
    }

    // 软件配置文件
    Settings{ // 配置文件
        id:settings
        fileName: "conf/settings.ini"
    }
    Settings{ // 历史记录
        id:historySettings
        fileName: "conf/history.ini"
    }
    Settings{ // 我的收藏
        id:favoriteSettings
        fileName: "conf/favorite.ini"
    }

    // 布局
    ColumnLayout{
        anchors.fill: parent
        spacing: 0

        LayoutHeaderView{ // 标题栏
            id: layoutHeaderView
            z:1000
        }

        PageHomeView{ // 首页
            id: pageHomeView

        }

        PageDetailView{ // 音乐详情页
            id: pageDetailView
            visible: false // 初始默认不可见
        }

        LayoutBottomView{ // 底栏
            id: layoutBottomView
        }
    }

    MusicNotification{ // 消息通知
        id:notification
    }

    MusicLoading{ // 加载控件
        id:loading
    }

    MediaPlayer { // 播放器
        id: mediaPlayer
        audioOutput: AudioOutput {} // 播放设备

        property var times: []

        // 播放进度改变
        onPositionChanged: {
            layoutBottomView.setSlider(0, duration, position)

            if(times.length>0){ // 时间列表内存在内容
                var count = times.filter(time=>time<position).length // 使用过滤器 获取 <position的内容，返回个数
                // count 为 已经经过的歌词时间的个数
                pageDetailView.current  = (count===0)?0:count-1 // 当前的歌词为 最后一个过去的歌词
            }


        }


        // 播放状态改变
        onPlaybackStateChanged: {
            // 改变播放状态
            layoutBottomView.playingState = (playbackState===MediaPlayer.PlayingState? 1:0)

            if(playbackState === MediaPlayer.StoppedState && layoutBottomView.playbackStateChangeCallbackEnabled){ // 播放结束
                layoutBottomView.playNext() // 播放下一曲
            }

        }
    }
}






















