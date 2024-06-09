/** 网格热门控件 **/

import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtQml 2.12

Item{
    property alias list: gridRepeater.model // 把list传给gridRepeater.model

    Grid{
        id:gridLayout
        anchors.fill: parent
        columns: 3

        padding: 5

        Repeater{ // 重复控件
            id:gridRepeater
            Frame{
                // padding: 5
                width: parent.width*0.333
                height: parent.width*0.1
                background: Rectangle{
                    id:background
                    color: "#00000000"
                }

                clip: true

                // 图片
                MusicBorderImage{
                    id:img
                    width: parent.width*0.25
                    height: parent.width*0.25
                    imgSrc: modelData.album.picUrl // 获取封面，与api返回有关
                }
                // 文本内容
                Text{
                    id:name
                    anchors{
                        left: img.right
                        verticalCenter: parent.verticalCenter // 垂直对齐
                        bottomMargin: 10
                        leftMargin: 5
                    }
                    text: modelData.album.name // 文本内容
                    font{
                        family: window.mFONT_FAMILY
                        pointSize: 10
                    }
                    height: 30
                    width: parent.width*0.72
                    // 超出宽度自动省略
                    elide: Qt.ElideRight // 显示中间

                    color: "#eeffffff"
                }

                // 文本内容
                Text{
                    anchors{
                        left: img.right
                        top: name.bottom

                        leftMargin: 5
                    }
                    text: modelData.artists[0].name // 文本内容
                    font{
                        family: window.mFONT_FAMILY
                    }
                    height: 30
                    width: parent.width*0.72
                    // 超出宽度自动省略
                    elide: Qt.ElideRight // 显示中间
                    color: "#eeffffff"
                }

                MouseArea{
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor // 手型光标
                    onEntered: { // 光标进入
                        background.color = "#50ffffff"
                    }
                    onExited: { // 光标离开
                        background.color = "#00000000"
                    }
                    onClicked: { // 点击事件
                        layoutBottomView.current = -1 // 先置为-1
                        layoutBottomView.playList = [{
                                                        id:list[index].id,
                                                        name:list[index].name,
                                                        artist:list[index].artists[0].name,
                                                        album:list[index].album.name,
                                                        cover:list[index].album.picUrl,
                                                        type:"0"
                                                    }]
                        layoutBottomView.current = 0 // 将第1个置为当前
                    }
                }
            }
        }
    }
}



















