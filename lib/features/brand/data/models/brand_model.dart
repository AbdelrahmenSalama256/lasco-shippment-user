class BrandModel {
  final String? id;
  final String imageUrl;
  final String name;
  final String? categories;
  final String? address;

  BrandModel({
    this.id,
    required this.imageUrl,
    required this.name,
    this.categories,
    this.address,
  });
}
