import 'package:flutter/material.dart';

class FilterOptions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView( // Added this to prevent overflow
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Filter By", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            filterButton(context, "All"),
            filterButton(context, "Order Received", isSelected: true),
            filterButton(context, "Preparing"),
            filterButton(context, "Out For Delivery"),
            filterButton(context, "Delivered"),
            filterButton(context, "Cancelled"),
          ],
        ),
      ),
    );
  }

  Widget filterButton(BuildContext context, String text, {bool isSelected = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.black : Colors.white,
          foregroundColor: isSelected ? Colors.white : Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          side: BorderSide(color: Colors.black),
        ),
        onPressed: () {
          Navigator.pop(context); // Close the filter popup
        },
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Text(text, style: TextStyle(fontSize: 16)),
        ),
      ),
    );
  }
}
