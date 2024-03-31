import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:truck_app/db/hive_client.dart';
import 'package:truck_app/models/index.dart';
import 'package:truck_app/screens/truck_screen.dart';
import 'package:truck_app/screens/widget/food_menu_item.dart';

import 'RecieptScreen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({
    super.key,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late List<OrderItem> _orderItems;

  MediaQueryData get mediaQuery => MediaQuery.of(context);

  double get height => mediaQuery.size.height;

  double get width => mediaQuery.size.width;
  double total = 0;
  late bool isCartEmpty;

  @override
  void initState() {
    _orderItems = HiveClient().cartBox.values.toList().cast<OrderItem>();
    _orderItems.forEach(_calculateTotal);
    isCartEmpty = HiveClient().cartBox.isEmpty;
    log('cartBox: ${HiveClient().cartBox.values.toList()}');
    super.initState();
  }

  void _calculateTotal(e) => total += e.price * e.count;

  Future<void> _resetCart(OrderItem item) async {
    Navigator.of(context).maybePop();
    await HiveClient().currentCartTruckBox.put(0, item);
    await HiveClient().cartBox.clear();
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
          onPressed: () => _resetCart(item),
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

  Future<void> _submitOrder() async {
    final User user = await HiveClient().userBox.values.first as User;
    Order order = Order(
        userId: user.email,
        items: _orderItems,
        dateTimeStamp: DateTime.now().millisecondsSinceEpoch);
    await HiveClient().orderBox.add(order);
    Navigator.push(context,
    MaterialPageRoute(builder: (context) => recieptScreen(
      orderItems: _orderItems, totalAmount: total,truckName: order.userId,
    ),
    ));

  }

  void _showOrderSuccessfulDialog() {
    AlertDialog alert = AlertDialog(
      title: const Text('Order Successful'),
      actions: [
        ElevatedButton(
          onPressed: _dismissAndNavigateToTrucks,
          child: const Text('Ok'),
        )
      ],
    );

    showDialog(
      context: context,
      builder: (context) => alert,
    );
  }

  void _dismissAndNavigateToTrucks() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const TruckScreen()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
            child: _buildBackground(),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text("Trucks"),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
          ),
          body: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                isCartEmpty
                    ? Text(
                        'Empty Cart',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 25,

                          fontWeight: FontWeight.bold
                        )
                      )
                    : const SizedBox.shrink(),
                isCartEmpty
                    ? Text(
                        'Please add Items',
                        style: Theme.of(context).textTheme.labelLarge,
                      )
                    : const SizedBox.shrink(),
                Expanded(
                  child: ListView.separated(
                    itemCount: _orderItems.length,
                    itemBuilder: (context, index) => SizedBox(
                      height: 100,
                      child: FoodMenuItem.summary(
                        orderItem: _orderItems[index],
                        index: index,
                        onResetCart: _showEmptyCartPopup,
                      ),
                    ),
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(height:5),
                  ),
                ),
                Visibility(
                  visible: !isCartEmpty,
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            const Text(
                              'Total:',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            Text(
                              'EGP ${total.toStringAsFixed(2)}',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Visibility(
                  visible: !isCartEmpty,
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _submitOrder,
                          child: const Text('Submit Order'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBackground() {
    if (_orderItems.isNotEmpty && _orderItems[0].imagesFood != null) {
      return Image.asset(
        _orderItems[0].imagesFood!,
        fit: BoxFit.fill,
        width: double.infinity,
        height: double.infinity,
      );
    } else {
      return Image.asset(
        "assets/Images/truck.png",
        fit: BoxFit.fill,
        width: double.infinity,
        height: double.infinity,
      );
    }
  }
}
