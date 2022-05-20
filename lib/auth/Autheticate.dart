import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_chat/Home%20Pages/my_home_pages.dart';
import 'package:flutter_chat/screens/login_screens.dart';

class Authenticate extends StatelessWidget {
  Authenticate({Key? key}) : super(key: key);
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    if (_auth.currentUser != null) {
      return const MyHomePage();
    } else {
      return const LoginScreen();
    }
  }
}
