class Video {
  int id;
  String image;
  String url;
  int duration;

  String title;
  bool favoriteStatus;

  Video(
      {this.id,
        this.image,
        this.url,
        this.duration,
        this.title,
        this.favoriteStatus
      });

  Video.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    url = json['url'];
    duration = json['duration'];
    title = json['title'];
    favoriteStatus = json['favorite_status'];
  }

  Video.fromSql(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    url = json['url'];
    duration = json['duration'];
    title = json['title'];
    favoriteStatus = json['favorite_status'] == 'true';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['url'] = this.url;
    data['duration'] = this.duration;
    data['title'] = this.title;
    data['favorite_status'] = this.favoriteStatus;
    return data;
  }
}