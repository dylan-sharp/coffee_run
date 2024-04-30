import 'package:coffee_run/firestore_service.dart';
import 'package:coffee_run/models/coffee_group.dart';
import 'package:coffee_run/models/order.dart';
import 'package:coffee_run/models/user_profile.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FirestoreService tests', () {
    late FakeFirebaseFirestore fakeFirestore;
    late FirestoreService firestoreService;
    final testUserId = 'B0nrl6taAOrV7qlajK0m';
    final testGroupId = 'testGroupId';
    final testUserName = 'Test User';
    final testUserGroupIds = ['groupId1', 'groupId2'];

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      firestoreService = FirestoreService(fakeFirestore);

      // Create a test user and group in Firestore
      final userProfile = UserProfile(testUserId, testUserName, testUserGroupIds);
      fakeFirestore.collection('users').doc(testUserId).set(userProfile.toJson());
      fakeFirestore.collection('coffeeGroups').doc(testGroupId).set(CoffeeGroup('Test Group', {}).toJson());
    });

    test('joinCoffeeGroup() should update user and group documents', () async {
      await firestoreService.joinCoffeeGroup(testGroupId);

      // Verify that user's groupIds are updated
      final userSnapshot = await fakeFirestore.collection('users').doc(testUserId).get();
      final updatedUserGroupIds = List.from(userSnapshot.data()?['groupIds'] ?? []);
      expect(updatedUserGroupIds.contains(testGroupId), true);

      // Verify that the user is added as a member in the group
      final groupSnapshot = await fakeFirestore.collection('coffeeGroups').doc(testGroupId).get();
      final groupMembers = Map.from(groupSnapshot.data()?['members'] ?? {});
      expect(groupMembers.containsKey(testUserId), true);
      expect(groupMembers[testUserId]['name'], testUserName);
      expect(groupMembers[testUserId]['debt'], 0);
      expect(groupMembers[testUserId]['drinks'], 0);
    });

    test('saveOrder() should update group document and member debts/drinks', () async {
      final testItem = OrderItem('itemName', 10.0, 'userId', id: 'itemId');
      final testOrder = OrderRun('payerId', DateTime.now(), [testItem], id: 'orderId');

      await fakeFirestore.collection('coffeeGroups').doc(testGroupId).update({
        'members.${testItem.memberId}': CoffeeGroupMember('payerName').toJson(),
        'members.${testOrder.payerId}': CoffeeGroupMember('userName').toJson()
      });
      await firestoreService.saveOrder(testGroupId, testOrder);

      // Verify that the order is added to the group's orderRuns
      final groupSnapshot = await fakeFirestore.collection('coffeeGroups').doc(testGroupId).get();
      final orderRuns = List.from(groupSnapshot.data()?['orderRuns'] ?? []);
      expect(orderRuns.length, 1);
      expect(orderRuns.first['id'], 'orderId');

      // Verify that member debts and drinks are updated
      final groupMembers = Map.from(groupSnapshot.data()?['members'] ?? {});

      final payerId = testOrder.payerId;
      expect(groupMembers.containsKey(payerId), true);
      expect(groupMembers[payerId]['debt'], -testOrder.totalCost);
      expect(groupMembers[payerId]['drinks'], 0);

      final userId = testItem.memberId;
      expect(groupMembers.containsKey(userId), true);
      expect(groupMembers[userId]['debt'], testItem.cost);
      expect(groupMembers[userId]['drinks'], 1);
    });
  });
}
