import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/models.dart';

class AuthenticationRepository{

  AuthenticationRepository({FirebaseAuth? firebaseAuth, GoogleSignIn? googleSignIn}) :
    _googleSignIn = googleSignIn ?? GoogleSignIn.standard(),
    _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  static SharedPreferences? pref;
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  Future<bool> isSignedIn() async {
    bool signedIn = (await user.first == UserProfile.empty)? false : true;
    return signedIn;
  }

  Stream<UserProfile> get user {
    return _firebaseAuth.authStateChanges().map((fireBaseUser) {
      final user = fireBaseUser == null ? UserProfile.empty : fireBaseUser.toUser;
      return user;
    });
  }

  Future<UserProfile> signUp({required String email, required String password}) async {
    try {
      final result = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      print(result);
      final currentUser = await user.first;
      print(currentUser);
      return currentUser;
    } on FirebaseAuthException catch (e) {
      log(e.message.toString());
    }
    return UserProfile.empty;
  }

  Future<void> logInWithGoogle() async {
    try {
      late final AuthCredential credential;
      if (kIsWeb) {
        final googleProvider = GoogleAuthProvider();
        final userCredential = await _firebaseAuth.signInWithPopup(
          googleProvider,
        );
        credential = userCredential.credential!;
      } else {
        final googleUser = await _googleSignIn.signIn();
        final googleAuth = await googleUser!.authentication;
        credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
      }

      await _firebaseAuth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      log(e.message.toString());
    }
  }

  Future<UserProfile> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final currentUser = await user.first;
      return currentUser;
    } on FirebaseAuthException catch (e) {
      log(e.message.toString());
    }
    return UserProfile.empty;
  }

  Future<void> logOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        // _googleSignIn.signOut(),
      ]);
    } on FirebaseAuthException catch (e) {
      log(e.message.toString());
    }
  }
}

extension on User {
  UserProfile get toUser {
    return UserProfile(id: uid, email: email, name: displayName, profileUrl: photoURL);
  }
}