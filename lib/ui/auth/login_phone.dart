import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseapp/ui/auth/verifyPhone.dart';
import 'package:firebaseapp/util/utils.dart';
import 'package:flutter/material.dart';

class LoginPhone extends StatefulWidget {
  const LoginPhone({Key? key}) : super(key: key);

  @override
  State<LoginPhone> createState() => _LoginPhoneState();
}

class _LoginPhoneState extends State<LoginPhone> {
  final phoneNumberController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login with number"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            TextField(
              keyboardType: TextInputType.number,
              controller: phoneNumberController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(borderSide: BorderSide(width: 2)),
                labelText: "Phone number",
                hintText: '+91 565 3522 467',
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      loading = true;
                    });
                    _auth.verifyPhoneNumber(
                      phoneNumber: phoneNumberController.text,
                      verificationCompleted: (_) {
                        setState(() {
                          loading=false;
                        });
                      },
                      verificationFailed: (e) {
                        setState(() {
                          loading=false;
                        });
                        Utils().toastMessage(e.toString());
                      },
                      codeSent: (String verificationID, int? token) {
                        setState(() {
                          loading=false;
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => VerifyPhone(
                                      verificationID: verificationID,
                                    )));
                        setState(() {
                          loading=false;
                        });
                      },
                      codeAutoRetrievalTimeout: (e) {
                        setState(() {
                          loading=false;
                        });
                        Utils().toastMessage(e.toString());
                      },
                    );
                  },
                  child: loading
                      ? const CircularProgressIndicator(color: Colors.white,)
                      : const Text('Login')),
            ),
          ],
        ),
      ),
    );
  }
}
