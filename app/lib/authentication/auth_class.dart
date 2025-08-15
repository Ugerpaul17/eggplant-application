import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authentication {
  static User? currentUser;

  static getCurrentUser() {
    return currentUser;
  }

  static Future<FirebaseApp> initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    // TODO: Add auto login logic

   return firebaseApp;
  }

  static Future<User?> signInWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      final UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
      currentUser = user;
      return user;
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided.';
      } else {
        message = 'Login failed. ${e.message}';
      }
      Get.snackbar(
        "Oooppss!",
        message,
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
      return null;
    } catch (e) {
      Get.snackbar(
        "Oooppss!",
        'Error occurred during sign-in. Try again.',
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
      return null;
    }
  }

  static Future<User?> registerWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      final UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
      currentUser = user;
      return user;
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'email-already-in-use') {
        message = 'The account already exists for that email.';
      } else if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else {
        message = 'Registration failed. ${e.message}';
      }
      Get.snackbar(
        "Oooppss!",
        message,
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
      return null;
    } catch (e) {
      Get.snackbar(
        "Oooppss!",
        'Error occurred during registration. Try again.',
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
      return null;
    }
  }

  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);

        user = userCredential.user;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          Get.snackbar("Oooppss!",
             'The account already exists with a different credential',
              colorText: Colors.white, backgroundColor: Colors.red);
      } else if (e.code == 'invalid-credential') {
          Get.snackbar("Oooppss!",
             'Error occurred while accessing credentials. Try again.',
              colorText: Colors.white, backgroundColor: Colors.red);
        }
      } catch (e) {
        Get.snackbar(
           "Oooppss!", 'Error occurred using Google Sign-In. Try again.',
            colorText: Colors.white, backgroundColor: Colors.red);
      }
    }

     currentUser = user;

    return user;
  }

  static Future<void> signOut({required BuildContext context}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      Get.snackbar(
        'Oooppss!',
        'Error signing out. Try again.',
      );
    }

    currentUser = null;
  }
}
