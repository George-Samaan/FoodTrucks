import 'dart:io';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:truck_app/models/index.dart';

class HiveClient {
  static final HiveClient _instance = HiveClient._();

  late final Box currentUserBox;
  late final Box currentCartTruckBox;
  late final Box userBox;
  late final Box truckBox;
  late final Box foodBox;
  late final Box orderBox;
  late final Box cartBox;

  factory HiveClient() {
    return _instance;
  }

  HiveClient._();

  Future<void> init() async {
    final Directory directory =
        await pathProvider.getApplicationDocumentsDirectory();
    Hive.init(directory.path);

    Hive.registerAdapter(UserAdapter());
    Hive.registerAdapter(TruckAdapter());
    Hive.registerAdapter(FoodItemAdapter());
    Hive.registerAdapter(OrderAdapter());
    Hive.registerAdapter(OrderItemAdapter());

    currentUserBox = await Hive.openBox<User>(HiveConstants.currentUserBoxKey);
    currentCartTruckBox =
        await Hive.openBox<OrderItem>(HiveConstants.currentCartTruckBox);
    userBox = await Hive.openBox<User>(HiveConstants.userBoxKey);
    foodBox = await Hive.openBox<FoodItem>(HiveConstants.foodBoxKey);
    truckBox = await Hive.openBox<Truck>(HiveConstants.truckBoxKey);
    orderBox = await Hive.openBox<Order>(HiveConstants.orderBoxKey);
    cartBox = await Hive.openBox<OrderItem>(HiveConstants.cartBoxKey);
    _addMenusToBoxes();
  }

  void _addMenusToBoxes() {
    // Create food items for Pharaoh's Falafel Wagon
    final List<FoodItem> pharaohsFalafelFoodList = [
      FoodItem(
          foodName: 'Classic Falafel Wrap',
          price: 8.50,
          imagesFood: "assets/Images/FalafelWrap.jpeg",
          truckName: 'Pharaoh\'s Falafel Wagon'),
      FoodItem(
          foodName: 'Falafel Platter',
          price: 23.50,
          imagesFood: "assets/Images/falafel platter.jpeg",
          truckName: 'Pharaoh\'s Falafel Wagon'),
      FoodItem(
          foodName: 'Falafel Sandwich',
          imagesFood: "assets/Images/falafelSandwitch.jpeg",
          price: 7.50,
          truckName: 'Pharaoh\'s Falafel Wagon'),
    ];
    // Create food items for Pharaoh's Falafel Wagon
    final List<FoodItem> bohoBunFoodList = [
      FoodItem(
          foodName: 'Philly cheese',
          price: 89.00,
          imagesFood: "assets/Images/Bohobun0.jpg",
          truckName: 'Boho Bun truck'),
      FoodItem(
          foodName: 'The dutchess burger',
          price: 105.00,
          imagesFood: "assets/Images/Bohobun1.jpg",
          truckName: 'Boho Bun truck'),
      FoodItem(
          foodName: 'Honey mustard chicken',
          price: 99.00,
          imagesFood: "assets/Images/Bohobun2.jpg",
          truckName: 'Boho Bun truck'),
      FoodItem(
          foodName: 'Buffalo Chicken',
          price: 115.00,
          imagesFood: "assets/Images/buffaloChicken.jpeg",
          truckName: 'Boho Bun truck'),
      FoodItem(
          foodName: 'BohoBun',
          price: 135.00,
          imagesFood: "assets/Images/bohobunBurger.jpeg",
          truckName: 'Boho Bun truck'),
    ];
    // Create food items for Pharaoh's Falafel Wagon
    final List<FoodItem> brgrTruckFoodList = [
      FoodItem(
          foodName: 'Atomic Sandwich',
          price: 120.00,
          imagesFood: "assets/Images/Brgr0.jpg",
          truckName: 'Brgr Truck'),
      FoodItem(
          foodName: 'The American',
          price: 75.00,
          imagesFood: "assets/Images/Brgr1.jpg",
          truckName: 'Brgr Truck'),
      FoodItem(
          foodName: 'Buffalo Chicken',
          price: 102.00,
          imagesFood: "assets/Images/Brgr2.jpeg",
          truckName: 'Brgr Truck'),
      FoodItem(
          foodName: 'Chicken American',
          price: 110.00,
          imagesFood: "assets/Images/Brgr4.jpeg",
          truckName: 'Brgr Truck'),
      FoodItem(
          foodName: 'Burger House',
          price: 95.00,
          imagesFood: "assets/Images/Brgr5.jpg",
          truckName: 'Brgr Truck'),
      FoodItem(
          foodName: 'Buffalo Chicken',
          price: 77.00,
          imagesFood: "assets/Images/bohobunBurger.jpeg",
          truckName: 'Brgr Truck'),
    ];
    // Create food items for Pharaoh's Falafel Wagon
    final List<FoodItem> flyingDogsFoodList = [
      FoodItem(
          foodName: 'Street Dog',
          price: 100.00,
          imagesFood: "assets/Images/FlyingDogs0.jpg",
          truckName: 'Flying dogs'),
      FoodItem(
          foodName: 'Scooby Doo',
          price: 85.00,
          imagesFood: "assets/Images/FlyingDogs1.jpg",
          truckName: 'Flying dogs'),
      FoodItem(
          foodName: 'Dog Father',
          price: 65.00,
          imagesFood: "assets/Images/FlyingDogs2.jpg",
          truckName: 'Flying dogs'),
      FoodItem(
          foodName: 'Fire Cheetos',
          price: 50.00,
          imagesFood: "assets/Images/FlyingDogs3.jpg",
          truckName: 'Flying dogs'),
    ];

    final List<FoodItem> shockTruckFoodList = [
      FoodItem(
          foodName: 'Triple B Burger (BBQ Bacon)',
          price: 160.00,
          imagesFood: "assets/Images/Shock2.jpeg",
          truckName: 'shock truck'),
      FoodItem(
          foodName: 'Onions & Mushroom Burger',
          price: 130.00,
          imagesFood: "assets/Images/Shock4.jpeg",
          truckName: 'shock truck'),
      FoodItem(
          foodName: 'Cheese Burger',
          price: 115.00,
          imagesFood: "assets/Images/cheeseBurger.jpg",
          truckName: 'shock truck'),
      FoodItem(
          foodName: 'The Big Mouth Burger',
          price: 180.00,
          imagesFood: "assets/Images/triple.jpeg",
          truckName: 'shock truck'),
      FoodItem(
          foodName: 'The Shocker Burger',
          price: 99.00,
          imagesFood: "assets/Images/shocker.jpeg",
          truckName: 'shock truck'),
      FoodItem(
          foodName: 'Deep Chick',
          price: 119.00,
          imagesFood: "assets/Images/friedChicken.jpg",
          truckName: 'shock truck'),
    ];

// Create food items for Nile Street Shawarma Shuttle
    final List<FoodItem> nileStreetShawarmaFoodList = [
      FoodItem(
          foodName: 'Chicken Shawarma Wrap',
          imagesFood: "assets/Images/shawermachicken.jpg",
          price: 70.00,
          truckName: 'Nile Street Shawarma Shuttle'),
      FoodItem(
          foodName: 'Beef Shawarma Platter',
          price: 160.00,
          imagesFood: "assets/Images/beefPlatter.jpeg",
          truckName: 'Nile Street Shawarma Shuttle'),
      FoodItem(
          foodName: 'Lamb Shawarma Sandwich',
          price: 99.00,
          imagesFood: "assets/Images/lambBeef.jpeg",
          truckName: 'Nile Street Shawarma Shuttle'),
    ];

// Create food items for Cairo Koshary Cart
    final List<FoodItem> cairoKosharyFoodList = [
      FoodItem(
          foodName: 'Traditional Koshary Bowl',
          price: 45.00,
          imagesFood: "assets/Images/kosharyplatter.jpeg",
          truckName: 'Cairo Koshary Cart'),
      FoodItem(
          foodName: 'Spicy Koshary Platter',
          price: 55.00,
          imagesFood: "assets/Images/spicykoshary.jpeg",
          truckName: 'Cairo Koshary Cart'),
      FoodItem(
          foodName: 'Koshary Salad',
          price: 25.00,
          imagesFood: "assets/Images/kosharySalad.jpg",
          truckName: 'Cairo Koshary Cart'),
    ];

    // Create and add Pharaoh's Falafel Wagon truck
    final Truck pharaohsFalafelTruck = Truck(
      truckName: 'Pharaoh\'s Falafel Wagon',
      foodList: pharaohsFalafelFoodList,
      thumbnailImageUrl: 'assets/Images/falafel.jpeg',
      map:"https://maps.app.goo.gl/9pmU4Pb4q2gAcqMM7",
    );
    for (var element in pharaohsFalafelFoodList) {
      element.truckName = pharaohsFalafelTruck.truckName;
    }
    final Truck BohpBunTruck = Truck(
        truckName: 'Boho Bun truck',
        foodList: bohoBunFoodList,
        thumbnailImageUrl: "assets/Images/bohobunTruck.jpeg",
        map: "https://maps.app.goo.gl/PjwM9jL4NQjMcYcK8");
    for (var element in bohoBunFoodList) {
      element.truckName = BohpBunTruck.truckName;
    }
    final Truck BrgrTruck = Truck(
        truckName: 'Brgr Truck',
        foodList: brgrTruckFoodList,
        thumbnailImageUrl: "assets/Images/BrgrTruck.jpg",
        map: "https://maps.app.goo.gl/VAzg8gCMcRKZ6L789");
    for (var element in brgrTruckFoodList) {
      element.truckName = BrgrTruck.truckName;
    }
    final Truck flyningDogsTruck = Truck(
        truckName: 'Flying dogs',
        foodList: flyingDogsFoodList,
        thumbnailImageUrl: "assets/Images/FlyingDogsTruck.jpg",
        map: "https://maps.app.goo.gl/z8bg7gWkAtKgJ2GE6");
    for (var element in flyingDogsFoodList) {
      element.truckName = flyningDogsTruck.truckName;
    }
    final Truck shockTruck = Truck(
        truckName: 'Shock truck',
        foodList: shockTruckFoodList,
        thumbnailImageUrl: "assets/Images/ShocksTruck.png",
        map: "https://maps.app.goo.gl/sV7xmbXtNHULe9kn6");
    for (var element in shockTruckFoodList) {
      element.truckName = shockTruck.truckName;
    }

    // Create and add Nile Street Shawarma Shuttle truck
    final Truck nileStreetShawarmaTruck = Truck(
      truckName: 'Nile Street Shawarma Shuttle',
      foodList: nileStreetShawarmaFoodList,
      thumbnailImageUrl: 'assets/Images/Shawerma.jpg',
      map: "https://maps.app.goo.gl/dtYUjhdPaR1GeNEc6"
    );
    for (var element in nileStreetShawarmaFoodList) {
      element.truckName = nileStreetShawarmaTruck.truckName;
    }

    // Create and add Cairo Koshary Cart truck
    final Truck cairoKosharyTruck = Truck(
        truckName: 'Cairo Koshary Cart',
        foodList: cairoKosharyFoodList,
        map: "https://maps.app.goo.gl/gTqei723nEXUScyo8",
        thumbnailImageUrl: 'assets/Images/koshary.jpeg');
    for (var element in cairoKosharyFoodList) {
      element.truckName = cairoKosharyTruck.truckName;
    }



    // Adds the trucks to the db, if the db is not empty
    if (truckBox.isEmpty) {
      truckBox.add(pharaohsFalafelTruck);
      truckBox.add(nileStreetShawarmaTruck);
      truckBox.add(cairoKosharyTruck);
      truckBox.add(BohpBunTruck);
      truckBox.add(BrgrTruck);
      truckBox.add(flyningDogsTruck);
      truckBox.add(shockTruck);
    }

    // Adds the food to the db, if the db is not empty
    if (foodBox.isEmpty) {
      foodBox.addAll(pharaohsFalafelFoodList);
      foodBox.addAll(nileStreetShawarmaFoodList);
      foodBox.addAll(cairoKosharyFoodList);
      foodBox.addAll(bohoBunFoodList);
      foodBox.addAll(brgrTruckFoodList);
      foodBox.addAll(flyingDogsFoodList);
      foodBox.addAll(shockTruckFoodList);
    }
  }
}

class HiveConstants {
  HiveConstants._();

  static const String userBoxKey = 'userBoxKey';
  static const String truckBoxKey = 'truckBoxKey';
  static const String foodBoxKey = 'foodBoxKey';
  static const String orderBoxKey = 'orderBoxKey';
  static const String currentUserBoxKey = 'currentUserBoxKey';
  static const String currentCartTruckBox = 'currentCartTruckBoxKey';
  static const String cartBoxKey = 'cartBoxKey';
}
