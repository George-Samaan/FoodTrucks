import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:truck_app/db/hive_client.dart';
import 'package:truck_app/models/index.dart';

typedef OnResetCart = Function(OrderItem item, int index);

class FoodMenuItem extends StatefulWidget {
  const FoodMenuItem({
    super.key,
    required this.foodItem,
    required this.index,
    this.isSummary = false,
    this.onResetCart,
  });

  factory FoodMenuItem.summary({
    required OrderItem orderItem,
    required int index,
    OnResetCart? onResetCart,
  }) {
    return FoodMenuItem(
      foodItem: orderItem,
      index: index,
      isSummary: true,
      onResetCart: onResetCart,
    );
  }

  final bool isSummary;
  final int index;
  final FoodItem foodItem;
  final OnResetCart? onResetCart;

  @override
  State<FoodMenuItem> createState() => _FoodMenuItemState();
}

class _FoodMenuItemState extends State<FoodMenuItem> {
  FoodItem get _food => widget.foodItem;
  late OrderItem _orderItem;

  late int _count;

  @override
  void initState() {
    _orderItem = OrderItem.fromFoodItem(_food);
    if (widget.isSummary) {
      _orderItem = widget.foodItem as OrderItem;
    }
    try {
      final OrderItem currentOrderItem = HiveClient()
          .cartBox
          .values
          .cast<OrderItem>()
          .firstWhere((element) => _orderItem.foodName == element.foodName);
      _count = currentOrderItem.count;
    } catch (e) {
      _count = _orderItem.count;
    }
    super.initState();
  }

  void _decrementItemCount() {
    setState(() {
      _count--;
    });
    if (_count == 0) {
      _removeItemFromCart();
    } else {
      OrderItem updatedItem = _orderItem.copyWith(count: _count);

      HiveClient().cartBox.put(widget.index, updatedItem);
    }
  }

  void _removeItemFromCart() {
    HiveClient().cartBox.deleteAt(widget.index);
  }

  void _handleDifferentTruck() async {
    try {
      final bool isExistingCart =
          HiveClient().currentCartTruckBox.values.isNotEmpty;
      if (isExistingCart) {
        final OrderItem existingTruckName =
            await HiveClient().currentCartTruckBox.getAt(0);
        if (_orderItem.truckName != existingTruckName.truckName) {
          widget.onResetCart?.call(_orderItem, widget.index);
        }
      } else {
        HiveClient().currentCartTruckBox.put(0, _orderItem);
      }
    } catch (e) {
      log('handleDifferentTruck ${e.toString()}');
    }
  }

  Future<void> _incrementItemCount() async {
    _handleDifferentTruck();
    setState(() {
      _count++;
    });
    final updatedItem = _orderItem.copyWith(count: _count);
    await HiveClient().cartBox.put(widget.index, updatedItem);
    setState(() {});
  }

  Widget build(BuildContext context) {
    return Container(
       margin: EdgeInsets.only(top: 4),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 75,
            height: 75,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: AssetImage(widget.foodItem.imagesFood ?? 'assets/Images/truck.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.foodItem.foodName,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'EGP ${widget.foodItem.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight:FontWeight.bold ,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Row(
            children: [
              Visibility(
                visible: !widget.isSummary,
                child: IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: _count >= 1 ? _decrementItemCount : null,
                ),
              ),
              Text('$_count'),
              Visibility(
                visible: !widget.isSummary,
                child: IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: _incrementItemCount,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
