import 'dart:developer';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationRepository {
  AuthenticationRepository(
      {FirebaseAuth? firebaseAuth, GoogleSignIn? googleSignIn})
      : //_googleSignIn = googleSignIn ?? GoogleSignIn.standard(),
        _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  static SharedPreferences? pref;
  final FirebaseAuth _firebaseAuth;
  // final GoogleSignIn _googleSignIn;

  Future<bool> isSignedIn() async {
    bool signedIn = (await user.first == UserProfile.empty) ? false : true;
    return signedIn;
  }

  Stream<UserProfile> get user {
    return _firebaseAuth.authStateChanges().map((fireBaseUser) {
      final user =
          fireBaseUser == null ? UserProfile.empty : fireBaseUser.toUser;
      return user;
    });
  }

  Future<RequestStatus<UserProfile?>> signUp(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      final currentUser = await user.first;
      return RequestStatus(
          status: RequestStatus.SUCCESS, message: null, body: currentUser);
    } on FirebaseAuthException catch (e) {
      return getErrorMsg<UserProfile>(e.code);
    }
  }

  // Future<void> logInWithGoogle() async {
  //   try {
  //     late final AuthCredential credential;
  //     if (kIsWeb) {
  //       final googleProvider = GoogleAuthProvider();
  //       final userCredential = await _firebaseAuth.signInWithPopup(
  //         googleProvider,
  //       );
  //       credential = userCredential.credential!;
  //     } else {
  //       final googleUser = await _googleSignIn.signIn();
  //       final googleAuth = await googleUser!.authentication;
  //       credential = GoogleAuthProvider.credential(
  //         accessToken: googleAuth.accessToken,
  //         idToken: googleAuth.idToken,
  //       );
  //     }
  //
  //     await _firebaseAuth.signInWithCredential(credential);
  //   } on FirebaseAuthException catch (e) {
  //     log(e.message.toString());
  //   }
  // }

  Future<RequestStatus<UserProfile?>> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final currentUser = await user.first;
      return RequestStatus(
          status: RequestStatus.SUCCESS, message: null, body: currentUser);
    } on FirebaseAuthException catch (e) {
      return getErrorMsg<UserProfile>(e.code);
    }
  }

  Future<RequestStatus<BaseResponse?>> logOut() async {
    try {
      await _firebaseAuth.signOut();
      return RequestStatus(
          status: RequestStatus.SUCCESS,
          body: BaseResponse(
              success: true,
              statusCode: 1,
              message: 'Logged out successfully'));
    } on FirebaseAuthException catch (e) {
      return getErrorMsg<BaseResponse>(e.code);
    }
  }

  RequestStatus<T> getErrorMsg<T>(String err) {
    String errorMsg = '';
    switch (err) {
      case 'invalid-email':
        errorMsg = 'Invalid Email';
        break;
      case 'wrong-password':
        errorMsg = 'Wrong Password';
        break;
      case 'user-not-found':
        errorMsg = 'User does not exists';
        break;
      case 'user-disabled':
        errorMsg = 'User has been disabled';
        break;
      case 'weak-password':
        errorMsg = 'The password is too weak';
        break;
      case 'operation-not-allowed':
        errorMsg = 'Invalid Operation';
        break;
      case 'email-already-in-use':
        errorMsg = 'Email already in use';
        break;
      default:
        log(err);
        errorMsg = 'Something went wrong';
        break;
    }
    return RequestStatus(status: RequestStatus.FAILURE, message: errorMsg);
  }
}

extension on User {
  UserProfile get toUser {
    return UserProfile(
        id: uid, email: email, name: displayName, profileUrl: photoURL);
  }
}
