class Product {
  int id;
  String name;
  double price;

  Product({required this.id, required this.name, required this.price});

  Product fromJson(json) {
    return Product(id: json['id'], name: json['name'], price: json['price']);
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'price': price};
  }
}
