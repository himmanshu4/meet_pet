// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_state_manager/src/simple/list_notifier.dart';

import '../models/user.dart';
import 'package:meet_pet/models/chatroom.dart';
import '../utils/colors.dart';
import 'home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meet_pet/resources/chat_methods.dart';

import 'add_friends.dart';

class ChatTile extends StatelessWidget {
  final String profileImg, firstName, lastName;
  final int unreads;
  const ChatTile(
      {super.key,
      required this.profileImg,
      required this.firstName,
      required this.lastName,
      required this.unreads});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Image.network(profileImg),
        title: Text("$firstName $lastName", maxLines: 1),
        trailing: (unreads > 0 ? Icon(Icons.mark_unread_chat_alt) : Text("")));
  }
}

class ChatData {
  String profileImg, token, heading, name;
  late DateTime lastMessageAt;
  ChatData(
      {this.heading = "Loading...",
      this.profileImg = "",
      required this.token,
      lastMessageAt,
      this.name = "Loading..."}) {
    this.lastMessageAt =
        lastMessageAt ?? DateTime.fromMicrosecondsSinceEpoch(0);
  }
}

class AllChats extends StatefulWidget {
  final User cUser;
  const AllChats({
    Key? key,
    required this.cUser,
  }) : super(key: key);

  @override
  State<AllChats> createState() => _AllChatsState();
}

class _AllChatsState extends State<AllChats> {
  //store all chats according to token
  Map<String, ChatData> chatdb = {};

  late dynamic usersQuery;
  bool _isLoading = false;
  List<String> friendList = [];

  @override
  void initState() {
    super.initState();
    //remember to check if user profile updates
    usersQuery = getUserData();
  }

  getUserData() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(widget.cUser.uid)
        .collection('friends')
        .snapshots()
        .listen((snapshot) {
      friendList = [];
      for (var element in snapshot.docs) {
        friendList.add(element.id);
      }
      // print(friendList);
      if(mounted)
      setState(() {});
      else print("not mounted");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        title: Text(
          "Chats",
          style: TextStyle(
            color: primary,
          ),
          textAlign: TextAlign.center,
        ),
        // elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            FontAwesomeIcons.barsStaggered,
            color: primary,
          ),
          onPressed: () {
            zoomDrawerController.toggle!();
          },
        ),
        // shadowColor: secondaryLight,
        shadowColor: Colors.transparent,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return AddFriends(
                        cUser: widget.cUser,
                        friends:friendList
                      );
                    },
                  ),
                );
              },
              icon: Icon(
                FontAwesomeIcons.amazonPay,
                color: Colors.amber,
              ))
        ],
      ),
      body: (friendList.isEmpty
          ? Text("No friends")
          : StreamBuilder(
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Text("loading");
                } else {
                  if (snapshot.data?.size == 0) return Text("0");
                  return ListView(
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> userData =
                          document.data() as Map<String, dynamic>;
                      return ChatTile(
                        profileImg: userData["profileImg"],
                        firstName: userData["firstName"],
                        lastName: userData["lastName"],
                        unreads: 0,
                      );
                    }).toList(),
                  );
                }
              },
              //only needs profile data
              stream: FirebaseFirestore.instance
                  .collection("/users")
                  .where("uid", whereIn: friendList)
                  .snapshots(),
            )),
    );
  }
}
