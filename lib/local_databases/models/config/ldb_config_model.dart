import '../../tables/config/ldb_config_table.dart';

class LDBConfigModel {
  dynamic id, name, value;

  LDBConfigModel({
    this.id,
    this.name,
    this.value,
  });

  LDBConfigModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    value = json["value"];
  }

  Map<String, dynamic> toJson() => {
        LDBConfigTable.id: id,
        LDBConfigTable.name: name,
        LDBConfigTable.value: value,
      };
}
