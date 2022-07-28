
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class PhoneAuthentication extends StatefulWidget {
  const PhoneAuthentication({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<PhoneAuthentication> createState() => _PhoneAuthenticationState();
}

class _PhoneAuthenticationState extends State<PhoneAuthentication> {
  TextEditingController phoneController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  String verificationIDRecived = '';
  TextEditingController textEditingController = new TextEditingController(text: "");



  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Phone Number',
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            const Text(
              'otp',
            ),
            TextFormField(controller: textEditingController,),

            ElevatedButton(
                onPressed: () async {
                  if (isVisible) {
                    verifyCode();
                  } else {
                    verifyNumber();

                  }
                },
                child: Text(isVisible ? 'Login' : 'Verify Code'))
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  verifyNumber() {
    auth.verifyPhoneNumber(
        phoneNumber: phoneController.text,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth
              .signInWithCredential(credential)
              .then((value) => print('You are logged in successfully'));
        },
        verificationFailed: (FirebaseAuthException exception) {
          print(exception.message);
        },
        codeSent: (String verificationID, int? resendToken) {
          verificationIDRecived = verificationID;
          isVisible = true;
          setState(() {

          });
        },
        codeAutoRetrievalTimeout: (String verificationID) {});
  }

  void verifyCode() async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationIDRecived, smsCode:textEditingController.text);
    FocusScope.of(context).requestFocus(new FocusNode());

    await auth.signInWithCredential(credential).then((value) =>
        print('Your are logged in  successfully '));
  }

}
