import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/screens/login_screens.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future<User?> createAccount(String name, String email, String password) async {
  FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  try {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    print('Account created Succesfull');

    userCredential.user!.updateDisplayName(name);

    await _firestore.collection('users').doc(_auth.currentUser!.uid).set({
      "name": name,
      "email": email,
      "status": "Unavalible",
      "uid": _auth.currentUser!.uid,
    });
    return userCredential.user;
  } catch (e) {
    print(e);
    return null;
  }
}

Future<User?> logIn(String email, String password) async {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  try {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    print('Login Successfull');
    _firestore.collection('users').doc(_auth.currentUser!.uid).get().then(
          (value) => userCredential.user!.updateDisplayName(value['name']),
        );
    return userCredential.user;
  } on FirebaseAuthException catch (e) {
    // print(e);
    // return null;
    String messageError = "Error";
    switch (e.code) {
      case "invalid-email":
        messageError = "Your email address appears to be malformed.";
        break;
      case "wrong-password":
        messageError = "Your password is wrong.";
        break;
      case "user-not-found":
        messageError = "User with this email doesn't exist.";
        break;
      case "user-disabled":
        messageError = "User with this email has been disabled.";
        break;
      case "too-many-requests":
        messageError = "Too many requests";
        break;
      case "operation-not-allowed":
        messageError = "Signing in with Email and Password is not enabled.";
        break;
      default:
        messageError = "An undefined Error happened.";
    }
    Fluttertoast.showToast(msg: messageError);
  }
}

Future logOut(BuildContext context) async {
  FirebaseAuth _auth = FirebaseAuth.instance;

  try {
    await _auth.signOut().then((value) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        ),
      );
    });
  } catch (e) {
    print("error");
  }
}
