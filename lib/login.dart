import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

final googleSignIn = GoogleSignIn();

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  Future<UserCredential?> signInWithGoogle() async {
    try {
      EasyLoading.show(status: "Signing In..");
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (err) {
      EasyLoading.showError("$err");
    } finally {
      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        toolbarHeight: 150,
        title: Column(
          children: const [
            Text(
              "VikasBandhu",
              style: TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.teal,
      body: Padding(
        padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.1, 0,
            MediaQuery.of(context).size.width * 0.1, 0),
        child: Column(children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(100)),
              ),
              width: MediaQuery.of(context).size.width * 0.8,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  signInWithGoogle();
                },
                child: const Text(
                  "Sign in with Google",
                  style: TextStyle(fontSize: 23, color: Colors.teal),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  shape: const StadiumBorder(),
                  shadowColor: Colors.black,
                  elevation: 20,
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }
}