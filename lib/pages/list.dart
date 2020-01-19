import 'package:flutter/material.dart';
import 'package:shopping_list/models/items.dart';
import 'package:shopping_list/DatabaseHelper.dart';
import 'package:shopping_list/pages/itemlist.dart';
import 'package:shopping_list/pages/shopstate.dart';
import 'package:provider/provider.dart';

class ShopList extends StatefulWidget {
  @override
  ShopListState createState() => new ShopListState();
}
class ShopListState extends State<ShopList> {
  List<Widget> sliversShop = new List<Widget>();
  bool _showAllShop=true;
  Map<String, bool> _showShop = new Map<String, bool>();
  DatabaseHelper _shopDB;
  List<Map> _shopNameList=new List<Map>();
  int _shopNameCnt=0;
  List<List<Items>> shopItemAllList=new List<List<Items>>();
  bool isEdit=false;
  bool isLoadPic=false;
  ScrollController _controller = new ScrollController();
  bool isFresh=false;
  @override
  void initState(){
    super.initState();
    //sliversShop.clear();
    //sliversShop.addAll(_sliversZero());
    _readConfig();
  }
  _readConfig() async {
    _shopDB = DatabaseHelper();
    _getShopName();
  }
  @override
  Widget build(BuildContext context) {
    final _setter = Provider.of<ShopState>(context);
    _setter.clsItemsMap();
    _setter.addItemsMap(_shopNameList,shopItemAllList);
    print(_setter.itemsMap);
    return new Scaffold(
      appBar: new AppBar(
          title: FlatButton.icon(
            icon:  Icon(_showAllShop ? Icons.keyboard_arrow_down:Icons.keyboard_arrow_right,color: Colors.white,size: 30.0,),
            label: Text("清单",style:TextStyle(color: Colors.white,fontSize: 25.0,),),
            onPressed: (){
              setState(() {
                _showAllShop=!_showAllShop;
                _setter.setShowShop(_showAllShop);
                if(!_showAllShop)
                  _controller.jumpTo(0);
              });
            },
          ),
          //backgroundColor: Color.fromARGB(255, 119, 136, 213), //设置appbar背景颜色
          //centerTitle: true, //设置标题是否局中
          actions: <Widget>[
            DropdownButton(
              onChanged: (T){
                setState(() {
                  _setter.setShowType(T);
                });
              },
              items: <DropdownMenuItem>[
                DropdownMenuItem(
                  child:const Text("  纯图  "),
                  value:1,
                ),
                DropdownMenuItem(
                  child:const Text("  纯文  "),
                  value:2,
                ),
                DropdownMenuItem(
                  child:const Text("  图文  "),
                  value:3,
                ),
              ],
              hint:const Text('  图文  '),
              value: _setter.showTypeShop,
              style: const TextStyle(//设置文本框里面文字的样式
                  color: Colors.black
              ),
              elevation:4,
              iconSize: 0.0,
            ),
            DropdownButton(
              onChanged: (T){
                setState(() {
                  _setter.setColumnCnt(T);
                });
              },
              items: <DropdownMenuItem>[
                DropdownMenuItem(
                  child:const Text("  单列  "),
                  value:1,
                ),
                DropdownMenuItem(
                  child:const Text("  双列  "),
                  value:2,
                ),
                DropdownMenuItem(
                  child:const Text("  三列  "),
                  value:3,
                ),
              ],
              hint:const Text('  双列  '),
              value: _setter.columnCntShop,
              style: const TextStyle(//设置文本框里面文字的样式
                  color: Colors.black
              ),
              elevation:4,
              iconSize: 0.0,
            ),
          ]
      ),
      body: new Center(
        child: new CustomScrollView(
          controller: _controller,
          slivers:_buildGrids(_setter),
        ),
      ),
    );
  }
  List<Widget> _sliversZero() {
    List<Widget> _listGrids=new List<Widget>();
    _listGrids.add(SliverToBoxAdapter(
      child: Container(
        alignment: Alignment.center,
        //color: Colors.cyan[100 * (index % 9)],
        child: new Text('没有数据！'),
      ),
    ));
    return _listGrids;
  }
  List<Widget> _buildGrids(ShopState _setter) {
    List<Widget> _listGrids=new List<Widget>();
    if(_shopNameCnt==0)
    {
      _listGrids.add(SliverToBoxAdapter(
        child: Container(
          alignment: Alignment.center,
          //color: Colors.cyan[100 * (index % 9)],
          child: new Text('没有数据！'),
        ),
      ));
      return _listGrids;
    }
    _listGrids.add(SliverToBoxAdapter(
      child: Container(
      ),
    ));
    _setter.showShop.forEach((k,v){
      print(k);
      List<Items> tLItem=List<Items>();
      //var tempL=_setter.itemListAll.where((item)=> item.shopName==k);
      var tempL=_setter.itemsMap[k];
      tLItem.addAll(tempL);

      print("长度："+tLItem.length.toString());
      isLoadPic=true;
      _listGrids.add(ItemList(
        itemsL:tLItem,
        showList:_setter.showShop[k],
        headerName:k,
      )
      );
    });

/*
    for(int sliverIndex=0;sliverIndex<_setter.showShop;sliverIndex++)
    {
      print('sliverIndex: $sliverIndex');
      print(_shopNameList[sliverIndex]["shopName"]);
      print("长度："+shopItemAllList[sliverIndex].length.toString());
      isLoadPic=true;
      _listGrids.add(ItemList(
        itemsL:shopItemAllList[sliverIndex],
        showList:_showShop[_shopNameList[sliverIndex]["shopName"]],
        headerName:_shopNameList[sliverIndex]["shopName"],
      )
      );
    }*/
    print("_listGrids="+_listGrids.length.toString());
    //sliversShop.addAll(_listGrids);
    return _listGrids;
  }
  _getShopName() async {
    List<List<Items>> tempAllList=new List<List<Items>>();
    List<Map> _tList= await _shopDB.selectItemsJson(where:'cnt>0',groupBy:'shopName',orderBy:'no');
    print(_tList);
    for (var value in _tList) {
      String shopName=value["shopName"];
      tempAllList.add(await _getShopItem(shopName));
      if(!_showShop.containsKey(shopName))
        _showShop.putIfAbsent(shopName,()=> true);
    }

    print(_showShop);
    setState(() {
      _shopNameList=_tList;
      _shopNameCnt=_shopNameList.length;
      print(tempAllList);
      shopItemAllList.clear();
      shopItemAllList.addAll(tempAllList);
      //sliversShop.clear();
      //sliversShop.addAll(_buildGrids());
      print(shopItemAllList.length.toString());
      print(shopItemAllList);
    });
  }
  Future<List> _getShopItem(String _shopName) async {
    List<Items> _tempMapList = new List<Items>();
    _tempMapList = await _shopDB.selectItems(where:"cnt>0 and shopName='"+_shopName+"'");

    _tempMapList.where((item) => item.id==1);
    return _tempMapList;
  }
}
