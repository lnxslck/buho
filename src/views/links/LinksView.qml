import QtQuick 2.9
import QtQuick.Controls 2.4
import org.kde.mauikit 1.0 as Maui

import "../../widgets"
import "../../utils/owl.js" as O

import Links 1.0
import Owl 1.0

Maui.Page
{
    id: control

    property alias cardsView : cardsView
    property alias previewer : previewer
    property alias model : linksModel

    property var currentLink : ({})

    signal linkClicked(var link)

    headBarVisible: !cardsView.holder.visible

    margins: space.big
    headBarExit: false
    headBarTitle : cardsView.count + " links"
    headBar.leftContent: [
        Maui.ToolButton
        {
            iconName: cardsView.gridView ? "view-list-icons" : "view-list-details"
            onClicked: cardsView.gridView = !cardsView.gridView

        },
        Maui.ToolButton
        {
            iconName: "view-sort"
            onClicked: sortMenu.open();

            Menu
            {
                 id: sortMenu
                MenuItem
                {
                    text: qsTr("Title")
                    onTriggered: linksModel.sortBy(KEY.TITLE, "ASC")
                }

                MenuItem
                {
                    text: qsTr("Color")
                    onTriggered: linksModel.sortBy(KEY.COLOR, "ASC")
                }

                MenuItem
                {
                    text: qsTr("Add date")
                    onTriggered: linksModel.sortBy(KEY.ADD_DATE, "DESC")
                }

                MenuItem
                {
                    text: qsTr("Updated")
                    onTriggered: linksModel.sortBy(KEY.UPDATED, "DESC")
                }
                MenuItem
                {
                    text: qsTr("Fav")
                    onTriggered: linksModel.sortBy(KEY.FAV, "DESC")
                }
            }

        }
    ]

    headBar.rightContent: [
        Maui.ToolButton
        {
            iconName: "tag-recents"

        },

        Maui.ToolButton
        {
            iconName: "edit-pin"

        },

        Maui.ToolButton
        {
            iconName: "view-calendar"

        }
    ]

    Previewer
    {
        id: previewer
        onLinkSaved: cardsView.currentItem.update(link)
    }

    LinksModel
    {
        id: linksModel
    }

    CardsView
    {
        id: cardsView
        anchors.fill: parent
        onItemClicked: linkClicked(cardsView.model.get(index))
        holder.emoji: "qrc:/Astronaut.png"
        holder.isMask: false
        holder.title : "No Links!"
        holder.body: "Click here to save a new link"
        holder.emojiSize: iconSizes.huge
        itemHeight: unit * 250
        model: linksModel

        Connections
        {
            target: cardsView.holder
            onActionTriggered: newLink()
        }

        Connections
        {
            target: cardsView.menu
            onDeleteClicked: if(O.removeLink(cardsView.model.get(cardsView.currentIndex)))
                                 cardsView.model.remove(cardsView.currentIndex)
        }
    }
}
