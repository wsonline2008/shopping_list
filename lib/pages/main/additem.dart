import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shopping_list/models/items.dart';
import 'package:shopping_list/DatabaseHelper.dart';
import 'package:shopping_list/pages/shopstate.dart';
import 'package:provider/provider.dart';

class AddItem extends StatefulWidget {
  AddItem({Key key,this.listOffset: 0,this.items,@required this.onChanged,@required this.onNew})
      : super(key: key);
  final double listOffset;
  final Items items;
  final ValueChanged<Items> onChanged;
  final ValueChanged<bool> onNew;
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  List<Map> _shopNameList=new List();
  List<DropdownMenuItem<String>> _dropDownMenuItems=new List<DropdownMenuItem<String>>();
  String _selectedFruit;
  String _shopName;
  TextEditingController _nameC = TextEditingController();
  TextEditingController _shopNameC = TextEditingController();
  TextEditingController _cntC = TextEditingController();
  TextEditingController _tipsC = TextEditingController();
  TextEditingController _imputC = TextEditingController();
  FocusNode nodeName = FocusNode();
  FocusNode nodeImput = FocusNode();
  DatabaseHelper db= new DatabaseHelper();
  int _imputLen=0;
  Items itemSave=new Items();
  int newId=-1;
  bool isEdit=false;
  bool setPosition=false;
  BuildContext get context;

  @override
  void initState() {
    super.initState();
    getShops();
    //db = DatabaseHelper();
    if(widget.items!=null && widget.items.id>-1){
      _shopName=widget.items.shopName;
      _nameC.text=widget.items.name;
      _shopNameC.text=widget.items.shopName;
      _selectedFruit=_shopNameC.text;
      _cntC.text=widget.items.cnt.toString();
      _tipsC.text=widget.items.tips;
      if(widget.items.picPath!='')
        imgList.add(widget.items.picPath);
    }
    print("itemsid:"+widget.items.id.toString());
    /*
    WidgetsBinding.instance.addPostFrameCallback((callback){
      WidgetsBinding.instance.addPersistentFrameCallback((callback){
        if (nodeImput.hasFocus && setPosition && _imputC.text.length>0 && _imputC.text.length!=_imputLen) {
          setPosition=false;
          _imputLen=_imputC.text.length;
          //_imputC.selection=TextSelection.fromPosition(TextPosition(
          //    affinity: TextAffinity.downstream,
          //    offset: _imputLen));
        }
        if(!nodeImput.hasFocus)
          setPosition=true;
      });
    });
    _imputC.addListener((){
      print("控制器的addListener，"
          "\ntextEditingController.value查看输出的全部信息，信息为${_imputC.value}"
          "\n实时输出文本框具体信息为：${_imputC.value.text}");
    });
*/

    setState(() {

    });


  }
  @override
  void dispose() {
    _closeDB();
    super.dispose();
  }
  _closeDB() async {
    //await db.close();
  }

  Widget build(BuildContext context) {
    print("手机宽高：");
    print(MediaQuery.of(context).size);
    //final _setter = Provider.of<ShopState>(context);
    // This example adds a green border on tap down.
    // On tap up, the square changes to the opposite state.
    return GestureDetector(
      //onTapDown: _handleTapDown, // Handle the tap events in the order that
      //onTapUp: _handleTapUp,     // they occur: down, up, tap, cancel
      //onTap: _handleTap,
      //onTapCancel: _handleTapCancel,
      child: Scaffold(
        appBar: new AppBar(
          title: FlatButton.icon(
            icon:  Icon(Icons.arrow_back,color: Colors.white,size: 0.0,),
            label: Text("新增物品",style:TextStyle(color: Colors.white,fontSize: 25.0,),),
            onPressed: (){
              print("退出");
              setState(() {
                Navigator.pop(context);
                //Navigator.of(context).pop(itemSave);
              });
            },
          ),
        ),
        body: new Container(
//        color: Colors.pink,
          margin: new EdgeInsets.all(10.0),
          child: new ListView(
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child:
                      Card(),
                    ),
                    Expanded(
                      flex: 1,
                      child:
                      RaisedButton(
                        onPressed: (){
                          _save(context);
                        },
                        child: Text('保存'),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child:
                      Card(),
                    ),
                  ]
              ),
              TextField(
                focusNode: nodeName,
                controller: _nameC,
                keyboardType: TextInputType.text,
                textInputAction:TextInputAction.done,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10.0),
                  icon: Icon(Icons.note_add),
                  labelText: '请输入物品名称,最好是唯一的',
                  //helperText: '物品名称最好是唯一的',
                ),
                onSubmitted: (value) {
                  _save(context);
                },
                onChanged: (value) {
                  if(value.length>0)
                    searchImage(value);
                },
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child:
                      TextField(
                        controller: _shopNameC,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10.0),
                          icon: Icon(Icons.shop),
                          labelText: '请输入商店名称,默认:上水',
                          //helperText: '在哪个商店购物',
                        ),
                        autofocus: false,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child:
                      DropdownButton(
                        onChanged: (T){
                          setState(() {
                            _selectedFruit = T;
                            _shopNameC.text= T;
                          });
                        },
                        items: _dropDownMenuItems,
                        //hint:const Text('上水'),
                        value: _selectedFruit,
                        style: const TextStyle(//设置文本框里面文字的样式
                            color: Colors.black
                        ),
                        elevation:4,
                        iconSize: 0.0,
                      ),
                    ),
                  ]
              ),
              TextField(
                controller: _cntC,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10.0),
                  icon: Icon(Icons.confirmation_number),
                  labelText: '请输入物品数量,可以留空,默认:1',
                  //helperText: '可以留空，默认为1',
                  hintText:'1',
                ),
                inputFormatters: [
                  WhitelistingTextInputFormatter(RegExp("[0-9]")),
                ],
                onTap: () {

                },
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child:
                      Card(),
                    ),
                    Expanded(
                      flex: 2,
                      child:
                      RaisedButton(
                        onPressed: (){
                          getImage();
                        },
                        child: Text('选择图片'),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child:
                      RaisedButton(
                        onPressed: (){
                          setState(() {
                            imgList.clear();
                          });
                        },
                        child: Text('清除'),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child:
                      Card(),
                    ),
                  ]
              ),

              imgList.length>0?(imgList[0]==''?Image.asset('pic/empty.jpg',width:1,height:1):Image.file(new File(imgList[0]))):Image.asset('pic/empty.jpg',width:1,height:1),
              TextField(
                controller: _tipsC,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10.0),
                  icon: Icon(Icons.note),
                  labelText: '请输入备注信息,可以留空',
                  //helperText: '可以留空',
                ),
                autofocus: false,
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child:
                      Card(),
                    ),
                    Expanded(
                      flex: 1,
                      child:
                      RaisedButton(
                        onPressed: (){
                          _save(context);
                        },
                        child: Text('保存'),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child:
                      Card(),
                    ),
                  ]
              ),
              TextField(
                focusNode: nodeImput,
                controller: _imputC,
                maxLines:4,
                textInputAction:TextInputAction.newline,//这个设置后onSubmitted无效
                //keyboardType: TextInputType.text,
                //textInputAction:TextInputAction.join,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10.0),
                  //icon: Icon(Icons.note_add),
                  labelText: '批量导入,一行一个物品',
                  helperText: '格式:物品名称？数量？购买商店？备注',
                ),
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child:
                      Card(),
                    ),
                    Expanded(
                      flex: 2,
                      child:
                      RaisedButton(
                        onPressed: (){
                          _saveAll(context);
                        },
                        child: Text('批量导入'),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child:
                      Card(),
                    ),
                  ]
              ),
            ],
          ),
        ),
      ),
    );
  }
  void _saveAll(BuildContext context) {
    final _setter = Provider.of<ShopState>(context);
    if(_imputC.text=='')
    {
      showDialog(
          context: context,
          builder: (_) => new AlertDialog(
              title: new Text("提示"),
              content: new Text("请输入批量导入内容！"),
              actions:<Widget>[
                //new FlatButton(child:new Text("CANCEL"), onPressed: (){
                //  Navigator.of(context).pop();
                //},),
                new FlatButton(child:new Text("确定"), onPressed: (){
                  Navigator.of(context).pop();
                },)
              ]
          ));
      return;
    }
    List lines = _imputC.text.split("\n");
    for (int i = 0; i < lines.length; i++) {
      //Items itemsAdd = new Items();
      lines[i] = lines[i].replaceAll("、", ".");
      if(lines[i].length>2)
      {
        if(lines[i].substring(1,2)==".")
          lines[i]=lines[i].substring(2);
        if(lines[i].substring(2,3)==".")
          lines[i]=lines[i].substring(3);
      }
      lines[i] = lines[i].replaceAll("？", "?");
      lines[i] = lines[i].replaceAll("*", "?");
      lines[i] = lines[i].replaceAll("(", "??");
      lines[i] = lines[i].replaceAll("（", "??");
      lines[i] = lines[i].replaceAll("图)", "");
      lines[i] = lines[i].replaceAll("图）", "");
      List<String> chars = lines[i].split("?");
      if(chars[0]=="")
        continue;
      Items itemS=new Items();
      itemS.name=chars[0];
      searchImage(_nameC.text);

      if(chars.length>1) {
        if (chars[1] == "")
          chars[1] = '1';
        itemS.cnt=int.parse(chars[1]);
      }
      else
        itemS.cnt=1;
      if(chars.length>2) {
        if (chars[2] == "")
          chars[2] = _selectedFruit;
        if (chars[2] == "")
          chars[2] = '上水';
        itemS.shopName=chars[2];
      }
      else{
        if(_selectedFruit=='')
          itemS.shopName='上水';
        else
          itemS.shopName=_selectedFruit;
      }
      if(chars.length>3) {
        itemS.tips=chars[3];
      }
      else
        itemS.tips='';
      itemS.picPath=imgList.length>0?imgList[0]:'';
      _saveShopItem(_setter,itemS);
    }
    _setter.getShopItem();
    setState(() {
      _imputC.clear();
      _nameC.clear();
      _shopNameC.clear();
      _cntC.clear();
      imgList.clear();
      _tipsC.clear();
      FocusScope.of(context).requestFocus(FocusNode());
      //FocusScope.of(context).autofocus(nodeName);
    });
  }
  void _save(BuildContext context) {
    final _setter = Provider.of<ShopState>(context);
    itemSave.id=-1;
    if(_nameC.text=='')
      {
        showDialog(
            context: context,
            builder: (_) => new AlertDialog(
                title: new Text("提示"),
                content: new Text("物品名不能留空！"),
                actions:<Widget>[
                  //new FlatButton(child:new Text("CANCEL"), onPressed: (){
                  //  Navigator.of(context).pop();
                  //},),
                  new FlatButton(child:new Text("确定"), onPressed: (){
                    Navigator.of(context).pop();
                  },)
                ]
            ));
        return;
      }
    if(_cntC.text=='')
      _cntC.text='1';
    if(_shopNameC.text=='')
      if(_selectedFruit=='')
        _shopNameC.text='上水';
      else
        _shopNameC.text=_selectedFruit;

    Items itemS=new Items();

    itemS.name=_nameC.text;
    itemS.shopName=_shopNameC.text;
    itemS.cnt=int.parse(_cntC.text);
    itemS.picPath=imgList.length>0?imgList[0]:'';
    itemS.tips=_tipsC.text;
    if(widget.items!=null && widget.items.id>-1){
      itemS.id=widget.items.id;
      isEdit=true;
      _updateShopItemEx(itemS);
      if(_shopName==itemS.shopName)
        widget.onChanged(itemS);
      else
        _setter.getShopItem();
    }
    else
      _saveShopItem(_setter,itemS);
    _nameC.clear();
    _shopNameC.clear();
    _cntC.clear();
    imgList.clear();
    _tipsC.clear();
    setState(() {
      FocusScope.of(context).requestFocus(FocusNode());
      if(!isEdit)
        FocusScope.of(context).autofocus(nodeName);
      else
        Navigator.pop(context);
    });
  }
  List imgList=new List<String>();
  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if(image!=null){
      imgList.clear();
      setState(() {
        imgList.add(image.path);
      });
    }
  }
  searchImage(String name) async {
    List<Map> _tList= await db.selectItemsJson(where:"i.name='"+name+"' and picPath<>''");
    if(_tList.length>0){
      imgList.clear();
      setState(() {
        imgList.add(_tList[0]["picPath"]);
      });
    }
  }
  getShops() async {
    _shopNameList = await db.selectShops();
    _dropDownMenuItems.clear();
    for(var name in _shopNameList){
      _dropDownMenuItems.add(DropdownMenuItem(
        child:Text(name['shopName']),
        value:name['shopName'],
      ),);
    }
    if(_dropDownMenuItems.length==0)
      _dropDownMenuItems.add(DropdownMenuItem(
        child:Text('上水'),
        value:'上水',
      ),);
    if(widget.items!=null && widget.items.id>-1){

    }
    else{
      _selectedFruit = '上水';
      _shopNameC.text= '上水';
    }
    setState(() {

    });
  }

  _saveShopItem(ShopState _setter,Items items) async {
    //var db = DatabaseHelper();
    int _id = 0;
    items.updateby='admin';
    items.updateon=DateTime.now().millisecondsSinceEpoch;
    items.createby='admin';
    items.createon=DateTime.now().millisecondsSinceEpoch;
    print(DateTime.fromMillisecondsSinceEpoch(items.createon) );
    _id = await db.insertItems(items);
    items.id=_id;
    _setter.addNewItemShop(items);
  }
  _updateShopItemEx(Items items) async {
    items.updateon=DateTime.now().millisecondsSinceEpoch;
    items.updateby='admin';
    var result=await db.updateItems(items);
    print(result);
  }

}

