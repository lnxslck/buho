import QtQuick 2.9
import QtQuick.Controls 2.2
import org.kde.kirigami 2.2 as Kirigami
import org.kde.mauikit 1.0 as Maui

GridView
{
    id: control
    property bool gridView : true

    property alias holder : holder
    property alias menu : cardMenu
    readonly property  int defaultSize : unit * 200
    property int itemWidth : !gridView ?  width :
                                        (isMobile? width * 0.5 : unit * 400)
    property int itemHeight: unit * 120
    property int itemSpacing:  space.huge

    signal itemClicked(int index)
    boundsBehavior: !isMobile? Flickable.StopAtBounds : Flickable.DragAndOvershootBounds

    cellWidth: width > itemWidth ? width/2 : width
    cellHeight: itemHeight + itemSpacing
    topMargin: Kirigami.Units.largeSpacing * 2
    clip : true

    Maui.Holder
    {
        id: holder
        visible: count < 1
        z: 999
    }

    CardMenu
    {
        id: cardMenu
    }

    model: ListModel { id: cardsModel}

    delegate: CardDelegate
    {
        id: delegate
        cardWidth: Math.min(control.cellWidth, control.itemWidth) - Kirigami.Units.largeSpacing * 2
        cardHeight: itemHeight
        anchors.left: parent.left
        anchors.leftMargin: control.width <= control.itemWidth ? 0 : (index % 2 === 0 ? Math.max(0, control.cellWidth - control.itemWidth) :
                                                                                     control.cellWidth)

        onClicked:
        {
            currentIndex = index
            itemClicked(index)
        }

        onRightClicked:
        {
            currentIndex = index
            cardMenu.popup()
        }

        onPressAndHold:
        {
            currentIndex = index
            cardMenu.popup()
        }
    }

//    onWidthChanged: if(!isMobile && gridView) adaptGrid()

    function adaptGrid()
    {
        var amount = parseInt(width/(itemWidth + itemSpacing),10)
        var leftSpace = parseInt(width-(amount*(itemWidth + itemSpacing)), 10)
        var size = parseInt((itemWidth + itemSpacing)+(parseInt(leftSpace/amount, 10)), 10)

        size = size > itemWidth + itemSpacing ? size : itemWidth + itemSpacing

        cellWidth = size

    }

    function refresh()
    {
        model = cardsModel
    }

}
