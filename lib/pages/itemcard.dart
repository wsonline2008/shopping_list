import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shopping_list/models/items.dart';
import 'package:shopping_list/DatabaseHelper.dart';
import 'package:shopping_list/pages/main/additem.dart';
import 'package:provider/provider.dart';
import 'package:shopping_list/pages/shopstate.dart';

class ItemCard extends StatefulWidget {
  ItemCard({Key key,this.items,this.index,@required this.onClear})
      : super(key: key);
  final Items items;
  final int index;
  final ValueChanged<int> onClear;
  @override
  ItemCardState createState() => new ItemCardState();
}

class ItemCardState extends State<ItemCard> {
  DatabaseHelper _shopDB;
  void _handleItemSave(Items checkItems) {
    widget.items.name=checkItems.name;
    widget.items.cnt=checkItems.cnt;
    widget.items.picPath=checkItems.picPath;
    widget.items.tips=checkItems.tips;
  }
  _updateShopItem(int _id,int _cnt) async {
    Items items= new Items();
    items.id=_id;
    items.cnt=_cnt;
    items.updateon=DateTime.now().millisecondsSinceEpoch;
    await _shopDB.updateItems(items);
  }
  @override
  void initState(){
    super.initState();
    _shopDB = DatabaseHelper();
  }
  @override
  Widget build(BuildContext context) {
    final _setter = Provider.of<ShopState>(context);
    String _txtName=(widget.index+1).toString()+"."+widget.items.name.toString();
    String _txtTips="*" + widget.items.cnt.toString() + "|" + widget.items.tips;
    return Container(
      //height: _picHeightShop,
      color:Color(0x112196F3),
      child:
      Card(
        //color:Color(0x11FF0000),
        elevation:1.0,
        child:
        new Column(
          crossAxisAlignment: CrossAxisAlignment.start, //垂直方向 向左靠齐
          children: <Widget>[
            _words(_txtName, _txtTips,_setter.wordSize),
            Stack(
                alignment: const Alignment(1, 1),
                children: [

                  Stack(
                      alignment: const Alignment(-1, -1),
                      children: [
                        Image.file(new File(widget.items.picPath), width: double.infinity,height: _setter.picHeightShop),
                        Row(
                          //crossAxisAlignment: CrossAxisAlignment.start, //垂直方向 向左靠齐
                            mainAxisAlignment: MainAxisAlignment.start, //垂直方向 向左靠齐
                            children: <Widget>[
                              Stack(
                                  alignment: const Alignment(1, -1),
                                  children: [
                                    const IconButton(
                                      icon: const Icon(Icons.clear),
                                      iconSize:24,
                                      padding : const EdgeInsets.all(0.0),
                                      color: Color(0xFF000000),
                                    ),
                                    new IconButton(
                                      icon: const Icon(Icons.clear),
                                      iconSize:20,
                                      padding : const EdgeInsets.all(0.0),
                                      color: Color(0xFFFF0000),
                                      onPressed: () {
                                        _updateShopItem(widget.items.id,0);
                                        widget.onClear(widget.items.id);
                                      },
                                    ),
                                  ]
                              ),
                              Stack(
                                  alignment: const Alignment(-1, -1),
                                  children: [
                                    const IconButton(
                                      icon: const Icon(Icons.edit),
                                      iconSize:24,
                                      padding : const EdgeInsets.all(0.0),
                                      color: Color(0xFF000000),
                                    ),
                                    new IconButton(
                                      icon: const Icon(Icons.edit),
                                      iconSize:20,
                                      padding : const EdgeInsets.all(0.0),
                                      color: Color(0xFFFF0000),
                                      onPressed: () {
                                        Navigator.push<List<Items>>(context,
                                            new MaterialPageRoute(builder: (context) => new AddItem(
                                                items: widget.items,
                                                onChanged:_handleItemSave
                                            )));
                                      },
                                    ),
                                  ]
                              ),
                            ]),
                      ]
                  ),
                  //Image.network("https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1559101957724&di=d886539da30736502620bb58c77259e4&imgtype=0&src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fitem%2F201404%2F15%2F20140415093826_SzcNe.thumb.700_0.jpeg", fit: BoxFit.cover,width: double.infinity),
                  new Container(
                    child: _cnts(),
                  ),//_cnts(_sliverIndex,_index,_cnt),
                ]
            ),
          ],
        ),
      ),
    );
  }
  Widget _words(String _name,String _tips,double _wordSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, //垂直方向 向左靠齐
      children: <Widget>[
        Text(_name, style: TextStyle(fontSize: _wordSize),
          overflow: TextOverflow.ellipsis,
          softWrap: false,),
        Text(_tips, style: TextStyle(fontSize: _wordSize),
          overflow: TextOverflow.ellipsis,
          softWrap: false,),
      ],
    );
  }
  Widget _cnts() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      //crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Stack(
            alignment: const Alignment(0, 0),
            children: [
              const IconButton(
                icon: const Icon(Icons.add),
                iconSize:24,
                padding : const EdgeInsets.all(0.0),
                color: Color(0xFF000000),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                iconSize:18,
                padding : const EdgeInsets.all(0.0),
                color: Color(0xFFFF0000),
                onPressed: () {
                  setState(() {
                    widget.items.cnt++;
                  });
                  _updateShopItem(widget.items.id,widget.items.cnt);
                },
              ),
            ]
        ),
        Stack(
            alignment: const Alignment(0, -0.5),
            children: [
              Text(widget.items.cnt.toString(), style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: Color(0xFF000000),),),
              Text(widget.items.cnt.toString(), style: TextStyle(fontSize: 20,color: Color(0xFFFF0000),),),
            ]
        ),
        Stack(
            alignment: const Alignment(0, 0),
            children: [
              const IconButton(
                icon: const Icon(Icons.remove),
                iconSize:24,
                padding : const EdgeInsets.all(0.0),
                color: Color(0xFF000000),
              ),
              new IconButton(
                icon: const Icon(Icons.remove),
                iconSize:18,
                padding : const EdgeInsets.all(0.0),
                color: Color(0xFFFF0000),
                onPressed: () {
                  setState(() {
                    widget.items.cnt--;
                  });
                  _updateShopItem(widget.items.id,widget.items.cnt);
                  if(widget.items.cnt==0)
                    widget.onClear(widget.items.id);
                },
              ),
            ]
        ),
      ],
    );
  }
}