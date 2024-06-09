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
        columns: 5

        Repeater{ // 重复控件
            id:gridRepeater
            Frame{
                padding: 10
                width: parent.width*0.2
                height: parent.width*0.2+30
                background: Rectangle{
                    id:background
                    color: "#00000000"
                }

                clip: true

                // 图片
                MusicBorderImage{
                    id:img
                    width: parent.width
                    height: parent.width
                    imgSrc: modelData.coverImgUrl // 获取封面，与api返回有关
                }
                // 文本内容
                Text{
                    anchors{
                        top: img.bottom
                        horizontalCenter: parent.horizontalCenter // 水平对齐
                    }
                    text: modelData.name // 文本内容
                    font{
                        family: window.mFONT_FAMILY
                    }
                    height: 30
                    width:parent.width
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    // 超出宽度自动省略
                    elide: Qt.ElideMiddle // 显示中间

                    color: "#eeffffff"
                }

                MouseArea{
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onEntered: {
                        background.color = "#50ffffff"
                    }
                    onExited: {
                        background.color = "#00000000"
                    }
                    onClicked: {
                        // 进入播放列表
                        var item = gridRepeater.model[index]
                        pageHomeView.showPlayList(item.id, "1000") // 一定是歌单
                        // 类型
                        // (1:单曲,  10:专辑,  100:歌手,  1000:歌单,  1002:用户,  1004:MV,
                        // 1006:歌词,  1009:电台,  1014:视频,  1018:综合
                    }
                }
            }
        }
    }
}



















