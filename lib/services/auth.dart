import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future SignInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      print("hello from auth");
      print(user);
      return "Done";
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return e;
    }
  }

  Future SignUpWithEmailAndPassword(
      String username, String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      user?.updateDisplayName(username);
      print(user);
      return user;
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return e;
    }
  }
}
