import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_run/behavior_subject_extension.dart';
import 'package:coffee_run/models/coffee_group.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

import 'models/order.dart';
import 'models/user_profile.dart';

/// Status of weather we are loading user profile, this is a new user, or the profile is loaded
enum UserStatus { loading, newUser, profileLoaded }

/// Core class for interacting with our Firestore database
/// Setups up deserialization streams and provides helper functions
/// for specific serialization tasks (i.e. saving an order).
class FirestoreService {
  static const activeGroupId = '1'; // TODO - expand feature set to allow for groups

  // Initialize deserialization streams for the rest of our application to access
  FirestoreService(this._instance, this._auth) {
    _initializeStreams();
  }

  final FirebaseFirestore _instance;
  final FirebaseAuth _auth;

  // The active user id from FirebaseAuth
  String? get activeUserId => _auth.currentUser?.uid;

  // Behavior Subject containing the current profile status and user profile from firestore
  late BehaviorSubject<({UserStatus userStatus, UserProfile? userProfile})>
      activeUserStream;

  // Behavior Subject of our current coffee group from firestore
  late BehaviorSubject<CoffeeGroup?> activeCoffeeGroup;

  // Initialize our behavior subjects / streams
  void _initializeStreams() {

    // Listen to our auth state and swap the stream to our user profile doc
    // Inside this mapping we inject the user status
    activeUserStream = _auth.authStateChanges().switchMap((value) {

      if (value != null) {
        return _instance.collection('users').doc(value.uid).snapshots();
      }

      // FirebaseAuth doesn't have a user or is still initializing
      return Stream.value(null);
    }).map((event) {
      // Map the firebase document stream into our UserProfile and UserStatus
      UserProfile? userProfile;
      var userStatus = UserStatus.loading;

      if (event != null && event.exists) {
        userProfile = UserProfile.fromJson(event.data()!);
        userStatus = UserStatus.profileLoaded;
      } else if (event != null && !event.exists) {
        userStatus = UserStatus.newUser;
      }

      return (userStatus: userStatus, userProfile: userProfile);
    }).asBehaviorSubject();

    // Listen to the active group and deserialize to CoffeeGroup
    activeCoffeeGroup = _instance
        .collection('coffeeGroups')
        .doc(activeGroupId)
        .snapshots()
        .map((e) => e.exists ? CoffeeGroup.fromJson(e.data()!) : null)
        .asBehaviorSubject();
  }

  /// Save an order to firestore
  Future<void> saveOrder(CoffeeOrder order) async {
    final batch = _instance.batch();

    // Add order to group
    batch.update(_instance.collection('coffeeGroups').doc(activeGroupId), {
      'orderRuns': FieldValue.arrayUnion([order.toJson()])
    });

    // Calculate member debt and drinks
    Map<String, double> memberDebt = {};
    Map<String, double> memberDrinks = {};
    for (var item in order.items) {
      assert(item.memberId != null);
      assert(item.cost != null);

      memberDebt[item.memberId!] =
          (memberDebt[item.memberId] ?? 0) + item.cost!;
      memberDrinks[item.memberId!] = (memberDrinks[item.memberId] ?? 0) + 1;
    }

    // Update member debts and drinks using dot notation for firestore
    Map<String, FieldValue> memberUpdates = {};
    for (var memberId in memberDebt.keys) {
      var debt = memberDebt[memberId] ?? 0;
      if (debt != 0) {
        memberUpdates['members.$memberId.debt'] = FieldValue.increment(debt);
      }
    }
    for (var memberId in memberDrinks.keys) {
      var drinks = memberDrinks[memberId] ?? 0;
      memberUpdates['members.$memberId.drinks'] = FieldValue.increment(drinks);
    }

    // Incorporate negative debt of the payer
    // This overwrites any debt added in this payers name above so we need to calculate the offset
    var payerDebt = memberDebt[order.payerId] ?? 0;
    memberUpdates['members.${order.payerId}.debt'] =
        FieldValue.increment(payerDebt - order.totalCost);

    batch.update(
        _instance.collection('coffeeGroups').doc(activeGroupId), memberUpdates);

    await batch.commit();
  }

  /// Create a user in firestore
  Future<void> createUser(UserProfile user) async {
    assert(user.id != null);
    // Create user doc
    // Add user to group 1
    user.groupIds.add(activeGroupId);

    final batch = _instance.batch();
    batch.set(_instance.collection('users').doc(user.id), user.toJson());
    batch.update(_instance.collection('coffeeGroups').doc(activeGroupId), {
      'members.${user.id}': CoffeeGroupMember(user.name, user.avatarId).toJson()
    });

    await batch.commit();
  }

// Future<void> joinCoffeeGroup(groupId) async {
//   // Update two documents.
//   // 1.) User doc
//   // 2.) Group doc
//
//   dynamic user = await _instance.collection('users').doc(userId).get();
//   if (!user.exists) {
//     throw Exception(('User does not exist'));
//   }
//   user = UserProfile.fromJson(user.data()!);
//
//   final batch = _instance.batch();
//
//   batch.update(_instance.collection('users').doc(userId), {
//     'groupIds': FieldValue.arrayUnion([groupId])
//   });
//
//   batch.update(_instance.collection('coffeeGroups').doc(groupId),
//       {'members.$userId': CoffeeGroupMember(user.name, user.avatarId).toJson()});
//
//   await batch.commit();
// }
}
