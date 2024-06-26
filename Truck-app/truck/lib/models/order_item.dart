import 'package:hive/hive.dart';
import 'package:truck_app/models/index.dart';

part 'order_item.g.dart';

@HiveType(typeId: 4)
class OrderItem extends FoodItem {
  @HiveField(3)
  final int count;

  OrderItem({
    required super.foodName,
    required super.price,
    super.truckName,
    required this.count,

  });

  @override
  OrderItem copyWith({
    String? foodName,
    double? price,
    int? count,
    String? truckName,
    String? imagesFood,


  }) {
    return OrderItem(
      foodName: foodName ?? this.foodName,
      price: price ?? this.price,
      truckName: truckName ?? this.truckName,
      count: count ?? this.count,

    );
  }

  @override
  String toString() {
    return 'FoodItem{ foodName: $foodName, price: $price, truckName: $truckName, count: $count }';
  }

  factory OrderItem.fromFoodItem(
    FoodItem food,
  ) {
    return OrderItem(
      foodName: food.foodName,
      price: food.price,
      truckName: food.truckName,
      count: 0,
    );
  }
}
