import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TextMessages extends StatefulWidget {
  const TextMessages({Key? key}) : super(key: key);

  @override
  State<TextMessages> createState() => _TextMessagesState();
}

class _TextMessagesState extends State<TextMessages> {
  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser!.uid;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('messages')
          .orderBy('time', descending: true)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        var chatDocs = snapshot.data!.docs;
        return ListView.builder(
          itemBuilder: (context, index) {
            return MessagesDouble(
              message: chatDocs[index]['message'],
              name: chatDocs[index]['sendby'],
            );
          },
          itemCount: chatDocs.length,
        );
      },
    );
  }
}

class MessagesDouble extends StatelessWidget {
  final String message;
  final String name;

  const MessagesDouble({
    Key? key,
    required this.message,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          message,
          style: const TextStyle(
            color: Colors.green,
            fontSize: 20,
          ),
        )
      ],
    );
  }
}
