import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_project/providers/tv_show_provider.dart';
import 'package:group_project/screens/login_screen.dart';
import 'package:group_project/screens/main_screeen.dart';
import 'package:group_project/services/shared_pref.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class AuthService {
  final SharedPref _sharedPref = SharedPref.instance;

  Future<String?> register(
      String email, String password, String name, BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      String uid = userCredential.user!.uid;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set({'email': email, 'name': name, 'favorites': []});

      _sharedPref.setEmail(email);
      print("User registered successfully");
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
      return 'Success';
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuthException: ${e.message}");
      return e.message;
    } catch (e) {
      print("Unexpected error: $e");
      return e.toString();
    }
  }

  Future<String?> login(
      String email, String password, BuildContext context) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      _sharedPref.setEmail(email);
      await _sharedPref.getLogged() == false
          ? _sharedPref.setLogged(true)
          : null;
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.of(context, rootNavigator: true)
            .push(MaterialPageRoute(builder: (_) => MainScreen()));
      });
      return 'Success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
        return 'Invalid login credentials.';
      } else {
        return e.message;
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> logout(BuildContext context) async {
    final provider = Provider.of<TVShowProvider>(context, listen: false);
    await FirebaseAuth.instance.signOut().then((value) {
      _sharedPref.setLogged(false);
      _sharedPref.setEmail(null);
    });
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context, rootNavigator: true).push(
        MaterialPageRoute(builder: (_) => const MainScreen()),
      );
    });
    provider.reset();
  }
}
