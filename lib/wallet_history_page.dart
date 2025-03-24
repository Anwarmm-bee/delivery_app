import 'package:flutter/material.dart';

class WalletHistoryPage extends StatelessWidget {
  final double currentBalance = 122.50; // Fetch this from backend
  final List<Map<String, dynamic>> transactions = [
    {
      "amount": 27.50,
      "date": "01-03-2025",
      "id": 4665,
      "type": "credit",
      "message": "Order delivery bonus for order ID: #3149",
      "status": "Success"
    },
    {
      "amount": 31.70,
      "date": "28-02-2025",
      "id": 4660,
      "type": "credit",
      "message": "Order delivery bonus for order ID: #3145",
      "status": "Success"
    },
    {
      "amount": 62.70,
      "date": "27-02-2025",
      "id": 4656,
      "type": "credit",
      "message": "Order delivery bonus for order ID: #3140 with Delivery Tip: 20",
      "status": "Success"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Wallet History")),
      body: Column(
        children: [
          // Wallet Balance Section
          Container(
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
            ),
            child: Column(
              children: [
                Text("Current Balance", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                Text("\₹${currentBalance.toStringAsFixed(2)}", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green)),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    // Implement Withdraw Function
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: Text("Withdraw Balance"),
                ),
              ],
            ),
          ),

          // Transaction History
          Expanded(
            child: ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                var transaction = transactions[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    title: Text("Amount: \₹${transaction['amount']}"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("ID: ${transaction['id']}"),
                        Text("Type: ${transaction['type']}"),
                        Text(transaction['message']),
                        Text("Date: ${transaction['date']}"),
                      ],
                    ),
                    trailing: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: transaction['status'] == "Success" ? Colors.green : Colors.red,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(transaction['status'], style: TextStyle(color: Colors.white)),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}