class SearchModel {
  late final bool status;
  late final Data? data;

  SearchModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = Data.fromJson(json['data']);
  }
}

class Data {
  List<Product> data = [];

  Data.fromJson(Map<String, dynamic> json) {
    json['data'].forEach((v) => data.add(Product.fromJson(v)));
  }
}

class Product {
  late final int id;
  dynamic price;
  late final String image;
  late final String name;
  late final String description;
  late final bool inFavorites;

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    inFavorites = json['in_favorites'];
    image = json['image'];
    name = json['name'];
    description = json['description'];
  }
}
