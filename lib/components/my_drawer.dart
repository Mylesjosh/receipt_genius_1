import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:receipt_genius/pages/business_login_page.dart';
import '../auth/login_or_register.dart';
import '../pages/settings_page.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              // app logo
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: DrawerHeader(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 25.0),
                      child: Image.asset(
                        'lib/images/unlock.png',
                        color: Theme.of(context).colorScheme.primary,
                        height: 60,
                      ),
                    ),
                  ),
                ),
              ),

              // home list tile
              Padding(
                padding: const EdgeInsets.only(left: 25.0, top: 10),
                child: ListTile(
                  title: const Text("H O M E"),
                  leading: const Icon(Icons.home),
                  onTap: () => Navigator.pop(context),
                ),
              ),

              // settings list tile
              Padding(
                padding: const EdgeInsets.only(left: 25.0, top: 10),
                child: ListTile(
                  title: const Text("S E T T I N G S"),
                  leading: const Icon(Icons.settings),
                  onTap: () {
                    // pop drawer
                    Navigator.pop(context);

                    // go to settings page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsPage(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          // logout list tile
          Padding(
            padding: const EdgeInsets.only(left: 25.0, bottom: 25),
            child: ListTile(
              title: const Text("L O G O U T"),
              leading: const Icon(Icons.logout),
              onTap: () {
                // go to about page
                FirebaseAuth.instance.signOut;
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BusinessLoginPage(),
                    ),
                        (route) => false);
              },
            ),
          ),
        ],
      ),
    );
  }
}
