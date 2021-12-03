import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.12
import QtQml.Models 2.15

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")

    QtObject{
        id:controller
        function update(ind){
            console.log("update")
            if(column.nullIndex !== -1 && column.previousIndex != -1){
                let obj = list.get(ind)
                console.log(obj.color)
                list.set(column.nullIndex, obj)
                list.remove(ind, 1)
                controller.change()
            }
            column.nullIndex = -1
            column.previousIndex = -1
            list.clear()
            for(let i=0; i<auxList.count; i++){
                list.append(auxList.get(i))
            }
        }
        function change(){
            console.log("change")
            auxList.clear()
            for(let i=0; i<list.count; i++){
                auxList.append(list.get(i))
            }
        }
        function replace(index){
            console.log("replace")
            if(column.previousIndex !== -1){
                if(index !== column.nullIndex){
                    if(column.nullIndex !== -1)
                        list.remove(column.nullIndex, 1)
                    column.nullIndex = index
                    list.insert(index,{"color": "transparent", "side":0})
                    controller.change()
                }
            }
        }
    }
    Button{
        id:button
        anchors.right: parent.right
        onClicked: {
            list.insert(1,{"color": "transparent", "side":0})
            controller.change()
            controller.update()
        }
    }
    ListModel{
        id:list
        Component.onCompleted: {
            list.append({"color": "blue", "side":0})
            list.append({"color": "red", "side":0})
            list.append({"color": "green", "side":0})
            list.append({"color": "pink", "side":0})
            list.append({"color": "gray", "side":0})
            list.append({"color": "yellow", "side":0})

            auxList.append({"color": "blue", "side":0})
            auxList.append({"color": "red", "side":0})
            auxList.append({"color": "green", "side":0})
            auxList.append({"color": "pink", "side":0})
            auxList.append({"color": "gray", "side":0})
            auxList.append({"color": "yellow", "side":0})
        }
    }
    ListModel{
        id:auxList
    }
    Column{
        id:column
        property int previousIndex:-1
        property int nullIndex:-1
        property int helper:-1
        Repeater{
            id:repeater
            model:list
            delegate: Rectangle{
                property int ind:index
                Drag.active: mouseArea.drag.active
                Drag.hotSpot.x : 50
                Drag.hotSpot.y: 50
                property int position: Math.pow(x, 2) + Math.pow(y, 2)
                onPositionChanged: {
                    column.previousIndex = index
                    column.helper = Math.round(y/100)
                    if(x >= 0 && x <= (column.width) && y >= 0 && y <= (column.height) - 100){
                        let height = Math.round(y/100)
                        if(height !== ind)
                            controller.replace(height)
                    }
                    else if(x > column.width){
                        controller.replace(list.count - 1)
                    }

                }
                Drag.onActiveChanged: {
                    if(mouseArea.drag.active){
                        if(ind !== list.count - 1){
                            list.move(index, list.count-1, 1)
                            controller.change()
                        }
                    }
                    else{
                        controller.update(index)
                    }
                }
                width: 100
                height: 100
                color: list.count > 0? list.get(index).color:"gray"
                MouseArea{
                    id:mouseArea
                    hoverEnabled: !mouseArea.drag.active
                    drag{
                        target: parent
                        minimumX: 0
                        maximumX: 540
                        minimumY: 0
                        maximumY: 600
                    }
                    anchors.fill: parent

                }
            }
        }


    }
}
