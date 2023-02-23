import 'dart:convert';

GetCityListModel getCityListModelFromJson(String str) => GetCityListModel.fromJson(json.decode(str));

String getCityListModelToJson(GetCityListModel data) => json.encode(data.toJson());

class GetCityListModel {
  GetCityListModel({
    required this.status,
    required this.message,
    required this.district,
  });

  int status;
  String message;
  List<District> district;

  factory GetCityListModel.fromJson(Map<String, dynamic> json) => GetCityListModel(
    status: json["status"],
    message: json["message"],
    district: List<District>.from(json["district"].map((x) => District.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "district": List<dynamic>.from(district.map((x) => x.toJson())),
  };
}

class District {
  District({
    required this.districtId,
    required this.districtName,
    required this.stateId,
  });

  String districtId;
  String districtName;
  String stateId;

  factory District.fromJson(Map<String, dynamic> json) => District(
    districtId: json["DISTRICT_ID"],
    districtName: json["DISTRICT_NAME"],
    stateId: json["STATE_ID"],
  );

  Map<String, dynamic> toJson() => {
    "DISTRICT_ID": districtId,
    "DISTRICT_NAME": districtName,
    "STATE_ID": stateId,
  };
}