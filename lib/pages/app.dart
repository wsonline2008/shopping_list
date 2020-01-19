/**
 * APP的主入口文件
 */
import 'dart:io';
import 'dart:async';
//import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_guohe/common/eventBus.dart';
import 'package:shopping_list/pages/main/kb.dart';
//import 'package:flutter_guohe/pages/main/leftmenu.dart';
import 'package:shopping_list/pages/main/playground.dart';
//import 'package:shopping_list/pages/main/today.dart';
import 'package:shopping_list/pages/main/additem.dart';
import 'package:shopping_list/DatabaseHelper.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shopping_list/models/items.dart';
import 'dart:ui';
/**
 * APP的主入口文件
 */


//果核的主界面
class Guohe extends StatefulWidget {
  @override
  GuoheState createState() => new GuoheState();
}

class GuoheState extends State<Guohe> with SingleTickerProviderStateMixin {
  TabController controller;
  List<Widget> sliversShop = new List<Widget>();
  int _columnCntShop=2;
  double _picHeightShop=140;
  int _showTypeShop=3;
  bool _showAllShop=true;
  Map<String, bool> _showShop = new Map<String, bool>();
  DatabaseHelper _shopDB;
  List<Map> _shopNameList=new List<Map>();
  int _shopNameCnt=0;
  List<List<Map>> shopItemAllList=new List<List<Map>>();
  double _listOffset=0;
  bool isEdit=false;
  bool isLoadPic=false;
  Items itemEdit = new Items();
  BuildContext get context;

  @override
  void initState() {
    var s = window.physicalSize;
    print(s);
    controller = new TabController(length: 4, vsync: this);//length底部导航数量
    //sliversShop.addAll(_buildGrids( 0, 3,_columnCntShop));
    _readConfig();
    //WidgetsBinding=WidgetsBinding.instance;
    WidgetsBinding.instance.addPostFrameCallback((callback){
      WidgetsBinding.instance.addPersistentFrameCallback((callback){
        //print("addPersistentFrameCallback be invoke");
        //触发一帧的绘制
        //WidgetsBinding.instance.scheduleFrame();
        print("WidgetsBinding listOffset:"+_listOffset.toString());
        //print(sliversShop.length.toString());
        //if (!_addItemShow && _controller!=null && isLoadPic && _controller?.offset == 0 && _listOffset>2) {
        //  _controller.jumpTo(_listOffset-1);
        //  _listOffset=0;
        //}
      });
    });
    super.initState();
  }
  @override
  void didUpdateWidget(Guohe oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('***************didUpdateWidget***************');
  }
  @override
  void deactivate() {
    super.deactivate();
    print("***************deactive***************");
  }
  @override
  void reassemble() {
    super.reassemble();
    print("***************reassemble***************");
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("***************didChangeDependencies***************");
  }
  @override
  void dispose() {
    _closeDB();
    controller.dispose();
    super.dispose();
  }
  _closeDB() async {
    await _shopDB.close();
  }
  _getShopName() async {
    //var _shopDB = DatabaseHelper();
    //List<Map> _tempList = await _shopDB.rawQuery('SELECT shopName FROM items where cnt>0 GROUP BY shopName');
    //List<Items> _tempList =await _shopDB.selectItems(where:'cnt>0',groupBy:'shopName');
    //_shopDB.close();
    List<List<Map>> tempAllList=new List<List<Map>>();
    //if(shopItemAllList!=null && shopItemAllList.length>0)
    //  shopItemAllList.clear();
    List<Map> _tList= await _shopDB.selectItemsJson(where:'cnt>0',groupBy:'shopName',orderBy:'no');
    print(_tList);
    //_showShop.clear();
    //_showShop.add(true);
    for (var value in _tList) {
      String shopName=value["shopName"];
      tempAllList.add(await _getShopItem(shopName));
      //_tList.add(value.toJson());
      if(!_showShop.containsKey(shopName))
        _showShop.putIfAbsent(shopName,()=> true);
    }

    print(_showShop);
    //print(shopItemAllList);
    //List<Map> _tempMapList2 = new List<Map>();
    //_tempMapList2 = await _shopDB.selectItemsJson();
    //print(_tempMapList2);
    setState(() {
      _shopNameList=_tList;
      _shopNameCnt=_shopNameList.length;
      print(tempAllList);
      shopItemAllList.clear();
      shopItemAllList.addAll(tempAllList);
      print(shopItemAllList);
      //shopItemAllList=tempAllList;
    });
  }
  Future<List<Map>> _getShopItem(String _shopName) async {
    List<Items> _tempMapList = new List<Items>();
    List<Map> _tempMapListNew = new List<Map>();

    //var _shopDB = DatabaseHelper();
    //_tempMapList = await _shopDB.rawQuery('SELECT * FROM items where shopName=? and cnt>0',[_shopName]);
    _tempMapList = await _shopDB.selectItems(where:"cnt>0 and shopName='"+_shopName+"'");

    //_shopDB.close();
    for (var value in _tempMapList) {
      _tempMapListNew.add(value.toJson());
    }
    return _tempMapListNew;
    //setState(() {
    //  shopItemAllList.add(_tempMapListNew);
    //});
  }
  _updateShopItem(int _id,int _cnt) async {
    Items items= new Items();
    items.id=_id;
    items.cnt=_cnt;
    items.updateon=DateTime.now().millisecondsSinceEpoch;
    //var _shopDB = DatabaseHelper();
    await _shopDB.updateItems(items);
    //_shopDB.close();
    //await _shopDB.rawUpdate('Update items SET cnt=? where id=?',[_cnt,_id]);
  }

  _readConfig() async {
    _shopDB = DatabaseHelper();
    setState(() {
      _getShopName();
    });
  }

  List<Widget> _buildGrids() {
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
    _listGrids.add(_buildHeader(0,Colors.blue[500]));

    for(int sliverIndex=0;sliverIndex<_shopNameCnt;sliverIndex++)
    {
      int _listMax=_columnCntShop;
      print('sliverIndex: $sliverIndex');
      print(_shopNameList[sliverIndex]["shopName"]);
      int _shopItemCnt=shopItemAllList[sliverIndex].length;
      isLoadPic=true;
      _listGrids.add(SliverStickyHeader(
        header: _buildHeader(sliverIndex,Colors.blue[500]),
        sliver: //Offstage(
        //offstage: _showShop[sliverIndex],
        //child:
        new SliverGrid(
          gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: _listMax, crossAxisSpacing: 0, mainAxisSpacing: 0),
          delegate: new SliverChildBuilderDelegate(
                (context, i) =>
                _item(sliverIndex,i,shopItemAllList[sliverIndex][i]["cnt"]),
            childCount: _showShop[_shopNameList[sliverIndex]["shopName"]]?_shopItemCnt:0,
          ),
        ),
        //),
      ));
    }
    return _listGrids;
  }
  List<Widget> _buildGrids2() {
    return List.generate(_shopNameCnt, (sliverIndex) {
      int _listMax=_columnCntShop;
      print('sliverIndex: $sliverIndex');
      print(_shopNameList[sliverIndex]["shopName"]);
      //int _shopItemAllCnt=shopItemAllList.length;
      int _shopItemCnt=shopItemAllList[sliverIndex].length;
      //print(shopItemAllList);
      isLoadPic=true;

      return new SliverStickyHeader(
        header: _buildHeader(sliverIndex,Colors.blue[500]),
        sliver: //Offstage(
        //offstage: _showShop[sliverIndex],
        //child:
        new SliverGrid(
          gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: _listMax, crossAxisSpacing: 0, mainAxisSpacing: 0),
          delegate: new SliverChildBuilderDelegate(
                (context, i) =>
                _item(sliverIndex,i,shopItemAllList[sliverIndex][i]["cnt"]),
            childCount: _showShop[_shopNameList[sliverIndex]["shopName"]]?_shopItemCnt:0,
          ),
        ),
        //),
      );
    });
    //});
  }
  Widget _item(int _sliverIndex,int _index,int _cnt) {
    return GestureDetector(//GridTileBar
      //onSingleTapConfirmed: () =>
      //    Scaffold.of(context).showSnackBar(
      //        new SnackBar(content: Text('Grid tile #$i'))),
      //color:Color(0x11FF0000),
      child:
      Container(
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
          _words(_sliverIndex, _index,10.0+2.0*(3-_columnCntShop)),
          Stack(
            alignment: const Alignment(1, 1),
            children: [

                Stack(
                    alignment: const Alignment(-1, -1),
                    children: [
                      Image.file(new File(shopItemAllList[_sliverIndex][_index]["picPath"]), width: double.infinity,height: _picHeightShop),
                      Row(
                        //crossAxisAlignment: CrossAxisAlignment.start, //垂直方向 向左靠齐
                          mainAxisAlignment: MainAxisAlignment.start, //垂直方向 向左靠齐
                          children: <Widget>[
                            Stack(
                                alignment: const Alignment(-1, -1),
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
                                      _updateShopItem(shopItemAllList[_sliverIndex][_index]["id"],0);
                                      setState(() {
                                        shopItemAllList[_sliverIndex].removeAt(_index);
                                      });
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
                                      print("offset:0");
                                      if(_controller!=null){
                                        print("offset:1");
                                        print("offset:"+_controller.offset.toString());
                                        _listOffset=_controller.offset;
                                        print("offset:2");
                                      }
                                      print("offset:3");
                                      setState(() {
                                        itemEdit.id=shopItemAllList[_sliverIndex][_index]["id"];
                                        itemEdit.name=shopItemAllList[_sliverIndex][_index]["name"];
                                        itemEdit.shopName=shopItemAllList[_sliverIndex][_index]["shopName"];
                                        itemEdit.cnt=shopItemAllList[_sliverIndex][_index]["cnt"];
                                        itemEdit.picPath=shopItemAllList[_sliverIndex][_index]["picPath"];
                                        itemEdit.tips=shopItemAllList[_sliverIndex][_index]["tips"];
                                      });
                                      Navigator.push(context,
                                          new MaterialPageRoute(builder: (context) => new AddItem(
                                            items: itemEdit,)));
                                    },
                                  ),
                                ]
                            ),
                          ]),
                    ]
                ),
                //Image.network("https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1559101957724&di=d886539da30736502620bb58c77259e4&imgtype=0&src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fitem%2F201404%2F15%2F20140415093826_SzcNe.thumb.700_0.jpeg", fit: BoxFit.cover,width: double.infinity),

              new Container(
                child: _cnts(_sliverIndex,_index,_cnt),
              ),
            ],
          ),

        ],
      ),
      ),
    ),
    );
  }
  ScrollController _controller = new ScrollController();
  Widget _shopList(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
            title: FlatButton.icon(
              icon:  Icon(_showAllShop ? Icons.keyboard_arrow_down:Icons.keyboard_arrow_right,color: Colors.white,size: 30.0,),
              label: Text("清单",style:TextStyle(color: Colors.white,fontSize: 25.0,),),
              onPressed: (){
                setState(() {
                  _showAllShop=!_showAllShop;
                  _showShop.keys.forEach((f){
                    _showShop[f]=_showAllShop;
                    if(!_showAllShop)
                      _controller.jumpTo(0);
                  });
                });
              },
            ),
            //backgroundColor: Color.fromARGB(255, 119, 136, 213), //设置appbar背景颜色
            //centerTitle: true, //设置标题是否局中
            actions: <Widget>[
              DropdownButton(
                onChanged: (T){
                  setState(() {
                    _showTypeShop=T;
                    if(_showTypeShop==2)
                      _picHeightShop=1;
                    else{
                      if(_columnCntShop==3)
                        _picHeightShop=86;
                      if(_columnCntShop==2)
                        _picHeightShop=140;
                      if(_columnCntShop==1)
                        _picHeightShop=316;
                    }
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
                value: _showTypeShop,
                style: const TextStyle(//设置文本框里面文字的样式
                    color: Colors.black
                ),
                elevation:4,
                iconSize: 0.0,
              ),
              DropdownButton(
                onChanged: (T){
                  setState(() {
                    _columnCntShop=T;
                    if(_columnCntShop==3)
                      _picHeightShop=86;
                    if(_columnCntShop==2)
                      _picHeightShop=140;
                    if(_columnCntShop==1)
                      _picHeightShop=316;
                    if(_shopNameCnt>0){
                      sliversShop.clear();
                      //sliversShop.addAll(_buildGrids());
                    }
                  });
                },
                items: <DropdownMenuItem>[
                  DropdownMenuItem(
                    child:const Text("  单图  "),
                    value:1,
                  ),
                  DropdownMenuItem(
                    child:const Text("  双图  "),
                    value:2,
                  ),
                  DropdownMenuItem(
                    child:const Text("  三图  "),
                    value:3,
                  ),
                ],
                hint:const Text('  三图  '),
                value: _columnCntShop,
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
            slivers:_buildGrids(),
          ),
        ),
      ),
    );
  }
  Widget _cnts(int _sliverIndex,int _index,int _cnt) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      //crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Stack(
            alignment: const Alignment(0, 0),
            children: [
              const IconButton(
                icon: const Icon(Icons.add),
                iconSize:24,
                padding : const EdgeInsets.all(0.0),
                color: Color(0xFFFF0000),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                iconSize:20,
                padding : const EdgeInsets.all(0.0),
                color: Color(0xFF000000),
                onPressed: () {
                  setState(() {
                    shopItemAllList[_sliverIndex][_index]['cnt']++;
                  });
                  _updateShopItem(shopItemAllList[_sliverIndex][_index]["id"],shopItemAllList[_sliverIndex][_index]['cnt']);
                },
              ),
            ]
        ),
        Stack(
            alignment: const Alignment(0, -0.5),
            children: [
              Text(_cnt.toString(), style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: Color(0x99FF0000),),),
              Text(_cnt.toString(), style: TextStyle(fontSize: 20,color: Color(0xFF000000),),),
            ]
        ),
        Stack(
            alignment: const Alignment(0, 0),
            children: [
              const IconButton(
                icon: const Icon(Icons.remove),
                iconSize:24,
                padding : const EdgeInsets.all(0.0),
                color: Color(0xFFFF0000),
              ),
              new IconButton(
                icon: const Icon(Icons.remove),
                iconSize:20,
                padding : const EdgeInsets.all(0.0),
                color: Color(0xFF000000),
                onPressed: () {
                  _updateShopItem(shopItemAllList[_sliverIndex][_index]["id"],shopItemAllList[_sliverIndex][_index]["cnt"]-1);
                  setState(() {
                    if(_cnt==1)
                      shopItemAllList[_sliverIndex].removeAt(_index);
                    else
                      shopItemAllList[_sliverIndex][_index]["cnt"]--;
                  });
                },
              ),
            ]
        ),
      ],
    );
  }
  Widget _words(int _sliverIndex,int _index,double _size) {
    String _txtName=(_index+1).toString()+"."+shopItemAllList[_sliverIndex][_index]["name"].toString();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, //垂直方向 向左靠齐
      children: <Widget>[
        Text(_txtName, style: TextStyle(fontSize: _size),
          overflow: TextOverflow.ellipsis,
          softWrap: false,),
        Text(
          "*" + shopItemAllList[_sliverIndex][_index]["cnt"].toString() + "|" + shopItemAllList[_sliverIndex][_index]["tips"], style: TextStyle(fontSize: _size),
          overflow: TextOverflow.ellipsis,
          softWrap: false,),
      ],
    );
  }
  Widget _buildHeader(int _sliverIndex,Color _color) {
    return new SliverToBoxAdapter(
      child: new Container(
        height: 50.0,
        color: _color,
        padding: EdgeInsets.symmetric(horizontal: 4.0),
        alignment: Alignment.centerLeft,
        child: FlatButton.icon(
          icon:  Icon(_showShop[_shopNameList[_sliverIndex]["shopName"]] ? Icons.keyboard_arrow_down:Icons.keyboard_arrow_right,color: Colors.white,size: 25.0,),
          label: Text(_shopNameList[_sliverIndex]["shopName"],style:TextStyle(color: Colors.white,fontSize: 20.0,),),
          onPressed: (){
            setState(() {
              _showShop[_shopNameList[_sliverIndex]["shopName"]]=!_showShop[_shopNameList[_sliverIndex]["shopName"]];
            });
          },
        ),
      )
    );
  }
  Widget _buildHeader2(int _sliverIndex,Color _color) {
    return new Container(
      height: 50.0,
      color: _color,
      padding: EdgeInsets.symmetric(horizontal: 4.0),
      alignment: Alignment.centerLeft,
      child: FlatButton.icon(
        icon:  Icon(_showShop[_shopNameList[_sliverIndex]["shopName"]] ? Icons.keyboard_arrow_down:Icons.keyboard_arrow_right,color: Colors.white,size: 25.0,),
        label: Text(_shopNameList[_sliverIndex]["shopName"],style:TextStyle(color: Colors.white,fontSize: 20.0,),),
        onPressed: (){
          setState(() {
            _showShop[_shopNameList[_sliverIndex]["shopName"]]=!_showShop[_shopNameList[_sliverIndex]["shopName"]];
          });
        },
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      //drawer: new LeftMenu(),
      body: new TabBarView(
        controller: controller,
        children: <Widget>[
          _shopList(context),
          new Kb(),
          new Playground(),
          new Playground(),
        ],
      ),
      bottomNavigationBar: new Material(
        color: Colors.white,
        child: new TabBar(
          controller: controller,
          labelColor: Colors.deepPurpleAccent,
          unselectedLabelColor: Colors.black54,
          tabs: <Widget>[
            new Tab(
              text: "清单",
              //icon: new Icon(Icons.brightness_5),
            ),
            new Tab(
              text: "客户单",
              //icon: new Icon(Icons.map),
            ),
            new Tab(
              text: "物品",
              //icon: new Icon(Icons.directions_run),
            ),
            new Tab(
              text: "设置",
              //icon: new Icon(Icons.build),
            ),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        foregroundColor: Colors.white,
        elevation: 5.0,
        onPressed: () {
          setState(() {
            itemEdit= new Items();
            itemEdit.id=-1;
            if(_controller!=null){
              _listOffset=_controller.offset;
            }
          });
          Navigator.push(context,
              new MaterialPageRoute(builder: (context) => new AddItem(
                items: itemEdit,)));
        },
        child: new Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
