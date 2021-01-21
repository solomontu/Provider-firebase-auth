import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/widgets.dart';

enum Status {
  uninitialized,
  unAuthenticated,
  unAcredited,
  authenticating,
  authenticated,
}

class ProviderAuth with ChangeNotifier {
  Status _status = Status.uninitialized;

  FirebaseAuth _auth;
  User _user;
  String _error;

  FirebaseAuth get auth => _auth;
  User get user => _user;
  String get error => _error;
  Status get status => _status;

  ProviderAuth();
  ProviderAuth.instance() : _auth = FirebaseAuth.instance {
    _auth.authStateChanges().listen((User user) {
      
      if (user == null) {
        _status = Status.unAuthenticated;
        print('User is signed out!');
      } else {
        _status = Status.authenticated;
        _user = user;
        print('User is signed in!');
      }
      notifyListeners();
    });
  }

//Sign in method
  Future<bool> signin({String email, String password}) async {
    try {
      _status = Status.authenticating;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      _status = Status.unAuthenticated;
      notifyListeners();
      if (e.code == 'user-not-found') {
        _error = 'User not found';
      } else if (e.code == 'wrong-password') {
        _error = 'Wrond password';
      }
      if (e.code == 'invalid-email') {
        _error = 'invalid email.';
      }
      return false;
    } catch (e) {
      _status = Status.unAuthenticated;
      notifyListeners();
      _error = 'Something went wrong';
      print(e.toString());
      return false;
    }
    
  }

  Future<bool> signup({String email, String password}) async {
    try {
      _status = Status.authenticating;
      notifyListeners();
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      _status = Status.unAuthenticated;
      notifyListeners();
      if (e.code == 'weak-password') {
        _error = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        _error = 'The account already exists for that email.';
      }
      if (e.code == 'invalid-email') {
        _error = 'invalid email.';
      }
      return false;
    } catch (e) {
      _status = Status.unAcredited;
      notifyListeners();
      print(e.toString());
      _error = e.toString();
      return false;
    }
  }

//Sign out mathod
  Future sigout() async {
    await _auth.signOut();
    _status = Status.unAuthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }
}
