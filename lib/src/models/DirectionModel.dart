
class DirectionModel {
  int id;
  String value;
  int directionId;

  DirectionModel({this.id, this.value, this.directionId});



  factory DirectionModel.fromJson(Map<String, dynamic> json) =>
      DirectionModel(
        id: json["id"],
        value: json["value"],
        directionId: json["directionId"]
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "value": value,
    "directionId": directionId
  };
}
