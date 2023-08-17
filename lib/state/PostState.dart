import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
// Avatar
//import 'package:cached_network_image/cached_network_image.dart';
// Firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

// Hive Local Database
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';

class PostState with ChangeNotifier {
  final Box<dynamic> _appBox = Hive.box('app_state');
  final Reference _DPref = FirebaseStorage.instance.ref('profile');
  final CollectionReference _posts = FirebaseFirestore.instance.collection('posts');

  Widget getAvatar(String userId, [double radius = 25]) {
    final Widget child = CircleAvatar(radius: radius, child: const Icon(Icons.person_rounded));
    return FutureBuilder<String>(
      future: _DPref.child(userId).getDownloadURL(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          return CircleAvatar(foregroundImage: NetworkImage(snapshot.data!), radius: radius, child: const Icon(Icons.person_rounded));
          /*return CachedNetworkImage(
            imageUrl: snapshot.data!,
            placeholder: (context, url) => child,
            errorWidget: (context, url, error) => child,
            imageBuilder: (context, imageProvider) => CircleAvatar(
              radius: radius,
              backgroundImage: imageProvider,
            ),
          );*/
        }
        return child;
      },
    );
  }

  Future<bool> addPost(Map<String, dynamic> post) async {
    var r = await _posts.add(post
      ..addAll({
        'userId': _appBox.get('userId', defaultValue: '@abc'),
        'timestamp': FieldValue.serverTimestamp(),
      }));
    return true;
  }

  void addDataToBhavcopy(String symbol, double price, double change, int volume, double deliveryPercentage, String logoUrl) {
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref().child('bhavcopy');

    // Create a map with the data for the new symbol
    List<dynamic> symbolData = [symbol,price,volume,change,deliveryPercentage];

    // Use the symbol as the key to add the data to the "bhavcopy" node
    databaseReference.child(symbol).set(symbolData).then((_) {
      print('Symbol added successfully!');
    }).catchError((error) {
      print('Failed to add symbol: $error');
    });
  }

  void addUserProfile(String firstName, String lastName, String phone){
    String uid = FirebaseAuth.instance.currentUser!.uid;

    DatabaseReference usersRef = FirebaseDatabase.instance.ref().child('users');
    usersRef.child(uid).set({
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
    });
  }

  void addDataToMeta(Map<dynamic, dynamic> metaData) {
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref().child('meta');

    // Use set() method to add the data to the "meta" node
    databaseReference.set(metaData).then((_) {
      print('Data added to "meta" node successfully!');
    }).catchError((error) {
      print('Failed to add data to "meta" node: $error');
    });
  }

  Stream<QuerySnapshot> getFeed({String? symbol}) {
    if (symbol == null) {
      return _posts.orderBy('timestamp', descending: true).snapshots();
    } else {
      return _posts.where('mentions', arrayContains: '#${symbol}').orderBy('timestamp', descending: true).snapshots();
    }
  }

  Stream<QuerySnapshot> getSymbolFeed(String symbol) => _posts.where('mentions', arrayContains: '#${symbol}').orderBy('timestamp', descending: true).snapshots();

  Future<String> getDp(String userId) => _DPref.child(userId).getDownloadURL();
}
