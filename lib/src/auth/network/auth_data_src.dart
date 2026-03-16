

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthDataSrc {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  static const String _serverClientId = String.fromEnvironment(
    'GOOGLE_SERVER_CLIENT_ID',
  );
 
 Future signUp(String email, String password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw e.message ?? 'An error occurred during sign up.';
    }
 }


 Future signIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw e.message ?? 'An error occurred during sign in.';
    }
  }




  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw e.message ?? 'An error occurred while sending password reset email.';
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    if (_serverClientId.isEmpty) {
      throw 'Missing GOOGLE_SERVER_CLIENT_ID. Run app with --dart-define=GOOGLE_SERVER_CLIENT_ID=<web-client-id>';
    }

    await _googleSignIn.initialize(serverClientId: _serverClientId);

    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      if (googleAuth.idToken == null) {
        throw 'Google sign-in did not return an idToken.';
      }

      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      return _firebaseAuth.signInWithCredential(credential);
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        throw 'SIGN_IN_CANCELED';
      }
      throw 'Google sign-in failed (${e.code.name}): ${e.description ?? 'Unknown error'}';
    }
  }

    Future<void> signOut() async {
    await  Future.wait(
      [
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ],
    );
  }
}