import 'package:firebase_database/firebase_database.dart';
import 'package:firebaseapp/posts/post_screen.dart';
import 'package:firebaseapp/util/utils.dart';
import 'package:flutter/material.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final databaseRef = FirebaseDatabase.instance.ref('Post');
  bool loading = false;
  final _postController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add info'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _postController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: "What's on your mind",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        loading = true;
                      });
                      String id=DateTime.now().millisecondsSinceEpoch.toString();
                      databaseRef.child(id).set({
                        'Information': _postController.text.toString(),
                        'id': id
                      }).then((value) {
                        _postController.clear();
                        Utils().toastMessage('Post Added');
                        setState(() {
                          loading = false;
                        });
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>const PostScreen()));
                      }).onError((error, stackTrace) {
                        Utils().toastMessage(error.toString());
                        setState(() {
                          loading = false;
                        });
                      });
                    },
                    child: loading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text("Add"))),
          ],
        ),
      ),
    );
  }
}
