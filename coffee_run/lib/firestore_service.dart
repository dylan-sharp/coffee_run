import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_run/behavior_subject_extension.dart';
import 'package:coffee_run/models/coffee_group.dart';
import 'package:rxdart/rxdart.dart';

import 'models/order.dart';
import 'models/user_profile.dart';

/// In charge of pulling
class FirestoreService {
  FirestoreService(this._instance) {
    _initializeStreams();
  }

  final FirebaseFirestore _instance;
  String? userId = 'B0nrl6taAOrV7qlajK0m'; // Test ID for now

  late BehaviorSubject<UserProfile?> activeUserStream;
  late BehaviorSubject<List<CoffeeGroup>?> activeCoffeeGroupsStream;

  void _initializeStreams() {
    activeUserStream = _instance
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((event) {
          if (event.exists) {
            return UserProfile.fromJson(event.data()!);
          }
          return null;
        })
        .asBehaviorSubject();

    activeCoffeeGroupsStream = activeUserStream
        .switchMap((value) => value != null
            ? _instance
                .collection('coffeeGroups')
                .where(FieldPath.documentId, whereIn: value.groupIds)
                .snapshots()
                .map((event) => event.docs
                    .map((e) => CoffeeGroup.fromJson(e.data()))
                    .toList())
            : Stream.value(null))
        .asBehaviorSubject();
  }

  Future<void> joinCoffeeGroup(groupId) async {
    // Update two documents.
    // 1.) User doc
    // 2.) Group doc

    dynamic user = await _instance.collection('users').doc(userId).get();
    if (!user.exists) {
      throw Exception(('User does not exist'));
    }
    user = UserProfile.fromJson(user.data()!);

    final batch = _instance.batch();

    batch.update(_instance.collection('users').doc(userId), {
      'groupIds': FieldValue.arrayUnion([groupId])
    });

    batch.update(_instance
        .collection('coffeeGroups')
        .doc(groupId), {'members.$userId': CoffeeGroupMember(user.name).toJson()});

    await batch.commit();

  }

  /// Save an order for a specific group.
  Future<void> saveOrder(String groupId, OrderRun order) async {
    final batch = _instance.batch();

    // Add order
    batch.update(_instance.collection('coffeeGroups').doc(groupId), {
      'orderRuns': FieldValue.arrayUnion([order.toJson()])
    });

    // Update member debts and drinks using dot notation
    Map<String, FieldValue> memberUpdates = {};
    for (var item in order.items) {
      memberUpdates['members.${item.memberId}.debt'] =
          FieldValue.increment(item.cost);
      memberUpdates['members.${item.memberId}.drinks'] =
          FieldValue.increment(1);
    }
    memberUpdates['members.${order.payerId}.debt'] =
        FieldValue.increment(-order.totalCost);

    batch.update(_instance
        .collection('coffeeGroups')
        .doc(groupId), memberUpdates);

    await batch.commit();
  }
}
