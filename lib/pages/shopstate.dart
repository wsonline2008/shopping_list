import 'package:flutter/material.dart';
import 'package:shopping_list/models/items.dart';
import 'package:shopping_list/DatabaseHelper.dart';

class ShopState with ChangeNotifier {
  bool _initF=true;
  int _columnCntShop=2;
  double _picHeightShop=140;
  int _showTypeShop=3;
  double _wordSize=10;
  String _addShopName="";
  Items _items=new Items();
  Map<String,List<Items>> _itemsMap=new Map<String,List<Items>>();
  List<Items> _itemListAll = new List<Items>();
  Map<String, bool> _showShop = new Map<String, bool>();
  ShopState(this._columnCntShop,this._picHeightShop,this._showTypeShop,this._wordSize,this._addShopName);
  //@override
  void initState(){
    print("初始化0");
    if(_initF){
      _initF=false;
      getShopItem();
    }
  }

  void setColumnCnt(int newValue) {
    _columnCntShop=newValue;
    if(_columnCntShop==3)
      _picHeightShop=86;
    if(_columnCntShop==2)
      _picHeightShop=140;
    if(_columnCntShop==1)
      _picHeightShop=316;
    _wordSize=10.0+2.0*(3-_columnCntShop);
    notifyListeners();
  }
  void setPicHeight(double newValue) {
    _picHeightShop=newValue;
    notifyListeners();
  }
  void setShowType(int newValue) {
    _showTypeShop=newValue;
    notifyListeners();
  }
  void setAddShopName(String newValue) {
    _addShopName=newValue;
    //notifyListeners();
  }
  void setShowShop(bool newValue) {
    _showShop.keys.forEach((k){
      _showShop[k]=newValue;
    });
    notifyListeners();
  }
  void addItemsMap(List<Map> shopName,List<List<Items>> itemsAdd) {
    for(int sliverIndex=0;sliverIndex<itemsAdd.length;sliverIndex++)
    {
      _itemsMap.addAll({shopName[sliverIndex]["shopName"]:itemsAdd[sliverIndex]});
    }
    print(_itemsMap);
    //notifyListeners();
  }
  void clsItemsMap() {
    _itemsMap.clear();
  }
  void addNewItemShop(Items newItem) {
    //print(newItem);
    _addShopName=newItem.shopName;
    print(newItem);
    _items=newItem;
    _itemsMap[newItem.shopName].add(newItem);
    print(_itemsMap[newItem.shopName]);
    notifyListeners();
  }
  void getShopItem() async {
    DatabaseHelper _shopDB = DatabaseHelper();
    _itemListAll = await _shopDB.selectShopsNames();
    _showShop.clear();
    for(int sliverIndex=0;sliverIndex<_itemListAll.length;sliverIndex++)
    {
      if(!_showShop.containsKey(_itemListAll[sliverIndex].shopName))
        _showShop.putIfAbsent(_itemListAll[sliverIndex].shopName,()=> true);
    }
    print("初始化1-0");
    print(_itemListAll);
    print("初始化1");
    notifyListeners();
  }
  get columnCntShop => _columnCntShop;
  get picHeightShop => _picHeightShop;
  get showTypeShop => _showTypeShop;
  get wordSize => _wordSize;
  get addShopName => _addShopName;
  get items => _items;
  get itemsMap => _itemsMap;
  get itemListAll => _itemListAll;
  get showShop => _showShop;

}