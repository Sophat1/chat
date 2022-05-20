import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cupertino_list_tile/cupertino_list_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/Home%20Pages/widgets_chat/chat_pages.dart';
import 'package:flutter_chat/Screen%20chats/Chat_room_screens.dart';
import 'package:flutter_chat/Screen%20chats/Group_chat_room_screens.dart';

import 'package:flutter_chat/auth/cotroller_auth/Methods.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  Map<String, dynamic>? userMap;
  bool isLoading = false;
  final TextEditingController _sreachController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    setStatus('Online');
  }

  void setStatus(String status) async {
    await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
      "status": status,
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // online
      setStatus("Online");
    } else {
      // offline
      setStatus("Offline");
    }
  }

  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  void _onSearch() async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;

    setState(() {
      isLoading = true;
    });

    await _firestore
        .collection('users')
        .where("email", isEqualTo: _sreachController.text)
        .get()
        .then((value) {
      setState(() {
        userMap = value.docs[0].data();
        isLoading = false;
      });
      print(userMap);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? Center(
              child: SizedBox(
                height: size.height / 20,
                width: size.height / 20,
                child: const CircularProgressIndicator(),
              ),
            )
          : Column(
              children: [
                const SizedBox(
                  height: 48,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 1.0,
                    left: 12.0,
                    right: 12.0,
                    bottom: 2.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Chats',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.cyan,
                          fontSize: 30,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.logout),
                        onPressed: () => logOut(context),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    right: 10,
                    left: 10,
                    top: 1,
                    bottom: 10,
                  ),
                  child: TextFormField(
                    controller: _sreachController,
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      // fontSize: 10.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        fontSize: 20,
                      ),
                      suffixIcon: IconButton(
                        // onPressed: _onSearch,
                        onPressed: () {},
                        icon: const Icon(
                          Icons.search_outlined,
                          color: Colors.cyan,
                        ),
                      ),
                      hintText: 'Search...',
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
                          color: Colors.cyan,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),

                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Users')
                      .orderBy('message', descending: true)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    var chatDocs = snapshot.data!.docs;
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            title: chatDocs[index]['name'],
                          ),
                        );
                      },
                      itemCount: chatDocs.length,
                    );
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                // StreamBuilder<QuerySnapshot>(
                //   stream: FirebaseFirestore.instance
                //       .collection("users")
                //       .snapshots(),
                //   builder: (BuildContext context,
                //       AsyncSnapshot<QuerySnapshot> snapshot) {
                //     if (snapshot.hasError) {
                //       return const Center(
                //         child: Text('Something Went Wrong'),
                //       );
                //     }
                //     if (snapshot.connectionState == ConnectionState.waiting) {
                //       return const Center(
                //         child: Text('Loading....'),
                //       );
                //     }
                //     if (snapshot.hasData) {
                //       return CustomScrollView(
                //         slivers: [
                //           const CupertinoScrollbar(
                //             child: Text('New'),
                //           ),
                //           SliverList(
                //               delegate: SliverChildListDelegate(snapshot
                //                   .data!.docs
                //                   .map((DocumentSnapshot document) {
                //             Map<String, dynamic> data;
                //             // var chatDocs = snapshot.data!.docs;
                //             return CupertinoListTile(
                //                 title: Text(data['name']),
                //                 subtitle: Text(data['message']),
                //                 onTap: () => callChatDetailScreen(context,
                //                     data['name'], data['Uid']),
                //                 );
                //           }).toList()))
                //         ],
                //       );
                //     }
                //     return Container();
                //   },
                // ),
                userMap != null
                    ? ListTile(
                        onTap: () {
                          String roomId = chatRoomId(
                              _auth.currentUser!.displayName!,
                              userMap!['name']);

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ChatRoomScreens(
                                chatRoomID: roomId,
                                userMap: userMap!,
                              ),
                            ),
                          );
                        },
                        leading:
                            const Icon(Icons.account_box, color: Colors.black),
                        title: Text(
                          userMap!['name'],
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Text(
                          userMap!['email'],
                        ),
                        trailing: const Icon(
                          Icons.chat,
                          color: Colors.black,
                        ),
                      )
                    : Container(),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.cyan,
        foregroundColor: Colors.black,
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => GroupChatRoomScreens(
              groupName: "groupName",
              groupChatId: "groupChatId",
            ),
          ),
        ),
        // onPressed: () {
        //   setState(() {
        //     Navigator.of(context).push(
        //       MaterialPageRoute(
        //         builder: (_) => ChatPages(),
        //       ),
        //     );
        //   });
        // },
        icon: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        label: const Text(
          'Create Room',
          style: TextStyle(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
