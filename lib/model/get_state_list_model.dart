// To parse this JSON data, do
//
//     final getStateListModel = getStateListModelFromJson(jsonString);

import 'dart:convert';

GetStateListModel getStateListModelFromJson(String str) => GetStateListModel.fromJson(json.decode(str));

String getStateListModelToJson(GetStateListModel data) => json.encode(data.toJson());

class GetStateListModel {
  GetStateListModel({
    required this.status,
    required this.message,
    required this.states,
  });

  int status;
  String message;
  List<States> states;

  factory GetStateListModel.fromJson(Map<String, dynamic> json) => GetStateListModel(
    status: json["status"],
    message: json["message"],
    states: List<States>.from(json["states"].map((x) => States.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "states": List<dynamic>.from(states.map((x) => x.toJson())),
  };
}

class States {
  States({
    required this.stateId,
    required this.stateName,
    required this.countryId,
  });

  String stateId;
  String stateName;
  String countryId;

  factory States.fromJson(Map<String, dynamic> json) => States(
    stateId: json["STATE_ID"],
    stateName: json["STATE_NAME"],
    countryId: json["COUNTRY_ID"],
  );

  Map<String, dynamic> toJson() => {
    "STATE_ID": stateId,
    "STATE_NAME": stateName,
    "COUNTRY_ID": countryId,
  };
}
