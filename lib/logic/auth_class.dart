import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:selfa/logic/provider/data_handling.dart';

import '../log_in.dart';

class Auth {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<String> handleSignInEmail(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      return "done";
    } on FirebaseAuthException catch (e) {
      if (e.code =='user-not-found') {
        print('No user found for that email.');
        return "no email";
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        return "wrong pass";
      }
      return "error";
    }
  }

  Future<String> handleSignUp(email, password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      return "done";
    } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
        return "mail exist";
      }
    } catch (e) {
      print(e);
    }
    return 'error';

  }
  void signOut() {
    FirebaseAuth.instance.signOut();
    //print('$user');
    runApp(
         MaterialApp(
          debugShowCheckedModeBanner: false,
          home: SignIn(),
        )

    );
    runApp(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => DataHandling()),
          ],
          child:   MaterialApp(
            debugShowCheckedModeBanner: false,
            home: SignIn(),
          ),
        ));
  }
}