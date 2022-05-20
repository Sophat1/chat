import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ShowMessages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("messages").snapshots(),
      builder: (context, snapshots) {
        if (!snapshots.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
          itemBuilder: (context, index) {
            QueryDocumentSnapshot messages = snapshots.data!.docs[index];
            return ListTile(
              title: Text(messages['messages']),
            );
          },
        );
      },
    );
  }
}
