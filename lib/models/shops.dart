class Shops {
  int id;
  String name;
  int no;
  Shops(
      {this.id,
        this.name,
        this.no,
      });

  Shops.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    no = json['no'];
  }

  Shops.fromSql(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    no = json['no'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if(this.id!=null && this.id>-1)
      data['id'] = this.id;
    if(this.name!=null && this.name!='')
      data['name'] = this.name;
    if(this.no!=null)
      data['no'] = this.no;

    return data;
  }
}