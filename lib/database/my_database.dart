import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/my_user.dart';

class MyDataBase {
  static CollectionReference<MyUser> getUserCollection() {
    return FirebaseFirestore.instance
        .collection(MyUser.collectionName)
        .withConverter(
      fromFirestore: (snapshot, options) =>
          MyUser.fromFireStore(snapshot.data()!),
      toFirestore: (value, options) => value.toFireStore(),
    );
  }

  static Future<MyUser?> insertUser(MyUser user) async {
    var collection = getUserCollection();
    var docRef = collection.doc(user.id);
    var res = await docRef.set(user);
    return user;
  }

  static Future<MyUser?> getUserById(String uid) async {
    var collection = getUserCollection();
    var docRef = collection.doc(uid);
    var res = await docRef.get();
    return res.data();
  }}