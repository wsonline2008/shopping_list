import 'package:flutter/material.dart';
import 'package:shopping_list/pages/app.dart';
import 'package:shopping_list/models/items.dart';
import 'package:shopping_list/pages/main/additem.dart';
import 'package:shopping_list/pages/main/kb.dart';
//import 'package:flutter_guohe/pages/main/leftmenu.dart';
import 'package:shopping_list/pages/main/playground.dart';
import 'package:shopping_list/pages/list.dart';
import 'package:provider/provider.dart';
import 'package:shopping_list/pages/shopstate.dart';

void main() {
  runApp(ChangeNotifierProvider<ShopState>.value(
      value: ShopState(2,140,3,10,""),
      child: new MaterialApp(
      //title: "Flutteraa",
      home: new MainWeb(),
    )
  )
      );
}
class MainWeb extends StatefulWidget {
  @override
  MainWebState createState() => new MainWebState();
}
class MainWebState extends State<MainWeb> with SingleTickerProviderStateMixin {
  int _selectedIndex=0;
  final List<Widget> bottomTabs = [
    Tab(
      text: "清单",
    ),
    Tab(
      text: "客户单",
    ),
    Tab(
      text: "客户单",
    ),
    Tab(
      text: "设置",
    )
  ];
  TabController controller;
  @override
  void initState(){
    controller = new TabController(length: 4, vsync: this);//length底部导航数量
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final _setter = Provider.of<ShopState>(context);
    _setter.initState();
    return new Scaffold(
      bottomNavigationBar: new Material(
        color: Colors.white,
        child: new TabBar(
          controller: controller,
          labelColor: Colors.deepPurpleAccent,
          unselectedLabelColor: Colors.black54,
          tabs: bottomTabs,
          onTap: (value) {
            setState(() {
              _selectedIndex = value;
            });
          },
        ),
      ),
      body: Stack(
        children: <Widget>[
          new Offstage(
            offstage: _selectedIndex!=0, //这里控制
            child: ShopList(),
          ),
          new Offstage(
            offstage: _selectedIndex!=1, //这里控制
            child: Kb(),
          ),
          new Offstage(
            offstage: _selectedIndex!=2, //这里控制
            child: Playground(),
          ),
          new Offstage(
            offstage: _selectedIndex!=3, //这里控制
            child: Playground(),
          ),
          new Offstage(
            offstage: _selectedIndex!=4, //这里控制
            child: Playground(),
          ),
        ],
      ),

      floatingActionButton:FloatingActionButton(
          foregroundColor: Colors.white,
          elevation: 5.0,
          onPressed: () {
            Items item=new Items();
            item.id=-1;
            Navigator.push(context,
                new MaterialPageRoute(builder: (context) => new AddItem(
                  items: item,
                )));
          },
          child: Icon(Icons.add),
        ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
