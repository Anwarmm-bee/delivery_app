import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart'; // ✅ Import easy_localization
import '../login_screen.dart'; // Import LoginScreen
import '../wallet_history_page.dart'; // ✅ Import Wallet History Page

class DrawerMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text("WrTeam Rider"),
            accountEmail: Text("wallet_balance".tr()), // ✅ Translated text
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: Colors.black),
            ),
          ),
          _drawerItem(Icons.home, "home".tr(), context),
          _drawerItem(Icons.person, "profile".tr(), context),
          
          // ✅ Wallet History - Navigate to WalletHistoryPage
          _drawerItem(Icons.history, "wallet_history".tr(), context, page: WalletHistoryPage()),

          _drawerItem(Icons.attach_money, "cash_collection".tr(), context),
          _drawerItem(Icons.delete, "delete_account".tr(), context),

          // ✅ Change Language Button
          ListTile(
            leading: Icon(Icons.language),
            title: Text("change_language".tr()),
            onTap: () => _showLanguageDialog(context), // Open language selection dialog
          ),

          _drawerItem(Icons.privacy_tip, "privacy_policy".tr(), context),
          _drawerItem(Icons.rule, "terms_conditions".tr(), context),
          _drawerItem(Icons.logout, "logout".tr(), context, isLogout: true), // Logout with confirmation
        ],
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title, BuildContext context, {bool isLogout = false, Widget? page}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.pop(context); // Close the drawer first
        if (isLogout) {
          _showLogoutDialog(context); // Show logout confirmation
        } else if (page != null) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => page)); // Navigate to the page
        }
      },
    );
  }

  // ✅ Language Change Dialog
  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("change_language".tr()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text("English"),
              onTap: () {
                context.setLocale(Locale('en', 'US'));
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("മലയാളം"),
              onTap: () {
                context.setLocale(Locale('ml', 'IN'));
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("logout".tr()),
        content: Text("logout_confirmation".tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Cancel
            child: Text("cancel".tr()),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (route) => false, // Clears navigation stack
              );
            },
            child: Text("logout".tr(), style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
