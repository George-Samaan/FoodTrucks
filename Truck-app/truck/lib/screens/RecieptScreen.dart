import 'dart:developer';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:sks_ticket_view/sks_ticket_view.dart';
import 'package:truck_app/db/hive_client.dart';
import 'package:truck_app/models/index.dart';
import 'package:truck_app/screens/truck_screen.dart';
import 'package:truck_app/screens/widget/RecieptItem.dart';
import 'package:truck_app/screens/widget/food_menu_item.dart';

import 'RecieptScreen.dart';

class recieptScreen extends StatefulWidget {
  final List<OrderItem> orderItems;
  final double totalAmount;
  final String truckName;

  const recieptScreen({
    Key? key,
    required this.truckName,
    required this.orderItems,
    required this.totalAmount,
  }) : super(key: key);


  @override
  State<recieptScreen> createState() => recieptScreenState();
}

class recieptScreenState extends State<recieptScreen> {
  late List<OrderItem> _orderItems;
  late double total;

  late String truckName;

  MediaQueryData get mediaQuery => MediaQuery.of(context);

  double get height => mediaQuery.size.height;

  double get width => mediaQuery.size.width;

  late bool isCartEmpty;

  @override
  void initState() {
    _orderItems = widget.orderItems;
    total = widget.totalAmount;
    _orderItems = HiveClient().cartBox.values.toList().cast<OrderItem>();
    isCartEmpty = HiveClient().cartBox.isEmpty;
    log('cartBox: ${HiveClient().cartBox.values.toList()}');
    truckName = widget.truckName;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reciept"),
        elevation: 0.0,
        actions: [
          IconButton(onPressed: () {
            Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (context) => TruckScreen(),)
              , (route) => false,
            );
            HiveClient().cartBox.clear();
          }, icon: Icon(Icons.home))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isCartEmpty
                ? Text(
                'Empty Reciept',
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 25,

                    fontWeight: FontWeight.bold
                )
            )
                : const SizedBox.shrink(),
            isCartEmpty
                ? Text(
              'Please buy Items',
              style: Theme
                  .of(context)
                  .textTheme
                  .labelLarge,
            )
                : const SizedBox.shrink(),
            Expanded(
              child: SKSTicketView(

                backgroundColor: Color(0xFF8F1299),
                drawArc: false,
                triangleAxis: Axis.vertical,
                borderRadius: 6,
                drawDivider: true,
                trianglePos: 1,
                child: Column(
                  children: [
                  Text("RECIEPT", style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 40,
                    fontWeight: FontWeight.w500),),
                SizedBox(height: 20),
                    Text(_orderItems.first.truckName??"Truck", style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),),
                    SizedBox(height: 10),

                    Text(truckName, style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),),
                SizedBox(height: 10),

                    Text(DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()), // Formats the DateTime object without milliseconds
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                        Text("Food Name",style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),),

                        Text("price",style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),),
                      ],),
                    ],
                  ),
                ),

                Expanded(
                  child: ListView.builder(
                    itemCount: _orderItems.length,
                    itemBuilder: (context, index) =>
                        SizedBox(
                          child: RecieptItem(
                            _orderItems[index].foodName,
                            _orderItems[index].price,
                            _orderItems[index].count,
                          ),
                        ),

                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                         Text(
                        'Total:',
                        style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'EGP ${total.toStringAsFixed(2)}',
                      style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),),
                  ],
                ),
              ),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
                    Text("THANK YOU !",
                      style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 50,
                          fontWeight: FontWeight.w300),),
          ],
        ),
      ),
    ),

    ]
    ,
    )
    ,
    )
    ,
    );
  }

}
