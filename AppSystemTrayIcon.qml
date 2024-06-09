// 隐藏到系统托盘

import QtQuick 2.12
import QtQuick.Window 2.12
import Qt.labs.platform 1.1
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3


// 系统托盘
SystemTrayIcon {
    id:systemTray
    icon.source: "qrc:/images/music"
    visible: true // 默认显示

    onActivated: {
        window.show() // 显示窗口
        window.raise()
        window.requestActivate()
    }

    menu: Menu{ // 菜单
        id:menu
        MenuItem{
            text: "上一曲"
            onTriggered: layoutBottomView.playPrevious()
        }
        MenuItem{
            text: layoutBottomView.playingState===0?"播放":"暂停"
            onTriggered: layoutBottomView.playOrPause()
        }
        MenuItem{
            text: "下一曲"
            onTriggered: layoutBottomView.playNext()
        }
        MenuSeparator{} // 分隔线
        MenuItem{
            text: "显示"
            onTriggered: window.show()
        }
        MenuItem{
            text: "退出"
            onTriggered: Qt.quit()
        }
    }
}
