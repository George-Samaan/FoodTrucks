import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:truck_app/db/hive_client.dart';
import 'package:truck_app/models/index.dart';
import 'package:truck_app/screens/cart_screen.dart';
import 'package:truck_app/screens/widget/ViewImages.dart';
import 'package:url_launcher/url_launcher.dart';

import 'widget/food_menu_item.dart';

class TruckMenuScreen extends StatefulWidget {
  const TruckMenuScreen({
    super.key,
    required this.truck,
  });

  final Truck truck;

  @override
  State<TruckMenuScreen> createState() => _TruckMenuScreenState();
}

class _TruckMenuScreenState extends State<TruckMenuScreen> {
  late List<FoodItem> _foodItemList;

  MediaQueryData get mediaQuery => MediaQuery.of(context);

  double get height => mediaQuery.size.height;

  double get width => mediaQuery.size.width;

  @override
  void initState() {
    _foodItemList = widget.truck.foodList?.toList() ?? [];
    super.initState();
  }

  void _navigateToCart() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const CartScreen()
     ),(route) => false,
    );
  }

  Future<void> _resetCart(OrderItem item, int index) async {
    Navigator.of(context).maybePop();
    await HiveClient().currentCartTruckBox.put(0, item);
    await HiveClient().cartBox.clear();
    await HiveClient().cartBox.put(index, item.copyWith(count: 1));
    setState(() {});
  }

  Future<void> _showEmptyCartPopup(OrderItem item, int index) async {
    AlertDialog alert = AlertDialog(
      title: const Text('Empty Cart?'),
      content: const Text(
          'This will empty your cart before adding an item from a different truck.'),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.of(context).maybePop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => _resetCart(item, index),
          child: const Text('Clear'),
        ),
      ],
    );
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => alert,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // BackdropFilter(
        //   filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        //   // Adjust sigmaX and sigmaY for the desired blur effect
        //   child: ImageFiltered(
        //     imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        //     // Same blur values as BackdropFilter
        //     child: Image.asset(
        //       widget.truck.thumbnailImageUrl,
        //       fit: BoxFit.contain,
        //       width: double.infinity,
        //       height: double.infinity,
        //     ),
        //   ),
        // ),
        Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(widget.truck.truckName, style: TextStyle(
                fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.transparent,
            actions: [
              IconButton(
                onPressed: _navigateToCart,
                icon: const Icon(
                  Icons.shopping_cart_rounded,
                  color: Colors.black,size: 25,
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              CarouselSlider.builder(
                options: CarouselOptions(
                  height: 300,
                  aspectRatio: 16 / 9,
                  padEnds: false,
                  scrollPhysics: PageScrollPhysics(),
                  viewportFraction: 1,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 3),
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeFactor: 0.9,
                  scrollDirection: Axis.horizontal,
                ),
                itemCount: _foodItemList.length,
                itemBuilder: (context, index, index1) =>  ViewImages(_foodItemList[index])),

              SizedBox(
                height: 20,
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: _foodItemList.length,
                  padding: const EdgeInsets.all(12),
                  itemBuilder: (context, index) => SizedBox(
                    height: 100,
                    child: FoodMenuItem(
                      foodItem: _foodItemList[index],
                      index: index,
                      onResetCart: _showEmptyCartPopup,
                    ),
                  ),
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(),
                ),
              ),
              SizedBox(height: 10,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _launchUrl(Uri.parse(widget.truck.map ?? ''));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Colors.white, // Icon color
                          ),
                          SizedBox(width: 8), // Adding some spacing between icon and text
                          Text(
                            'Location truck',
                            style: TextStyle(color: Colors.white), // Text color
                          ),
                        ],
                      ),
                    ),

                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

Future<void> _launchUrl(Uri url) async {
  if (!await launchUrl(url)) {
    throw Exception('Could not launch $url');
  }
}
