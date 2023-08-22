class UserModel {
  late UserData? data;
  late int errorCode;
  late  String errorMsg;

  UserModel({required this.data, required this.errorCode, required this.errorMsg});

  UserModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new UserData.fromJson(json['data']) : null;
    errorCode = json['errorCode'];
    errorMsg = json['errorMsg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['errorCode'] = this.errorCode;
    data['errorMsg'] = this.errorMsg;
    return data;
  }
}

class UserData {
  late bool admin;
  late List<dynamic> chapterTops;
  late List<int> collectIds;
  late String email;
  late String icon;
  late int id;
  late  String nickname;
  late String password;
  late String publicName;
  late String token;
  late  int type;
  late  String username;

  UserData(
      {required this.admin,
        required this.chapterTops,
        required this.collectIds,
        required this.email,
        required this.icon,
        required this.id,
        required this.nickname,
        required  this.password,
        required  this.publicName,
        required   this.token,
        required   this.type,
        required  this.username});

  UserData.fromJson(Map<String, dynamic> json) {
    admin = json['admin'];
    if (json['chapterTops'] != null) {
      chapterTops = [];
      json['chapterTops'].forEach((v) {
        chapterTops.add(v);
      });
    }
    collectIds = json['collectIds'].cast<int>();
    email = json['email'];
    icon = json['icon'];
    id = json['id'];
    nickname = json['nickname'];
    password = json['password'];
    publicName = json['publicName'];
    token = json['token'];
    type = json['type'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['admin'] = admin;
    if (chapterTops != null) {
      data['chapterTops'] = this.chapterTops.map((v) => v.toJson()).toList();
    }
    data['collectIds'] = this.collectIds;
    data['email'] = this.email;
    data['icon'] = this.icon;
    data['id'] = this.id;
    data['nickname'] = this.nickname;
    data['password'] = this.password;
    data['publicName'] = this.publicName;
    data['token'] = this.token;
    data['type'] = this.type;
    data['username'] = this.username;
    return data;
  }
}