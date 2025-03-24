import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderDetailsPage extends StatefulWidget {
  final String orderId;
  final String orderNo;
  final String name;
  final String phone;
  final String address;
  final String amount;
  final String date;
  final String status;
  final List<Map<String, dynamic>> products;

  const OrderDetailsPage({
    Key? key,
    required this.orderId,
    required this.orderNo,
    required this.name,
    required this.phone,
    required this.address,
    required this.amount,
    required this.date,
    required this.status,
    required this.products,
  }) : super(key: key);

  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late String _currentStatus;
  late double _amount;
  late double _deliveryCharge;
  late double _totalAmount;

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.status;
    _amount = double.tryParse(widget.amount) ?? 0.0;
    _deliveryCharge = _amount * 0.10; // 10% of the total amount
    _totalAmount = _amount + _deliveryCharge;
  }

  Future<void> _updateOrderStatus(String newStatus) async {
    try {
      await _firestore.collection('orders').doc(widget.orderId).update({
        'orderStatus': newStatus,
      });
      setState(() {
        _currentStatus = newStatus;
      });
      Navigator.pop(context, newStatus);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating order status: $error")),
      );
    }
  }

  Color _getStatusColor(String status) {
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
      appBar: AppBar(title: Text("Order Details")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _orderInfoSection(),
            SizedBox(height: 10),
            _productsSection(),
            SizedBox(height: 20),
            _statusUpdateButtons(),
          ],
        ),
      ),
    );
  }

  Widget _orderInfoSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _infoRow("Order No:", widget.orderNo),
            _infoRow("Customer Name:", widget.name),
            _infoRow("Phone:", widget.phone),
            _infoRow("Address:", widget.address),
            _infoRow("Subtotal:", "₹${_amount.toStringAsFixed(2)}"),
            _infoRow("Delivery Charge (10%):", "₹${_deliveryCharge.toStringAsFixed(2)}"),
            _infoRow("Total Amount:", "₹${_totalAmount.toStringAsFixed(2)}",
                isBold: true),
            _infoRow("Date:", widget.date),
            _statusBadge(_currentStatus),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(width: 8),
          Expanded(
            child: Text(value,
                style: TextStyle(
                    color: Colors.black87,
                    fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(String status) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: _getStatusColor(status),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(status, style: TextStyle(color: Colors.white, fontSize: 14)),
    );
  }

  Widget _productsSection() {
    return Expanded(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Products", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Divider(),
              Expanded(
                child: widget.products.isNotEmpty
                    ? ListView.builder(
                        itemCount: widget.products.length,
                        itemBuilder: (context, index) {
                          var product = widget.products[index];
                          return _productItem(product);
                        },
                      )
                    : Center(child: Text("No products available")),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _productItem(Map<String, dynamic> product) {
    String name = product["name"]?.toString() ?? "Unknown";
    String qty = product["quantity"]?.toString() ?? "0";
    String price = product["price"]?.toString() ?? "0";

    return ListTile(
      leading: Icon(Icons.shopping_bag, color: Colors.blue),
      title: Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text("Qty: $qty • Price: ₹$price"),
    );
  }

  Widget _statusUpdateButtons() {
    if (_currentStatus == "Delivered" || _currentStatus == "Cancelled") return Container();

    String nextStatus = _currentStatus == "Order Received" ? "Out For Delivery" : "Delivered";

    return Center(
      child: ElevatedButton(
        onPressed: () => _updateOrderStatus(nextStatus),
        child: Text(_currentStatus == "Order Received"
            ? "Mark as Out For Delivery"
            : "Mark as Delivered"),
      ),
    );
  }
}