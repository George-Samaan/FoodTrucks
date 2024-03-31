import 'package:hive/hive.dart';


part 'food_item.g.dart';

@HiveType(typeId: 2)
class FoodItem {
  @HiveField(0)
  final String foodName;
  @HiveField(1)
  final double price;
  @HiveField(2)
  String? truckName;
  @HiveField(3)
  String? imagesFood;



  FoodItem({
    required this.foodName,
    required this.price,
    this.truckName,
     this.imagesFood,
  });


  @override
  String toString() {
    return 'FoodItem{ foodName: $foodName, price: $price, truckName: $truckName, imagesFood:$imagesFood}';
  }


  FoodItem copyWith({
    String? foodName,
    double? price,
    String? truckName,
    String? imagesFood,
  }) {
    return FoodItem(
      foodName: foodName ?? this.foodName,
      price: price ?? this.price,
      truckName: truckName ?? this.truckName,
      imagesFood: imagesFood ?? this.imagesFood,
    );
  }
}
