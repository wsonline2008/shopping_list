import 'package:flutter/material.dart';
import 'package:shopping_list/models/items.dart';
import 'package:shopping_list/DatabaseHelper.dart';

class Cnt extends StatefulWidget {
  Cnt({Key key,this.cnt: 1,this.id})
      : super(key: key);
  int cnt;
  int id;
  @override
  CntState createState() => new CntState();
}

class CntState extends State<Cnt> {
  DatabaseHelper _shopDB;

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
                    widget.cnt++;
                  });
                  _updateShopItem(widget.id,widget.cnt);
                },
              ),
            ]
        ),
        Stack(
            alignment: const Alignment(0, -0.5),
            children: [
              Text(widget.cnt.toString(), style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: Color(0xFF000000),),),
              Text(widget.cnt.toString(), style: TextStyle(fontSize: 20,color: Color(0xFFFF0000),),),
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
                    widget.cnt--;
                  });
                  _updateShopItem(widget.id,widget.cnt);
                },
              ),
            ]
        ),
      ],
    );
  }
}