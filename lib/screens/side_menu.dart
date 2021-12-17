import 'package:flutter/material.dart';
import 'package:cleanin/screens/settings_screen.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            child: Text(
              'cleanin settings',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
            decoration: BoxDecoration(color: Colors.blue),
          ),
          const ListTile(
            leading: Icon(Icons.message),
            title: Text('Messages'),
          ),
          const ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Profile'),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => SettingsScreen()));
            },
          ),
        ],
      ),
    );
  }

}