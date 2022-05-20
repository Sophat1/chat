import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/Home%20Pages/widgets_chat/show_message.dart';
import 'package:flutter_chat/Home%20Pages/widgets_chat/text_messages.dart';

class ChatPages extends StatefulWidget {
  const ChatPages({Key? key}) : super(key: key);

  @override
  State<ChatPages> createState() => _ChatPagesState();
}

class _ChatPagesState extends State<ChatPages> {
  bool isLoading = false;
  late final Map<String, dynamic> userMap;
  final TextEditingController _sendingcontroller = TextEditingController();
  final storeMessage = FirebaseFirestore.instance;
  final FirebaseFirestore _firestoreMessage = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  void _onSendingMessage() async {
    if (_sendingcontroller.text.isNotEmpty) {
      Map<String, dynamic> messages = {
        "sendby": _auth.currentUser!.email,
        "message": _sendingcontroller.text,
        "type": "text",
        "time": FieldValue.serverTimestamp(),
      };

      _sendingcontroller.clear();
      await _firestoreMessage
          .collection('messages')
          .doc(_auth.currentUser!.email)
          .collection('chats')
          .add(messages);
    } else {
      print("Enter Some Text");
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: isLoading
          ? Center(
              child: SizedBox(
                height: size.height / 20,
                width: size.height / 20,
                child: const CircularProgressIndicator(),
              ),
            )
          : SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  header(size),
                  const Expanded(
                    child: TextMessages(),
                  ),
                  inputFieldSending(
                    size,
                    _sendingcontroller,
                  ),
                ],
              ),
            ),
    );
  }

  Widget header(Size size) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 65,
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey,
              width: 1.5,
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  width: 2,
                  color: Colors.grey,
                ),
              ),
              child: Center(
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    setState(() {
                      Navigator.pop(context);
                    });
                  },
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            InkWell(
              onTap: () {
                // ignore: avoid_print
                print('Hello World');
              },
              child: Row(
                children: const [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.green,
                    child: CircleAvatar(
                      radius: 23,
                      backgroundColor: Colors.white,
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    "SONN SOPHAT",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 50,
            ),
            Container(
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  width: 2,
                  color: Colors.grey,
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.call,
                      color: Colors.cyan,
                    ),
                    onPressed: () {
                      // setState(() {
                      //   Navigator.pop(context);
                      // });
                      print('Call');
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.video_call_rounded,
                      color: Colors.cyan,
                    ),
                    onPressed: () {
                      // setState(() {
                      //   Navigator.pop(context);
                      // });
                      print('Video Call');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget inputFieldSending(
    Size size,
    TextEditingController valuecontroller,
  ) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SizedBox(
        child: TextFormField(
          controller: valuecontroller,
          style: const TextStyle(
            fontSize: 19.0,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          decoration: InputDecoration(
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              fontSize: 20,
            ),
            hintText: 'Send Message',
            suffixIcon: IconButton(
              onPressed: _onSendingMessage,
              icon: const Icon(
                Icons.send_rounded,
                color: Colors.cyan,
              ),
            ),
            hintStyle: const TextStyle(color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(28),
            ),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(28),
              ),
              borderSide: BorderSide(
                color: Colors.grey,
                width: 2,
              ),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(28),
              ),
              borderSide: BorderSide(
                color: Colors.blue,
                width: 2,
              ),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Enter Your Email and Password";
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget messages(Size size, Map<String, dynamic> map, BuildContext context) {
    return map['type'] == "text"
        ? Container(
            width: size.width,
            alignment: map['sendby'] == _auth.currentUser!.email
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.blue,
              ),
              child: Text(
                map['message'],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          )
        : Container(
            height: size.height / 2.5,
            width: size.width,
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            alignment: map['sendby'] == _auth.currentUser!.displayName
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: InkWell(
              // onTap: () => Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (_) => ShowImage(
              //       imageUrl: map['message'],
              //     ),
              //   ),
              // ),
              child: Container(
                height: size.height / 2.5,
                width: size.width / 2,
                decoration: BoxDecoration(border: Border.all()),
                alignment: map['message'] != "" ? null : Alignment.center,
                child: map['message'] != ""
                    ? Image.network(
                        map['message'],
                        fit: BoxFit.cover,
                      )
                    : const CircularProgressIndicator(),
              ),
            ),
          );
  }
}
