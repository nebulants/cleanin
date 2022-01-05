import 'package:cleanin/screens/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if(!snapshot.hasData) {
          return SignInScreen(
            showAuthActionSwitch: false,
            providerConfigs: const [
              GoogleProviderConfiguration(
                clientId: '...',
              ),
              EmailProviderConfiguration(),
            ],
            headerBuilder: (context, constraints, _) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.network('https://firebase.flutter.dev/img/flutterfire_300x.png'),
                ),
              );
            },
          );
        }

        return const MainScreen();
      },
    );
  }
}