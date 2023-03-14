import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:meet_pet/models/message.dart';

class ChatMethods {
  late FirebaseFirestore firestore;
  late FirebaseStorage storage;
  ChatMethods({FirebaseFirestore? firestore, FirebaseStorage? storage}) {
    this.firestore = firestore ?? FirebaseFirestore.instance;
    this.storage = storage ?? FirebaseStorage.instance;
  }

  ///uploads files at [fileName]
  UploadTask uploadFile({required File file, required String fileName}) {
    Reference ref = storage.ref().child(fileName);
    return ref.putFile(file);
  }

  sendMessage(Message message, String currentUserId) {
    var token = message.token;
    return firestore
        .collection("chats")
        .doc(token)
        .collection(token)
        .doc(randomString() + message.senderID)
        .set(message.toFireStore());
  }

  Stream<QuerySnapshot> getChatStream(String token, int limit) {
    return firestore
        .collection('chats')
        .doc(token)
        .collection(token)
        .orderBy("timestamp", descending: true)
        .limit(limit)
        .snapshots();
  }

  static String getToken(String uid1, String uid2) {
    if (uid1 == uid2) {
      throw Exception("Same user");
    }
    if (uid1.compareTo(uid2) < 0) {
      return "$uid1-$uid2";
    } else {
      return "$uid2-$uid1";
    }
  }

  static String randomString() {
    return DateTime.now().microsecondsSinceEpoch.toString();
  }

  void makeFriends(String uid1, String uid2) async {
    var token = getToken(uid1, uid2);
    print("adding friend");
    var user1 = firestore.collection('users').doc(uid1);
    var user2 = firestore.collection('users').doc(uid2);
    firestore.collection('users').doc(uid1).collection("friends").doc(uid2).set({}).onError((error, stackTrace) {
      print(error);
    });
    user2.collection('friends').doc(uid1).set({"friends":1});
  }
}
