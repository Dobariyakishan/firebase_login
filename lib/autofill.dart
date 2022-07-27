// import 'dart:async';
//
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:sms_autofill/sms_autofill.dart';
// import 'package:sms_otp_auto_verify/sms_otp_auto_verify.dart';
//
//
// Future <void> main() async{
//   WidgetsFlutterBinding.ensureInitialized();
//   await  Firebase.initializeApp();
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key, required this.title}) : super(key: key);
//   final String title;
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> with CodeAutoFill{
//   TextEditingController phoneController = TextEditingController();
//   FirebaseAuth auth = FirebaseAuth.instance;
//   String verificationIDRecived = '';
//   int _otpCodeLength = 6;
//   bool _isLoadingButton = false;
//   bool _enableButton = false;
//   String _otpCode = "";
//   final _scaffoldKey = GlobalKey<ScaffoldState>();
//   final intRegex = RegExp(r'\d+', multiLine: true);
//   TextEditingController textEditingController = new TextEditingController(text: "");
//
//
//   @override
//   void initState() {
//     super.initState();
//     _getSignatureCode();
//     _startListeningSms();
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     SmsAutoFill().unregisterListener();
//
//     SmsVerification.stopListening();
//   }
//
//   BoxDecoration get _pinPutDecoration {
//     return BoxDecoration(
//       border: Border.all(color: Theme.of(context).primaryColor),
//       borderRadius: BorderRadius.circular(15.0),
//     );
//   }
//
//   /// get signature code
//   _getSignatureCode() async {
//     String? signature = await SmsVerification.getAppSignature();
//     print("signature $signature");
//   }
//
//   /// listen sms
//   _startListeningSms()  {
//     SmsVerification.startListeningSms().then((message) {
//       setState(() {
//         _otpCode = SmsVerification.getCode(message, intRegex);
//         textEditingController.text = _otpCode;
//         _onOtpCallBack(_otpCode, true);
//       });
//     });
//   }
//
//   _onSubmitOtp() {
//
//     setState(() {
//       _isLoadingButton = !_isLoadingButton;
//       verifyCode();
//
//     });
//     print('done');
//   }
//
//   // _onClickRetry() {
//   //   _startListeningSms();
//   // }
//
//   _onOtpCallBack(String otpCode, bool isAutofill) {
//     setState(() {
//       this._otpCode = otpCode;
//       if (otpCode.length == _otpCodeLength && isAutofill) {
//         _enableButton = false;
//         _isLoadingButton = true;
//         verifyCode();
//       } else if (otpCode.length == _otpCodeLength && !isAutofill) {
//         _enableButton = true;
//         _isLoadingButton = false;
//       } else {
//         _enableButton = false;
//       }
//     });
//   }
//
//   bool isVisible = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'Phone Number',
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
//               child: TextFormField(
//                 controller: phoneController,
//                 keyboardType: TextInputType.number,
//               ),
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             const Text(
//               'otp',
//             ),
//             TextFieldPin(
//                 textController: textEditingController,
//                 autoFocus: true,
//                 codeLength: _otpCodeLength,
//                 alignment: MainAxisAlignment.center,
//                 defaultBoxSize: 46.0,
//                 margin: 5,
//                 selectedBoxSize: 46.0,
//                 textStyle: TextStyle(fontSize: 16),
//                 defaultDecoration: _pinPutDecoration.copyWith(
//                     border: Border.all(
//                         color: Theme.of(context)
//                             .primaryColor
//                             .withOpacity(0.6))),
//                 selectedDecoration: _pinPutDecoration,
//                 onChange: (code) {
//                   _onOtpCallBack(code,false);
//                 }),
//             ElevatedButton(
//                 onPressed: () async {
//                   if (isVisible) {
//                     verifyCode();
//                   } else {
//                     verifyNumber();
//                     _onSubmitOtp();
//                   }
//                 },
//                 child: Text(isVisible ? 'Login' : 'Verify Code'))
//           ],
//         ),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
//
//   verifyNumber() {
//     auth.verifyPhoneNumber(
//         phoneNumber: phoneController.text,
//         verificationCompleted: (PhoneAuthCredential credential) async {
//           await auth
//               .signInWithCredential(credential)
//               .then((value) => print('You are logged in successfully'));
//         },
//         verificationFailed: (FirebaseAuthException exception) {
//           print(exception.message);
//         },
//         codeSent: (String verificationID, int? resendToken) {
//           verificationIDRecived = verificationID;
//           isVisible = true;
//           setState(() {
//
//           });
//         },
//         codeAutoRetrievalTimeout: (String verificationID) {});
//   }
//
//   void verifyCode() async {
//     PhoneAuthCredential credential = PhoneAuthProvider.credential(
//         verificationId: verificationIDRecived, smsCode:textEditingController.text);
//     FocusScope.of(context).requestFocus(new FocusNode());
//     Timer(Duration(milliseconds: 4000), () {
//       setState(() {
//         _isLoadingButton = false;
//         _enableButton = false;
//       });
//
//       _scaffoldKey.currentState?.showSnackBar(
//           SnackBar(content: Text("Verification OTP Code $_otpCode Success")));
//     });
//     await auth.signInWithCredential(credential).then((value) =>
//         print('Your are logged in  successfully '));
//   }
//
//   @override
//   void codeUpdated() {
//     setState(() {
//       print('update');
//     });
//   }
//
//
//
// }
//
// //
// // import 'package:flutter/material.dart';
// // import 'package:pin_input_text_field/pin_input_text_field.dart';
// // import 'package:sms_autofill/sms_autofill.dart';
// //
// // void main() => runApp(MyApp());
// //
// // class MyApp extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       theme: ThemeData.light(),
// //       home: HomePage(),
// //     );
// //   }
// // }
// //
// // class HomePage extends StatefulWidget {
// //   @override
// //   _HomePageState createState() => _HomePageState();
// // }
// //
// // class _HomePageState extends State<HomePage> {
// //   String _code="";
// //   String signature = "{{ app signature }}";
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //   }
// //
// //   @override
// //   void dispose() {
// //     SmsAutoFill().unregisterListener();
// //     super.dispose();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       theme: ThemeData.light(),
// //       home: Scaffold(
// //         appBar: AppBar(
// //           title: const Text('Plugin example app'),
// //         ),
// //         body: Padding(
// //           padding: const EdgeInsets.all(8.0),
// //           child: Column(
// //             mainAxisSize: MainAxisSize.max,
// //             mainAxisAlignment: MainAxisAlignment.center,
// //             crossAxisAlignment: CrossAxisAlignment.stretch,
// //             children: <Widget>[
// //               PhoneFieldHint(),
// //               Spacer(),
// //               PinFieldAutoFill(
// //                 decoration: UnderlineDecoration(
// //                   textStyle: TextStyle(fontSize: 20, color: Colors.black),
// //                   colorBuilder: FixedColorBuilder(Colors.black.withOpacity(0.3)),
// //                 ),
// //                 currentCode: _code,
// //                 onCodeSubmitted: (code) {},
// //                 onCodeChanged: (code) {
// //                   if (code!.length == 6) {
// //                     FocusScope.of(context).requestFocus(FocusNode());
// //                   }
// //                 },
// //               ),
// //               Spacer(),
// //               TextFieldPinAutoFill(
// //                 currentCode: _code,
// //               ),
// //               Spacer(),
// //               ElevatedButton(
// //                 child: Text('Listen for sms code'),
// //                 onPressed: () async {
// //                   await SmsAutoFill().listenForCode;
// //                 },
// //               ),
// //               ElevatedButton(
// //                 child: Text('Set code to 123456'),
// //                 onPressed: () async {
// //                   setState(() {
// //                     _code = '123456';
// //                   });
// //                 },
// //               ),
// //               SizedBox(height: 8.0),
// //               Divider(height: 1.0),
// //               SizedBox(height: 4.0),
// //               Text("App Signature : $signature"),
// //               SizedBox(height: 4.0),
// //               ElevatedButton(
// //                 child: Text('Get app signature'),
// //                 onPressed: () async {
// //                   signature = await SmsAutoFill().getAppSignature;
// //                   setState(() {});
// //                 },
// //               ),
// //               ElevatedButton(
// //                 onPressed: () {
// //                   Navigator.of(context).push(MaterialPageRoute(builder: (_) => CodeAutoFillTestPage()));
// //                 },
// //                 child: Text("Test CodeAutoFill mixin"),
// //               )
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
// // class CodeAutoFillTestPage extends StatefulWidget {
// //   @override
// //   _CodeAutoFillTestPageState createState() => _CodeAutoFillTestPageState();
// // }
// //
// // class _CodeAutoFillTestPageState extends State<CodeAutoFillTestPage> with CodeAutoFill {
// //   String? appSignature;
// //   String? otpCode;
// //
// //   @override
// //   void codeUpdated() {
// //     setState(() {
// //       otpCode = code!;
// //     });
// //   }
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     listenForCode();
// //
// //     SmsAutoFill().getAppSignature.then((signature) {
// //       setState(() {
// //         appSignature = signature;
// //       });
// //     });
// //   }
// //
// //   @override
// //   void dispose() {
// //     super.dispose();
// //     cancel();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final textStyle = TextStyle(fontSize: 18);
// //
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text("Listening for code"),
// //       ),
// //       body: Column(
// //         crossAxisAlignment: CrossAxisAlignment.center,
// //         children: <Widget>[
// //           Padding(
// //             padding: const EdgeInsets.fromLTRB(32, 32, 32, 0),
// //             child: Text(
// //               "This is the current app signature: $appSignature",
// //             ),
// //           ),
// //           const Spacer(),
// //           Padding(
// //             padding: const EdgeInsets.symmetric(horizontal: 32),
// //             child: Builder(
// //               builder: (_) {
// //                 if (otpCode == null) {
// //                   return Text("Listening for code...", style: textStyle);
// //                 }
// //                 return Text("Code Received: $otpCode", style: textStyle);
// //               },
// //             ),
// //           ),
// //           const Spacer(),
// //         ],
// //       ),
// //     );
// //   }
// // }
