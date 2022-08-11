class Data {
  String? url;
  String? startDate;
  String? endDate;
  String? name;
  String? icon;
  String? objType;
  bool? loginRequired;

  Data(
      {this.url,
      this.startDate,
      this.endDate,
      this.name,
      this.icon,
      this.objType,
      this.loginRequired});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      url: json['url'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      name: json['name'],
      icon: json['icon'],
      objType: json['objType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "url": url,
      "startDate": startDate,
      "endDate": endDate,
      "name": name,
      "icon": icon,
      "objType": objType,
    };
  }
}
