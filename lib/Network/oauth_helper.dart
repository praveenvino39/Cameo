import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class OauthHelper {
  FirebaseAuth _firebaseAuth;
  UserCredential _user;

  OauthHelper() {
    _firebaseAuth = FirebaseAuth.instance;
  }

  Future<bool> signInGoogle() async {
    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
      ],
    );
    try {
      GoogleSignInAccount account = await _googleSignIn.signIn();
      return true;
    } catch (e) {
      return false;
    }
  }

  void signOutGoogle() async {
    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: ['email'],
    );
    await _googleSignIn.signOut();
    print("Logged out");
  }
}
