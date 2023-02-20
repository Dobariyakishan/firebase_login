import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthentication extends StatefulWidget {
  const GoogleAuthentication({Key? key}) : super(key: key);


  @override
  State<GoogleAuthentication> createState() => _GoogleAuthenticationState();
}

class _GoogleAuthenticationState extends State<GoogleAuthentication> {
  FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();


  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Signing'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                onPressed: () async {
                  signInWithGoogle();
                },
                child: const Text('Signing with google')),
            ElevatedButton(
                onPressed: () async {
                  signOutFromGoogle();
                },
                child: const Text('Sign Out'))
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<String?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      await auth.signInWithCredential(credential).then((value) async {
        if (value.user != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Signing Successful'),backgroundColor: Colors.green,
            ),
          );
          // Scaffold.of(context).showSnackBar(SnackBar(
          //   content: const Text('Signing Successful'),
          //   duration: const Duration(seconds: 1),
          //  backgroundColor: Colors.green,
          // ));
          print('Signing Successful');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Something went wrong'),backgroundColor: Colors.red,
            ),
          );

          print('Something went wrong');
        }
      });
      // Navigator.pushNamedAndRemoveUntil(context, Constants.homeNavigate, (route) => false);
    } on FirebaseAuthException catch (e) {
      print(e.message);
      throw e;
    }
    return null;
  }

  Future<void> signOutFromGoogle() async {
    await _googleSignIn.signOut();
    await auth.signOut();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sign Out'),backgroundColor: Colors.red,
      ),
    );

  }
}
