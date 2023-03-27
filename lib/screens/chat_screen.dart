// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meet_pet/widgets/chat_bubble.dart';

import '../models/user.dart';
import '../utils/colors.dart';
import 'home_page.dart';

class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool isSender = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        title: Text(
          "UserName",
          style: TextStyle(
            color: primary,
          ),
          textAlign: TextAlign.center,
        ),
        // elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            FontAwesomeIcons.chevronLeft,
            color: primary,
          ),
          onPressed: () {
            zoomDrawerController.toggle!();
          },
        ),
        // shadowColor: secondaryLight,
        shadowColor: Colors.transparent,
      ),
      body: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
          color: secondary,
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: 10, // replace with actual data count
                itemBuilder: (BuildContext context, int index) {
                  // replace with chat bubble widget
                  return ChatBubble(
                      message: "chat bubble", isSender: isSender ^= true);
                },
              ),
            ),
            const Divider(height: 1),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: 'Type a message...',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.send,
                      color: primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
