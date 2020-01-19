class Items {
  int id;
  String name;
  String shopName;
  String customer;
  num refprice;
  num realprice;
  num price;
  num exRate;
  num earn;
  int cnt;
  String picPath;
  String tips;
  String createby;
  int createon;
  String updateby;
  int updateon;
  //bool favoriteStatus;

  Items(
      {this.id,
        this.name,
        this.shopName,
        this.customer,
        this.refprice,
        this.realprice,
        this.price,
        this.exRate,
        this.earn,
        this.cnt,
        this.picPath,
        this.tips,
        this.createby,
        this.createon,
        this.updateby,
        this.updateon
      });

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    shopName = json['shopName'];
    customer = json['customer'];
    refprice = json['refprice'];
    realprice = json['realprice'];
    price = json['price'];
    exRate = json['exRate'];
    earn = json['earn'];
    cnt = json['cnt'];
    picPath = json['picPath'];
    tips = json['tips'];
    createby = json['createby'];
    createon = json['createon'];
    updateby = json['updateby'];
    updateon = json['updateon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if(this.id!=null && this.id>-1)
      data['id'] = this.id;
    if(this.name!=null && this.name!='')
      data['name'] = this.name;
    if(this.shopName!=null && this.shopName!='')
      data['shopName'] = this.shopName;
    if(this.customer!=null && this.customer!='')
      data['customer'] = this.customer;
    if(this.refprice!=null)
      data['refprice'] = this.refprice;
    if(this.realprice!=null)
      data['realprice'] = this.realprice;
    if(this.price!=null)
      data['price'] = this.price;
    if(this.exRate!=null)
      data['exRate'] = this.exRate;
    if(this.earn!=null)
      data['earn'] = this.earn;
    if(this.cnt!=null)
      data['cnt'] = this.cnt;
    if(this.picPath!=null)
      data['picPath'] = this.picPath;
    if(this.tips!=null)
      data['tips'] = this.tips;
    if(this.createby!=null)
      data['createby'] = this.createby;
    if(this.createon!=null)
      data['createon'] = this.createon;
    if(this.updateby!=null)
      data['updateby'] = this.updateby;
    if(this.updateon!=null)
      data['updateon'] = this.updateon;

    return data;
  }
}