class RestaurantModel {
  String? name;
  String? address;
  String? image;
  num? rating;

  RestaurantModel({this.name, this.address, this.image, this.rating});

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(
        name: json['name'],
        address: json['address'],
        rating: json['rating'],
        image: json['photo']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['address'] = address;
    data['rating'] = rating;
    data['photo'] = image;
    return data;
  }
}
