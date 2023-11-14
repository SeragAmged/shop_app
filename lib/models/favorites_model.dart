class FavoritesModel {
  late final bool status;
  late final Data? data;

  FavoritesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = Data.fromJson(json['data']);
  }
}

class Data {
  List<FavoritesData> data = [];

  Data.fromJson(Map<String, dynamic> json) {
    json['data'].forEach((v) => data.add(FavoritesData.fromJson(v)));
  }
}

class FavoritesData {
  late final int id;
  late final Product product;

  FavoritesData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    product = Product.fromJson(json['product']);
  }
}

class Product {
  late final int id;
  dynamic price;
  dynamic oldPrice;
  dynamic discount;
  late final String image;
  late final String name;
  late final String description;

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    oldPrice = json['old_price'];
    discount = json['discount'];
    image = json['image'];
    name = json['name'];
    description = json['description'];
  }
}
