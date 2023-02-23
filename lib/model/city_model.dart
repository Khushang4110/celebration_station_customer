class CityModel {
  CityModel({
    this.districtId,
    this.districtName,
    this.stateId,
  });

  String? districtId;
  String? districtName;
  String? stateId;

  factory CityModel.fromJson(Map<String, dynamic> json) => CityModel(
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
