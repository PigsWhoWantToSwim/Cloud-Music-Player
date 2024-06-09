import QtQuick 2.12
import QtQuick.Layouts 1.3
import QtQml 2.12

Rectangle {

    property alias lyrics: list.model // 歌词
    property alias current: list.currentIndex // 当前的歌词索引

    id:lyricView

    Layout.preferredHeight:parent.height*0.8
    Layout.alignment: Qt.AlignHCenter

    clip: true

    color: "#00000000"

    ListView{
        id:list
        anchors.fill: parent

        model: ["暂无歌词","暂无歌词","暂无歌词"]
        delegate: listDelegate

        currentIndex: 0 // 当前索引

        highlight: Rectangle{ // 高亮
            color: "#2073a7db"
        }
        highlightMoveDuration: 0 // 高亮改变时的持续时间
        highlightResizeDuration: 0

        // 高亮位置
        preferredHighlightBegin: parent.height/2-40
        preferredHighlightEnd: parent.height/2

        // 根据高亮改变 当前索引currentIndex
        highlightRangeMode: ListView.StrictlyEnforceRange
    }

    Component{
        id:listDelegate

        Item{ // 内容，放置歌词
            id:delegateItem
            width: parent.width
            height: 40

            // 歌词内容
            Text{
                text: modelData
                anchors.centerIn: parent
                color: index===list.currentIndex?"#eeffffff":"#aaffffff"
                font.family: window.mFONT_FAMILY
                font.pointSize: 10
            }

            // 状态，用于高亮
            states: State {
                // 处于当前控件时
                when: delegateItem.ListView.isCurrentItem

                PropertyChanges { // 状态改变
                    target: delegateItem // 目标对象
                    scale: 1.2 // 进行缩放
                }
            }

            // 鼠标区域
            MouseArea{
                anchors.fill: parent
                onClicked: list.currentIndex = index // 设置当前索引
            }
        }
    }
}























