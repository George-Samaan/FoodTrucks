import 'package:flutter/material.dart';

import '../../models/food_item.dart';

class ViewImages extends StatefulWidget {
  FoodItem foodItem;

  ViewImages(this.foodItem);

  @override
  State<ViewImages> createState() => _ViewImagesState();
}

class _ViewImagesState extends State<ViewImages> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: AssetImage(widget.foodItem.imagesFood ?? ''),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
