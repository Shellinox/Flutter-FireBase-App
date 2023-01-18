import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebaseapp/ui/auth/login_screen.dart';
import 'package:firebaseapp/util/utils.dart';
import 'package:flutter/material.dart';
import 'add_posts.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref('Post');
  final searchQuery = TextEditingController();
  final editController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Post screen"),
        actions: [
          IconButton(
              onPressed: () {
                auth.signOut().then((value) {
                  Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()))
                      .onError((error, stackTrace) {
                    Utils().toastMessage(error.toString());
                  });
                });
              },
              icon: const Icon(Icons.logout_outlined)),
          const SizedBox(
            width: 10,
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextFormField(
              controller: searchQuery,
              onChanged: (String value) {
                setState(() {});
              },
              decoration: const InputDecoration(
                  hintText: "Search", border: OutlineInputBorder()),
            ),
          ),
          Expanded(
              child: FirebaseAnimatedList(
            query: ref,
            itemBuilder: (BuildContext context, DataSnapshot snapshot,
                Animation<double> animation, int index) {
              final title = snapshot.child('Information').value.toString();
              if (searchQuery.text.isEmpty) {
                return ListTile(
                  title: Text(snapshot.child('Information').value.toString()),
                  subtitle: Text(snapshot.child('id').value.toString()),
                  trailing: PopupMenuButton(
                    itemBuilder: (BuildContext context) => [
                      PopupMenuItem(
                          value: 1,
                          child: ListTile(
                              title: const Text("Edit"),
                              leading: const Icon(Icons.edit),
                              onTap: () {
                                Navigator.pop(context);
                                showMyDialog(title,
                                    snapshot.child('id').value.toString());
                              })),
                       PopupMenuItem(
                          value: 1,
                          child: ListTile(
                            onTap: (){
                              ref.child(snapshot.child('id').value.toString()).remove();
                              Navigator.pop(context);
                            },
                            title: Text("Delete"),
                            leading: Icon(Icons.delete),
                          )),
                    ],
                  ),
                );
              } else if (title
                  .toLowerCase()
                  .contains(searchQuery.text.toLowerCase().toString())) {
                return ListTile(
                  title: Text(snapshot.child('Information').value.toString()),
                  subtitle: Text(snapshot.child('id').value.toString()),
                );
              } else {
                return Container();
              }
            },
          ))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddPostScreen()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> showMyDialog(String title, String id) async {
    editController.text = title;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Edit Post'),
            content: Container(
              child: TextField(
                controller: editController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: "Edit"),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ref.child(id).update({
                      'Information': editController.text.toString()
                    }).then((value) {
                      Utils().toastMessage("Post Updated");
                    }).onError((error, stackTrace) {
                      Utils().toastMessage(error.toString());
                    });
                  },
                  child: const Text('Update')),
            ],
          );
        });
  }
}
