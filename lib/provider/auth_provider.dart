import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:udcks_news_app/models/user_model.dart';
import 'package:udcks_news_app/services/firebase_path.dart';
import 'package:udcks_news_app/services/firestore_services.dart';

enum Status {
  uninitialized,
  authenticated,
  authenticating,
  unauthenticated,
  registering
}
/*
- Uninitialized - Kiểm tra user đã login hay chưa, the Splash Screen will be shown
- Authenticated - User đã login, Home Page will be shown
- Authenticating - Người dùng nhấn vào nút login, progress bar will be shown
- Unauthenticated - User chưa login, login page will be shown
- Registering - User just pressed registering, progress bar will be shown
 */

class AuthProvider extends ChangeNotifier {
  //Firebase Auth object
  late FirebaseAuth _auth;
  late FirestoreService _firestoreService;

  //Default status
  Status _status = Status.uninitialized;

  Status get status => _status;

  Stream<UserModel> get user => _auth.authStateChanges().map(_userFromFirebase);
  
  String? get id => _auth.currentUser?.uid;

  AuthProvider() {
    //initialise object
    _auth = FirebaseAuth.instance;
    _firestoreService = FirestoreService.instance;
    //listener for authentication changes such as user sign in and sign out
    _auth.authStateChanges().listen(onAuthStateChanged);
  }

  //Create user object based on the given User
  UserModel _userFromFirebase(User? user) {
    if (user == null) {
      return UserModel(displayName: 'Null', uid: 'null');
    }

    return UserModel(
        uid: user.uid,
        email: user.email,
        displayName: user.displayName,
        phoneNumber: user.phoneNumber,
        photoUrl: user.photoURL);
  }

  //Method to detect live auth changes such as user sign in and sign out
  Future<void> onAuthStateChanged(User? firebaseUser) async {
    if (firebaseUser == null) {
      _status = Status.unauthenticated;
    } else {
      _userFromFirebase(firebaseUser);
      _status = Status.authenticated;
    }
    notifyListeners();
  }

  //Method for new user registration using email and password
  Future<UserModel> registerWithEmailAndPassword(
      String email, String password, String firstName, String lastName) async {
    try {
      _status = Status.registering;
      notifyListeners();
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      if (result.user != null) {
        _firestoreService.set(
            path: FirebasePath.userPath(result.user!.uid),
            data: UserModel(
              uid: result.user!.uid,
              email: email,
              displayName: firstName + " " + lastName,
            ).toMap());
      }

      return _userFromFirebase(result.user);
    } catch (e) {
      print("Error on the new user registration = " + e.toString());
      _status = Status.unauthenticated;
      notifyListeners();
      return UserModel(displayName: 'Null', uid: 'null');
    }
  }

  //Method to handle user sign in using email and password
  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    try {
      _status = Status.authenticating;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      print("Error on the sign in = " + e.toString());
      _status = Status.unauthenticated;
      notifyListeners();
      return false;
    }
  }

  //Method to handle password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  //Method to handle user signing out
  Future signOut() async {
    _auth.signOut();
    _status = Status.unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }
}
