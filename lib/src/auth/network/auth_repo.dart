import 'package:bookshare/src/auth/network/auth_data_src.dart';

class AuthRepo {
 
 final _dataSrc = AuthDataSrc();
  Future<void> signUp(String email, String password) async {
      await _dataSrc.signUp(email, password);}
   Future<void> signIn(String email, String password) async {
    await _dataSrc.signIn(email, password);
}

Future<void> resetPassword(String email) async {
    await _dataSrc.resetPassword(email);
  }

  Future<void> signInWithGoogle() async {
    await _dataSrc.signInWithGoogle();
  }
  Future<void> signOut() async {
      await _dataSrc.signOut();
    }
}