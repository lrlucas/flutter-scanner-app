
class DirectionModel {
  int id;
  String value;

  DirectionModel({this.id, this.value});



  factory DirectionModel.fromJson(Map<String, dynamic> json) => DirectionModel(
    id: json["id"],
    value: json["value"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "value": value,
  };
}
