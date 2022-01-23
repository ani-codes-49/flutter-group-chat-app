import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  String _enteredMessage = '';
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: 8,
        bottom: 5,
        left: 3,
        right: 3,
      ),
      padding: const EdgeInsets.all(5),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: const InputDecoration(labelText: 'Send a message...'),
              onChanged: (string) {
                setState(() {
                  _enteredMessage = string;
                });
              },
              controller: _controller,
            ),
          ),
          CircleAvatar(
            backgroundColor: _enteredMessage.trim().isEmpty
                ? Colors.grey[700]
                : Theme.of(context).primaryColor,
            radius: 28,
            child: IconButton(
              onPressed: _enteredMessage.trim().isEmpty
                  ? null
                  : () async {
                      final user = FirebaseAuth.instance.currentUser;
                      final userData = await FirebaseFirestore.instance
                          .collection('users')
                          .doc(user!.uid)
                          .get();
                      FirebaseFirestore.instance.collection('chat').add({
                        'text': _enteredMessage,
                        'createdAt': Timestamp.now(),
                        'userId': user.uid,
                        'username': userData.get('username'),
                        'userImage': userData.get('user_image'),
                      });
                      _controller.clear();
                      FocusScope.of(context).unfocus();
                    },
              icon: const Icon(
                Icons.send,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
