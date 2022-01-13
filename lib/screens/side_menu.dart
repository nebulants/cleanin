import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cleanin/screens/settings_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({Key? key}) : super(key: key);


  @override
  State createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = _auth.currentUser!;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Colors.blue),
            currentAccountPicture: CircleAvatar(
              radius: 50.0,
              backgroundColor: Color(0xFF778899),
              backgroundImage: NetworkImage("${currentUser.photoURL}"),
            ),
            accountEmail: Text("${currentUser.email}"),
            accountName: Text("${currentUser.displayName}"),
          ),
          const ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Profile'),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => SettingsScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('logout'),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              GoogleSignIn _googleSignIn = GoogleSignIn();
              await _googleSignIn.signOut();
            },
          ),
        ],
      ),
    );
  }
}