
import 'dart:async';

import 'package:path/path.dart';
import 'package:shopping_list/models/items.dart';
import 'package:shopping_list/models/shops.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  final String tableItems = 'items';
  final String tableCustomers = 'customer';
  final String tableShops = 'shops';

  final String columnId = 'id';
  final String image = 'image';
  final String url = 'url';
  final String duration = 'duration';
  final String title = 'title';
  final String favoriteStatus = 'favorite_status';

  static Database _db;

  DatabaseHelper.internal();

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();

    return _db;
  }

  initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'shop.db');

    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $tableItems (id INTEGER PRIMARY KEY, name TEXT, shopName TEXT,customer TEXT,refprice REAL,realprice REAL,price REAL,exRate REAL,earn REAL, cnt INTEGER, picPath TEXT, tips TEXT, createby TEXT, createon DATETIME, updateby TEXT, updateon DATETIME)');
    await db.execute(
        'CREATE TABLE $tableCustomers (id INTEGER PRIMARY KEY, name TEXT, tel TEXT,addr TEXT,debt REAL, tips TEXT, createby TEXT, createon DATETIME, updateby TEXT, updateon DATETIME)');
    await db.execute(
        'CREATE TABLE $tableShops (id INTEGER PRIMARY KEY, name TEXT, no INTEGER)');
  }

  Future<int> insertItems(Items items) async {
    var dbClient = await db;
    var resultTemp = Sqflite.firstIntValue(
        await dbClient.rawQuery("SELECT COUNT(*) FROM $tableShops where name='"+items.shopName+"'"));
    if(resultTemp<1){
      Shops shops=new Shops();
      shops.name=items.shopName;
      if(items.shopName=='上水')
        shops.no=9999;
      else
        shops.no=0;
      await dbClient.insert(tableShops, shops.toJson());
    }
    int result=0;
    await dbClient.insert(tableItems, items.toJson()).then((id) {
          result = id;});
    print("result:"+result.toString());
    return result;
  }
  Future<List<Map>> selectItemsJson2({String where,String groupBy,String orderBy,int limit, int offset}) async {
    var dbClient = await db;
    var result =await dbClient.query("$tableItems as i,$tableShops as s",
        columns: ['i.id', 'i.name', 'i.shopName', 's.no'],
        where: 's.name=i.shopName',
        //whereArgs: ['i.name']
    );

    //await dbClient.rawQuery("'SELECT i.id,i.name,i.shopName,i.customer,s.no FROM $tableItems as i,$tableShops as s where s.name=i.name'");

    return result;
  }
  ///orderBy ASC/DESC
  Future<List<Map>> selectItemsJson({String where,String groupBy,String orderBy,int limit, int offset}) async {
    var dbClient = await db;
    String tSQL="select i.id,i.name,i.shopName,i.customer,i.cnt,i.picPath,i.tips,i.createon,s.no";
    String tWhere=where;
    if(tWhere!=null && tWhere!='')
      tWhere=' and '+tWhere;
    else
      tWhere='';
    String tGroupBy=groupBy;
    if(tGroupBy!=null && tGroupBy!=''){
      tGroupBy=' GROUP BY '+tGroupBy;
      tSQL="select i.shopName,s.no";
    }
    else
      tGroupBy='';
    String tOrderBy=orderBy;
    if(tOrderBy!=null && tOrderBy!='')
      tOrderBy=' ORDER BY '+tOrderBy;
    else
      tOrderBy='';
    var result =await dbClient.rawQuery('''
      $tSQL
      from $tableItems as i,$tableShops as s where s.name=i.shopName$tWhere$tGroupBy$tOrderBy''');

    return result;
  }
  Future<List<Map>> selectShops() async {
    var dbClient = await db;
    List<String> columns=["i.shopName"];
    var result = await dbClient.query(
      "$tableItems as i,$tableShops as s",
      columns: columns,
      where:"s.name=i.shopName",
      groupBy:"i.shopName",
      orderBy:"s.no",
    );
    return result;
  }
  Future<List> selectShopsNames() async {
    var dbClient = await db;
    List<String> columns=["i.*"];
    var result = await dbClient.query(
      "$tableItems as i,$tableShops as s",
      columns: columns,
      where:"s.name=i.shopName and i.cnt>0",
      orderBy:"s.no",
    );
    List<Items> videos = [];
    result.forEach((item) => videos.add(Items.fromJson(item)));
    return videos;
  }
  Future<List> selectItems({String where,String groupBy,String orderBy,int limit, int offset}) async {
    var dbClient = await db;
    var result = await dbClient.query(
      tableItems,
      //columns: items,
      where:where,
      groupBy:groupBy,
      orderBy:orderBy,
      limit: limit,
      offset: offset,
    );
    List<Items> videos = [];
    result.forEach((item) => videos.add(Items.fromJson(item)));
    return videos;
  }
  Future<int> updateItems(Items items) async {
    var dbClient = await db;
    var result = await dbClient.update(tableItems, items.toJson(),where: "id = ?", whereArgs: <dynamic>[items.id]);

    return result;
  }
  Future<int> getCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(
        await dbClient.rawQuery('SELECT COUNT(*) FROM $tableItems'));
  }

  Future<Items> getItems(int id) async {
    var dbClient = await db;
    List<Map> result = await dbClient.query(tableItems,
        columns: [columnId, image, url, duration, title, favoriteStatus],
        where: '$id = ?',
        whereArgs: [id]);

    if (result.length > 0) {
      return Items.fromJson(result.first);
    }

    return null;
  }

  Future<int> deleteNote(String images) async {
    var dbClient = await db;
    return await dbClient
        .delete(tableItems, where: '$image = ?', whereArgs: [images]);
  }

  Future<int> updateNote(Items items) async {
    var dbClient = await db;
    return await dbClient.update(tableItems, items.toJson(),
        where: "$columnId = ?", whereArgs: [items.id]);
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}