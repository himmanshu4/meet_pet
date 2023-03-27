import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import '../utils/colors.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isSender;

  const ChatBubble({Key? key, required this.message, required this.isSender})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Neumorphic(
          padding: const EdgeInsets.all(10),
          margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.width * 0.01,
              bottom: MediaQuery.of(context).size.width * 0.01),
          // decoration: BoxDecoration(
          //   color: secondary,
          //   borderRadius: BorderRadius.circular(20),
          // ),
          style: NeumorphicStyle(
            shape: NeumorphicShape.concave,
            surfaceIntensity: .1,
            color: secondary,
            // color: pink,
            shadowLightColor: secondaryLight,
            shadowDarkColor: secondaryDark,
            depth: 18,
          ),
          child: Flexible(
            child: Text(
              message,
              textScaleFactor: 1.5,
              style: TextStyle(
                color: (isSender) ? primary : black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
