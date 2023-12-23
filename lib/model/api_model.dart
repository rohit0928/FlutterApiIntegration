class ProductModel {
  int id;
  String title;
  String description;
  double price;
  double discountPercentage;
  double rating;
  double stock;
  String brand;
  String category;
  String thumbnail;
  List<String> images;

  ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.brand,
    required this.category,
    required this.thumbnail,
    required this.images,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["id"],
        title: json['title'],
        description: json["description"],
        price: (json["price"] as num).toDouble(),
        discountPercentage: (json["discountPercentage"] as num).toDouble(),
        rating: (json["rating"] as num).toDouble(),
        stock: (json["stock"] as num).toDouble(),
        brand: json["brand"],
        category: json["category"],
        thumbnail: json["thumbnail"],
        images: List<String>.from(json["images"].map((x) => x)),
      );
}
