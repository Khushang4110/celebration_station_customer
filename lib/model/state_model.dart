class StateModel {
  String? sTATEID;
  String? sTATENAME;
  String? cOUNTRYID;

  StateModel({this.sTATEID, this.sTATENAME, this.cOUNTRYID});

  StateModel.fromJson(Map<String, dynamic> json) {
    sTATEID = json['STATE_ID'];
    sTATENAME = json['STATE_NAME'];
    cOUNTRYID = json['COUNTRY_ID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['STATE_ID'] = this.sTATEID;
    data['STATE_NAME'] = this.sTATENAME;
    data['COUNTRY_ID'] = this.cOUNTRYID;
    return data;
  }
}