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

  sendMessage(Message message) {
    var token = message.token;
    return firestore
        .collection("chats")
        .doc(token)
        .collection("messages")
        .doc(randomString()+message.senderID)
        .set(message.toFireStore());
  }

  sendImage({
    required String path,
    required String senderID,
    required String receiverID,
  }) async {
    var task = uploadFile(
      file: File(path),
      fileName: ChatMethods.randomString(),
    );
    var snapshot = await task;
    var downloadURL = await snapshot.ref.getDownloadURL();
    task.whenComplete(() {
      sendMessage(Message(
          senderID: senderID,
          receiverID: receiverID,
          timestamp: DateTime.now(),
          message: downloadURL,
          messageType: MessageType.image));
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getMessageStream(String token) {
    return firestore
        .collection("chats")
        .doc(token)
        .collection("messages")
        .orderBy("timestamp")
        .snapshots();
  }

  Stream<QuerySnapshot> getChatListStream(
      String uid1, List<String> friendList, int limit) {
    return firestore
        .collection('chats')
        .where("token",
            whereIn: friendList.map((e) => getToken(uid1, e)).toList())
        .orderBy("lastMessage", descending: true)
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

  sendFriendRequest(String uid1, String uid2) {
    final u1ref = firestore.collection("users").doc(uid1);
    final u2ref = firestore.collection("users").doc(uid2);
    final data = {"time": DateTime.now()};
    return firestore.runTransaction((transaction) async {
      transaction.set(u1ref.collection("sentRequests").doc(uid2), data);
      transaction.set(u2ref.collection("receivedRequests").doc(uid1), data);
    });
  }

  acceptFriendRequest(String uid1, String uid2) {
    final token = getToken(uid1, uid2);
    final u1ref = firestore.collection("users").doc(uid1);
    final u2ref = firestore.collection("users").doc(uid2);
    return firestore.runTransaction((transaction) async {
      transaction.set(firestore.collection("chatroom").doc(token), {});
      transaction.delete(u1ref.collection('receivedRequests').doc(uid2));
      transaction.delete(u2ref.collection('sentRequests').doc(uid1));
      transaction
          .set(u1ref.collection('friends').doc(uid2), {"time": DateTime.now()});
      transaction
          .set(u2ref.collection('friends').doc(uid1), {"time": DateTime.now()});
    });
  }
}
