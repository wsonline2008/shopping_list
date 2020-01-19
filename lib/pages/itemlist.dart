import 'package:flutter/material.dart';
import 'package:shopping_list/models/items.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:shopping_list/pages/itemcard.dart';
import 'package:provider/provider.dart';
import 'package:shopping_list/pages/shopstate.dart';

class ItemList extends StatefulWidget {
  ItemList({Key key,this.itemsL,this.showList,this.headerName,@required this.onChanged})
      : super(key: key);
  final List<Items> itemsL;
  final bool showList;
  final String headerName;
  final ValueChanged<String> onChanged;
  @override
  ItemListState createState() => new ItemListState();
}

class ItemListState extends State<ItemList> {
  bool show=true;
  List<Items> items=new List<Items>();
  void _handleClear(int id) {
    setState(() {
      items.removeWhere((item) => item.id ==id);
      if(items.length<1)
        this.dispose();
    });
  }
  @override
  void initState(){
    super.initState();
    items.addAll(widget.itemsL);
    setState(() {
      print(items);
      show=widget.showList;
    });
  }
  @override
  Widget build(BuildContext context) {
    final _setter = Provider.of<ShopState>(context);
    int _colCnt=_setter.columnCntShop;
    print("itemlist:"+widget.headerName);
    print(items.length.toString());
    print(_setter.addShopName);
    if(_setter.addShopName==widget.headerName){
      _setter.setAddShopName("");
      setState(() {
        items.add(_setter.items);
      });
    }
    print(items.length.toString());
    return SliverStickyHeader(
      header: _buildHeader(items.length),
      sliver: new SliverGrid(
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _colCnt, crossAxisSpacing: 0, mainAxisSpacing: 0),
        delegate: new SliverChildBuilderDelegate(
              (context, i) =>
              ItemCard(
                items:items[i],//items[i],
                index: i,
                onClear: _handleClear,
              ),
          childCount: show?items.length:0,
        ),
      ),
    );
  }
  Widget _buildHeader(int _cnt) {
    return new Container(
      height: 50.0,
      color: Colors.blue[500],
      padding: EdgeInsets.symmetric(horizontal: 4.0),
      alignment: Alignment.centerLeft,
      child: FlatButton.icon(
        icon:  Icon(show ? Icons.keyboard_arrow_down:Icons.keyboard_arrow_right,color: Colors.white,size: 25.0,),
        label: Text(widget.headerName+" - "+_cnt.toString(),style:TextStyle(color: Colors.white,fontSize: 20.0,),),
        onPressed: (){
          setState(() {
            show=!show;
          });
        },
      ),
    );
  }


}