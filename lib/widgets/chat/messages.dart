import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import '/widgets/chat/message_bubble.dart';

class Messages extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('chat')
              .orderBy('createdAt', descending: true)
              .snapshots(),
          builder: (ctx, chatSnapshot) {
            if (chatSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final chatDoc =
                chatSnapshot.data as QuerySnapshot<Map<String, dynamic>>;
                
            return ListView.builder(
              reverse: true,
              itemCount: chatDoc.size,
              itemBuilder: (ctx, index) => MessageBubble(
                chatDoc.docs.elementAt(index).get('username'),
                chatDoc.docs.elementAt(index).get('text'),
                chatDoc.docs.elementAt(index).get('userImage'),
                chatDoc.docs.elementAt(index).get('userId') ==
                    FirebaseAuth.instance.currentUser!.uid,
                key: ValueKey(chatDoc.docs.elementAt(index).id),
              ),
            );
          },
        );
      },
    );
  }
}
