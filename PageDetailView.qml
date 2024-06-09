// 音乐详情页面
import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtQml 2.12


Item {
    property alias lyricsList: lyricView.lyrics
    property alias current : lyricView.current

    Layout.fillHeight: true
    Layout.fillWidth: true

    // 水平布局，左边为图片，右边为歌词
    RowLayout{
        anchors.fill: parent
        Frame{ // 图片区
            Layout.preferredWidth: parent.width*0.40
            Layout.fillWidth: true
            Layout.fillHeight: true

            background: Rectangle{
                color: "#00000000"
            }

            // 歌曲标题
            Text{
                id:name
                text: layoutBottomView.musicName

                anchors{
                    bottom: artist.top
                    bottomMargin: 20
                    horizontalCenter: parent.horizontalCenter // 水平居中
                }
                font{
                    family: window.mFONT_FAMILY
                    pointSize: 16
                }
                color: "#eeffffff"
            }

            // 歌手
            Text{
                id:artist
                text: layoutBottomView.musicArtist

                anchors{
                    bottom: cover.top
                    bottomMargin: 20
                    topMargin: 20
                    horizontalCenter: parent.horizontalCenter // 水平居中
                }
                font{
                    family: window.mFONT_FAMILY
                    pointSize: 12
                }
                color: "#aaffffff"
            }

            // 图片
            MusicBorderImage{
                id:cover

                anchors.centerIn: parent
                width: parent.width*0.4
                height: width

                borderRadius: width

                imgSrc: layoutBottomView.musicCover
                isRotating: layoutBottomView.playingState===1 // 是否旋转
            }

            Text { // 下方歌词
                id: lyric
                visible: layoutHeaderView.isSmallWindow // 小窗模式时 显示
                // 获取当前歌词
                text: lyricView.lyrics[lyricView.current]?lyricView.lyrics[lyricView.current]:"暂无歌词"
                anchors{
                    top: cover.bottom
                    topMargin: 40
                    horizontalCenter: parent.horizontalCenter // 水平居中
                }
                font{
                    family: window.mFONT_FAMILY
                    pointSize: 12
                }
                color: "#aaffffff"
            }

            MouseArea{ // 鼠标事件区域
                id:mouseArea
                anchors.fill: parent
                hoverEnabled: true // 使能悬停

                onEntered: displayHeaderAndBottom(false) // 光标进入，当前不在首页时，隐藏标题栏和底栏
                onExited: displayHeaderAndBottom(true) // 关闭离开，显示标题栏和底栏
                onMouseXChanged: { // 光标x值变化，发生移动
                    timer.stop()
                    cursorShape = Qt.ArrowCursor // 光标变为不怕箭头
                    timer.start()
                }
                onClicked: { // 点击事件
                    displayHeaderAndBottom(true) // 显示 标题栏和底栏
                    timer.stop()
                }
            }

        }
        Frame{ // 右侧歌词区
            Layout.preferredWidth: parent.width*0.60
            Layout.fillHeight: true

            background: Rectangle{
                color: "#0000AAAA"
            }

            visible: !layoutHeaderView.isSmallWindow // 处于小窗模式时 隐藏

            MusicLyricView{ // 歌词控件
                id:lyricView
                anchors.fill: parent
            }
        }
    }

    Timer{ // 定时器
        id:timer
        interval: 3000
        onTriggered: {
            mouseArea.cursorShape = Qt.BlankCursor // 光标隐藏
            displayHeaderAndBottom(false) // 不在首页就隐藏 标题栏和底栏
        }
    }


    // 显示或隐藏标题栏和底栏
    function displayHeaderAndBottom(visible = true){
        // 正在首页时一定显示，不在首页时根据要求显示进行显示或隐藏
        layoutHeaderView.visible = pageHomeView.visible||visible
        layoutBottomView.visible = pageHomeView.visible||visible
    }
}

















