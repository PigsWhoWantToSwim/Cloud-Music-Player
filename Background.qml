import QtQuick 2.12
// import QtGraphicalEffects 1.0
import Qt5Compat.GraphicalEffects

Rectangle {
    property bool showDefaultBackground: true // 显示默认阴影

    Image { // 背景图片
        id: backgroundImage
        source: showDefaultBackground?"qrc:/images/player":layoutBottomView.musicCover
        anchors.fill:parent
        fillMode: Image.PreserveAspectCrop
    }

    ColorOverlay{ // 图形渲染
        id:backgroundImageOverlay
        anchors.fill:backgroundImage
        source: backgroundImage
        color: "#35000000" // 黑色加上透明度
    }

    FastBlur{ // 模糊效果
        anchors.fill: backgroundImageOverlay
        source: backgroundImageOverlay
        radius: 80 // 模糊半径
    }
}
