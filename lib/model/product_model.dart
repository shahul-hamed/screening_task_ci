import 'package:hive/hive.dart';

part 'product_model.g.dart'; // Required for code generation

@HiveType(typeId: 0)
class Product {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final dynamic price;

  Product({required this.id, required this.title, required this.price});
}
