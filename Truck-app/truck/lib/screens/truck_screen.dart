import 'package:flutter/material.dart';
import 'package:truck_app/db/hive_client.dart';
import 'package:truck_app/models/index.dart';
import 'package:truck_app/screens/login_screen.dart';
import 'package:truck_app/screens/widget/truck_item.dart';

class TruckScreen extends StatefulWidget {
  const TruckScreen({super.key});

  @override
  State<TruckScreen> createState() => _TruckScreenState();
}

class _TruckScreenState extends State<TruckScreen> {
  late final List<Truck> _trucksList;

  @override
  void initState() {
    _trucksList = HiveClient().truckBox.values.toList().cast<Truck>();
    super.initState();
  }

  MediaQueryData get mediaQuery => MediaQuery.of(context);

  double get height => mediaQuery.size.height;

  double get width => mediaQuery.size.width;

  void _logoutUser(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context), // Cancel button
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _performLogout(context); // Logout button
              },
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  void _performLogout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 500),
        pageBuilder: (_, __, ___) => const LoginScreen(),
        transitionsBuilder: (_, animation, __, child) {
          return ScaleTransition(
            scale: Tween<double>(
              begin: 1.5, // Start scale factor
              end: 1.0,   // End scale factor
            ).animate(animation),
            child: child,
          );
        },
      ),
          (Route<dynamic> route) => false,
    );
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Trucks",
          style: TextStyle(
              fontSize: 35, color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout,
              size: 25,
            ),
            onPressed: () {
              _logoutUser(context);
            },

          ),
        ],
      ),
      body: ListView.separated(
        itemCount: _trucksList.length,
        // padding: const EdgeInsets.all(12),
        itemBuilder: (context, index) => SizedBox(
          height: 320,
          child: TruckItem(
            truck: _trucksList[index],
          ),
        ),
        separatorBuilder: (BuildContext context, int index) => SizedBox(
          height: 20,
        ),
      ),
    );
  }
}
