import 'package:hive/hive.dart';
import 'package:truck_app/models/index.dart';

part 'truck.g.dart'; // Make sure this points to the correct file

@HiveType(typeId: 1)
class Truck extends HiveObject {
  @HiveField(0)
  final String truckName;
  @HiveField(1)
  final String thumbnailImageUrl;
  @HiveField(2)
  List<FoodItem>? foodList;
  @HiveField(3)
  String? map;

  //<editor-fold desc="Data Methods">
  Truck({
    required this.truckName,
    required this.thumbnailImageUrl,
    this.foodList,
    this.map,
  });

  @override
  String toString() {
    return 'Truck{ truckName: $truckName, thumbnailImageUrl: $thumbnailImageUrl, foodList: $foodList , map:$map}';
  }

  Truck copyWith({
    String? truckName,
    String? thumbnailImageUrl,
    List<FoodItem>? foodList,
    String? map,
  }) {
    return Truck(
      truckName: truckName ?? this.truckName,
      thumbnailImageUrl: thumbnailImageUrl ?? this.thumbnailImageUrl,
      foodList: foodList ?? this.foodList,
      map: map ?? this.map,
    );
  }

//</editor-fold>
}
