import 'package:flutter/material.dart';

class PendingOrdersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pending Orders"),
        backgroundColor: Colors.red, // Matches app theme
      ),
      body: const Center(
        child: Text(
          "No pending orders available!",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
