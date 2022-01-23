import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../widgets/chat/messages.dart';
import '../widgets/app_drawer.dart';
import '../widgets/chat/new_message.dart';

class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

Future<void> _handler(RemoteMessage message) async {
  dynamic body = message.notification!.body;
  dynamic title = message.notification!.title;
  print('onBackgroundMessage ' + title + body);
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {

    super.initState();

    FirebaseMessaging.onBackgroundMessage(_handler);

    FirebaseMessaging.onMessage.listen((value) {
      dynamic body = value.notification!.body;
      dynamic title = value.notification!.title;
      print('onMessage ' + title + body);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((value) {
      dynamic body = value.notification!.body;
      dynamic title = value.notification!.title;
      print('onMessageOpened ' + title + body);
    });

  //  FirebaseMessaging.instance.subscribeToTopic('chat');

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter App'),
      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Container(
                    child: Column(
                      children: [
                        Expanded(
                          child: Messages(),
                        ),
                        NewMessage(),
                      ],
                    ),
                  ),
      ),
      drawer: AppDrawer(),
    );
  }
}
