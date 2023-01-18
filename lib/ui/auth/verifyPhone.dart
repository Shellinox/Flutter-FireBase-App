import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseapp/posts/post_screen.dart';
import 'package:flutter/material.dart';

import '../../util/utils.dart';

class VerifyPhone extends StatefulWidget {
  final String verificationID;

  const VerifyPhone({Key? key, required this.verificationID}) : super(key: key);

  @override
  State<VerifyPhone> createState() => _VerifyPhoneState();
}

class _VerifyPhoneState extends State<VerifyPhone> {
  final verificationCode = TextEditingController();
  final _auth = FirebaseAuth.instance;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify"),
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
              controller: verificationCode,
              decoration: const InputDecoration(
                border: OutlineInputBorder(borderSide: BorderSide(width: 2)),
                hintText: 'Enter 6 digit code',
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                  onPressed: ()async {
                    setState(() {
                      loading=true;
                    });
                    final credential = PhoneAuthProvider.credential(
                        verificationId: widget.verificationID,
                        smsCode: verificationCode.text.toString());
                    try{
                      await _auth.signInWithCredential(credential);
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>const PostScreen())).then((value){
                        setState(() {
                          loading=false;
                        });
                      });
                    }
                    catch(e){
                      setState(() {
                        loading=false;
                      });
                      Utils().toastMessage(e.toString());
                    }
                  },

                  child: loading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text('Verify')),
            ),
          ],
        ),
      ),
    );
  }
}
