import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'drawer_menu.dart';
import 'widgets/filter_options.dart';
import 'order_details_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void updateOrderStatus(String orderId, String newStatus) {
    if (orderId.isNotEmpty) {
      _firestore.collection('orders').doc(orderId).update({
        'orderStatus': newStatus,
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error updating order status: $error")),
        );
      });
    }
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case "Order Received":
        return Colors.blue;
      case "Out For Delivery":
        return Colors.orange;
      case "Delivered":
        return Colors.green;
      case "Cancelled":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("eSupplyco Delivery App"),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () => showFilterDialog(context),
          ),
        ],
      ),
      drawer: DrawerMenu(),
      body: Column(
        children: [
          _buildSummarySection(),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('orders').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text("No orders available"));
                }

                var orders = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    var data = orders[index].data() as Map<String, dynamic>? ?? {};
                    data["orderStatus"] ??= "Order Received"; 
                    return orderCard(context, data, orders[index].id);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummarySection() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('orders').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Container();

        int pendingOrders = snapshot.data!.docs.where((doc) {
          var data = doc.data() as Map<String, dynamic>? ?? {};
          return ["Order Received", "Out For Delivery"].contains(data["orderStatus"] ?? "");
        }).length;

        int totalOrders = snapshot.data!.docs.length;

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 5, 220, 120),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                summaryBox(Icons.pending_actions, "Pending Orders", "$pendingOrders"),
                summaryBox(Icons.assignment, "Total Orders", "$totalOrders"),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget summaryBox(IconData icon, String title, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 30),
        SizedBox(height: 5),
        Text(title, style: TextStyle(color: Colors.white, fontSize: 14)),
        Text(value,
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget orderCard(BuildContext context, Map<String, dynamic> order, String orderId) {
    final safeOrderNo = order["orderNo"]?.toString() ?? 'Unknown Order';
    final safeName = order["name"]?.toString() ?? 'Unknown';
    final safePhone = order["phone"]?.toString() ?? 'N/A';
    final safeAddress = order["address"]?.toString() ?? 'Unknown Address';
    final safeStatus = order["orderStatus"]?.toString() ?? 'Order Received';
    final safeDate = order["date"]?.toString() ?? 'N/A';
    final safePaymentMethod = order["paymentMethod"]?.toString() ?? 'COD';
    
    double totalAmount = (order["amount"] != null) ? (order["amount"] as num).toDouble() : 0.0;
    double payableAmount = (safePaymentMethod == "Online") ? (totalAmount * 0.10) : totalAmount; 

    List<Map<String, dynamic>> safeItems = [];
    if (order["products"] is List) {
      safeItems = List<Map<String, dynamic>>.from(order["products"]);
    }

    return InkWell(
      onTap: () async {
        final newStatus = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderDetailsPage(
              orderId: orderId,
              orderNo: safeOrderNo,
              name: safeName,
              phone: safePhone,
              address: safeAddress,
              amount: totalAmount.toString(),
              date: safeDate,
              status: safeStatus,
              products: safeItems,
            ),
          ),
        );
        if (newStatus != null) {
          updateOrderStatus(orderId, newStatus);
        }
      },
      child: Card(
        margin: EdgeInsets.all(8),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text("Order No. $safeOrderNo",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: _getStatusColor(safeStatus),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(safeStatus, style: TextStyle(color: Colors.white)),
                ),
              ]),
              SizedBox(height: 5),
              Row(children: [Icon(Icons.person), SizedBox(width: 5), Text(safeName)]),
              Row(children: [Icon(Icons.phone), SizedBox(width: 5), Text(safePhone)]),
              Row(children: [Icon(Icons.location_on), SizedBox(width: 5), Text(safeAddress)]),
              Row(children: [Icon(Icons.attach_money), SizedBox(width: 5), Text("₹${payableAmount.toStringAsFixed(2)} (${safePaymentMethod == "Online" ? "10% Commission" : "Full Amount"})")]),
              SizedBox(height: 10),
              if (safeStatus == "Order Received" || safeStatus == "Out For Delivery")
                ElevatedButton(
                  onPressed: () {
                    String newStatus = safeStatus == "Order Received"
                        ? "Out For Delivery"
                        : "Delivered";
                    updateOrderStatus(orderId, newStatus);
                  },
                  child: Text(safeStatus == "Order Received"
                      ? "Mark as Out For Delivery"
                      : "Mark as Delivered"),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void showFilterDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => FilterOptions(),
    );
  }
}