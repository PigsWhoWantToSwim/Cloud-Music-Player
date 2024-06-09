/** 列表控件 **/

import QtQuick 2.12
import QtQuick.Shapes 1.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12
import QtQml 2.12



Frame{
    // 存放搜索到的歌曲
    property var musicList: []
    property int all: 0 // 搜索的的内容总数
    property int pageSize: 60 // 每页的内容条数
    property int current: 0 // 当前页面

    // 删除按钮和收藏按钮 是否可见
    property bool deletable: true
    property bool favoritable: true

    // 信号 加载更多的数据
    signal loadMore(int offset, int current)

    // 删除一首歌曲
    signal deleteItem(int index)

    // 搜索到的歌曲 发生改变
    onMusicListChanged: {
        listViewModel.clear() // 清空旧内容
        listViewModel.append(musicList) // 重新添加新内容
    }

    Layout.fillWidth: true
    Layout.fillHeight: true

    clip: true
    padding: 0


    background: Rectangle{ // 背景
        color: "#00000000"
    }

    ListView{
        id:listView
        anchors.fill: parent
        anchors.bottomMargin: 70
        model: ListModel{ // 列表模式
            id:listViewModel
        }

        // 表的内容
        delegate: listViewDelegate
        // ScrollBar.vertical: ScrollBar{ // 滚动条靠右
        //     anchors.right: parent.right
        // }
        // 取消滚动条
        // ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
        // ScrollBar.vertical.policy: ScrollBar.AlwaysOff

        header: listViewHeader // 表头

        // 高亮
        highlight: Rectangle{
            color: "#20f0f0f0"
        }
        highlightMoveDuration: 0
        highlightResizeDuration: 0
    }

    // 内容行
    Component{
        id:listViewDelegate
        Rectangle{ // 矩形
            id:listViewDelegateItem
            height:40
            width:listView.width
            color: "#00000000"

            Shape{
                anchors.fill: parent
                ShapePath{
                    strokeWidth: 0
                    strokeColor: "#50ffffff"
                    strokeStyle: ShapePath.SolidLine
                    startX: 0
                    startY: 40
                    // 从起点画线
                    PathLine{
                        x:0
                        y:40
                    }
                    PathLine{
                        x: listViewDelegateItem.width
                        y:40
                    }

                }
            }

            MouseArea{
                RowLayout{ // 水平布局
                    width: parent.width
                    height: parent.height
                    spacing: 15 // 间距
                    x:5 // x值

                    Text{
                        text: index+1+pageSize*current
                        horizontalAlignment: Qt.AlignHCenter // 水平居中
                        Layout.preferredWidth: parent.width*0.1
                        font.family: window.mFONT_FAMILY
                        font.pointSize: 12
                        color: "#eeffffff"
                        elide: Qt.ElideRight // 超出范围显示
                    }
                    Text{
                        text: name
                        // horizontalAlignment: Qt.AlignHCenter // 水平居中
                        Layout.preferredWidth: parent.width*0.4
                        font.family: window.mFONT_FAMILY
                        font.pointSize: 12
                        color: "#eeffffff"
                        elide: Qt.ElideRight // 超出范围显示
                    }
                    Text{
                        text: artist
                        horizontalAlignment: Qt.AlignHCenter // 水平居中
                        Layout.preferredWidth: parent.width*0.12
                        font.family: window.mFONT_FAMILY
                        font.pointSize: 12
                        color: "#eeffffff"
                        elide: Qt.ElideMiddle // 超出范围显示
                    }
                    Text{
                        text: album
                        horizontalAlignment: Qt.AlignHCenter // 水平居中
                        Layout.preferredWidth: parent.width*0.12
                        font.family: window.mFONT_FAMILY
                        font.pointSize: 12
                        color: "#eeffffff"
                        elide: Qt.ElideMiddle // 超出范围显示
                    }
                    Item{
                        Layout.preferredWidth: parent.width*0.24
                        RowLayout{
                            anchors.centerIn: parent
                            MusicIconButton{
                                iconSource: "qrc:/images/stop"
                                iconHeight: 16
                                iconWidth: 16
                                toolTip: "播放"
                                onClicked: {
                                    layoutBottomView.current =  -1
                                    layoutBottomView.playList = musicList
                                    layoutBottomView.current = index // 当前播放的歌曲改变
                                }
                            }
                            MusicIconButton{
                                visible: favoritable
                                iconSource: "qrc:/images/favorite"
                                iconHeight: 16
                                iconWidth: 16
                                toolTip: "收藏"
                                onClicked: {
                                    // 保存歌曲
                                    layoutBottomView.saveFavorite({
                                                                    id:musicList[index].id,
                                                                    name:musicList[index].name,
                                                                    artist:musicList[index].artist,
                                                                    url:musicList[index].url?musicList[index].url:"",
                                                                    album:musicList[index].album,
                                                                    type:musicList[index].type?musicList[index].type:"0"
                                                                  })
                                }
                            }

                            MusicIconButton{
                                visible: deletable
                                iconSource: "qrc:/images/clear"
                                iconHeight: 16
                                iconWidth: 16
                                toolTip: "删除"
                                onClicked: deleteItem(index) // 删除
                            }
                        }
                    }
                }

                anchors.fill: parent
                hoverEnabled: true // 使能悬停
                cursorShape: Qt.PointingHandCursor

                // 事件
                onEntered: {
                    color= "#20f0f0f0"
                }
                onExited: {
                    color= "#00000000"
                }
                onClicked: {
                    listViewDelegateItem.ListView.view.currentIndex = index
                }
            }
        }

    }

    // 表头
    Component{
        id:listViewHeader
        Rectangle{ // 矩形
            color: "#3000AAAA"
            height:40
            width:listView.width

            RowLayout{ // 水平布局
                width: parent.width
                height: parent.height
                spacing: 15 // 间距
                x:5 // x值

                Text{
                    text: "序号"
                    horizontalAlignment: Qt.AlignHCenter // 水平居中
                    Layout.preferredWidth: parent.width*0.1
                    font.family: window.mFONT_FAMILY
                    font.pointSize: 12
                    color: "#eeffffff"
                    elide: Qt.ElideRight // 超出范围显示
                }
                Text{
                    text: "歌名"
                    // horizontalAlignment: Qt.AlignHCenter // 水平居中
                    Layout.preferredWidth: parent.width*0.4
                    font.family: window.mFONT_FAMILY
                    font.pointSize: 12
                    color: "#eeffffff"
                    elide: Qt.ElideRight // 超出范围显示
                }
                Text{
                    text: "歌手"
                    horizontalAlignment: Qt.AlignHCenter // 水平居中
                    Layout.preferredWidth: parent.width*0.12
                    font.family: window.mFONT_FAMILY
                    font.pointSize: 12
                    color: "#eeffffff"
                    elide: Qt.ElideMiddle // 超出范围显示
                }
                Text{
                    text: "专辑"
                    horizontalAlignment: Qt.AlignHCenter // 水平居中
                    Layout.preferredWidth: parent.width*0.12
                    font.family: window.mFONT_FAMILY
                    font.pointSize: 12
                    color: "#eeffffff"
                    elide: Qt.ElideMiddle // 超出范围显示
                }
                Text{
                    text: "操作"
                    horizontalAlignment: Qt.AlignHCenter // 水平居中
                    Layout.preferredWidth: parent.width*0.24
                    font.family: window.mFONT_FAMILY
                    font.pointSize: 12
                    color: "#eeffffff"
                    elide: Qt.ElideRight // 超出范围显示
                }

            }
        }
    }

    // 分页按钮
    Item{
        id:pageButton
        visible: musicList.length!==0 && all!==0 // 根据内容条是否为0 判断显示
        width: parent.width
        height: 40
        anchors.top: listView.bottom // 在listView下面
        anchors.topMargin: 20

        // 互斥按钮组
        ButtonGroup{
            buttons: buttons.children
        }

        // 水平布局
        RowLayout{
            id:buttons
            anchors.centerIn: parent

            // 重复控件
            Repeater{
                id:repeater
                // model为数字，则为重复数量
                model: all/pageSize > 9? 9:all/pageSize// 总数/每页数量，最多取9

                // 按钮
                Button{
                    Text{
                        anchors.centerIn: parent // 在父控件中居中
                        text: modelData + 1 // modelData为按钮自身索引
                        font.family: window.mFONT_FAMILY
                        font.pointSize: 10
                        color:checked?"#497563":"eeffffff" // 根据选中改变颜色
                    }
                    // 背景
                    background: Rectangle{
                        implicitHeight: 30
                        implicitWidth: 30
                        color: checked?"#e2f0f8":"#20e9f4ff" // 根据选中改变颜色
                        radius: 3
                    }

                    checkable: true // 可选中
                    checked: modelData===current // 按钮自身索引等于当前索引

                    onClicked: { // 点击事件，切换页面
                        if(modelData===current) // 点击当前选中的按钮
                            return

                        // current = index // 更改当前索引
                        loadMore(current*pageSize, index) // 发出加载信号
                    }
                }
            }
        }
    }
}




















