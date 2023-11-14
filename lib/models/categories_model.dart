class CategoriesModel {
  late final bool status;
  late final CategoriesDataModel? data;

  CategoriesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = CategoriesDataModel.fromJson(json['data']);
  }
}

class CategoriesDataModel {
  List<DataModel> data = [];
  CategoriesDataModel.fromJson(Map<String, dynamic> json) {
    json['data'].forEach((value) => data.add(DataModel.fromJson(value)));
  }
}

class DataModel {
  late final int id;
  late final String name;
  late final String image;
  DataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }
}
