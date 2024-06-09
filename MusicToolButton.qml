import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

ToolButton {
    property string iconSource: ""
    property string toolTip: ""


    property bool isChecked: false
    property bool isCheckable: false


    id: self

    icon.source: iconSource

    // MusicToolTip{ // 提示
    //     visible: parent.hovered
    //     text: toolTip
    // }
    ToolTip.visible: hovered
    ToolTip.text: toolTip

    background: Rectangle{
        color: self.down || (isCheckable&&self.checked)? "#eeeeee":"#00000000"
    }

    icon.color: self.down || (isCheckable&&self.checked) ? "#00000000":"#eeeeee"

    checked: isChecked
    checkable: isCheckable

}
