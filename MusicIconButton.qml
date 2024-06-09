import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

Button {
    property string iconSource: ""
    property string toolTip: ""


    property bool isChecked: false
    property bool isCheckable: false


    property int iconWidth: 32
    property int iconHeight: 32

    id: self

    icon.source: iconSource
    icon.width: iconWidth
    icon.height: iconHeight

    // MusicToolTip{ // 提示
    //     visible: parent.hovered
    //     text: toolTip
    // }
    ToolTip.visible: hovered
    ToolTip.text: toolTip

    background: Rectangle{
        color: self.down || (isCheckable&&self.checked)? "#497563":"#20e9f4ff"
        radius: 3
    }

    icon.color: self.down || (isCheckable&&self.checked) ? "#ffffff":"#e2f0f8"

    checked: isChecked
    checkable: isCheckable

}
