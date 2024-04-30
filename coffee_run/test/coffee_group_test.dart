import 'package:coffee_run/models/coffee_group.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CoffeeGroup tests', () {
    test('toJson() should return a valid JSON map', () {
      final coffeeGroup = CoffeeGroup('Test Group', {});
      final jsonMap = coffeeGroup.toJson();

      expect(jsonMap, isMap);
      expect(jsonMap['id'], isNotNull);
      expect(jsonMap['name'], 'Test Group');
      expect(jsonMap['members'], {});
      expect(jsonMap['orderRuns'], []);
    });

    test('fromJson() should create a valid CoffeeGroup object', () {
      final Map<String, dynamic> jsonMap = {
        'id': '123',
        'name': 'Test Group',
        'members': <String, dynamic>{},
        'orderRuns': []
      };
      final coffeeGroup = CoffeeGroup.fromJson(jsonMap);

      expect(coffeeGroup.id, '123');
      expect(coffeeGroup.name, 'Test Group');
      expect(coffeeGroup.members, {});
      expect(coffeeGroup.orderRuns, []);
    });

    test('determineNextPayerId() should return correct member ID', () {
      final members = {
        'member1': CoffeeGroupMember('Member 1', 10.0),
        'member2': CoffeeGroupMember('Member 2', 20.0),
        'member3': CoffeeGroupMember('Member 3', 5.0),
      };
      final coffeeGroup = CoffeeGroup('Test Group', members);
      final nextPayerId = coffeeGroup.determineNextPayerId();

      expect(nextPayerId, 'member2'); // Assuming 'member2' has the highest debt
    });
  });

  group('CoffeeGroupMember tests', () {
    test('toJson() should return a valid JSON map', () {
      final member = CoffeeGroupMember('Test Member', 10.0, 2);
      final jsonMap = member.toJson();

      expect(jsonMap, isMap);
      expect(jsonMap['name'], 'Test Member');
      expect(jsonMap['debt'], 10.0);
      expect(jsonMap['drinks'], 2);
    });

    test('fromJson() should create a valid CoffeeGroupMember object', () {
      final jsonMap = {
        'name': 'Test Member',
        'debt': 10.0,
        'drinks': 2,
      };
      final member = CoffeeGroupMember.fromJson(jsonMap);

      expect(member.name, 'Test Member');
      expect(member.debt, 10.0);
      expect(member.drinks, 2);
    });

    test('Equatable should compare objects correctly', () {
      final member1 = CoffeeGroupMember('Test Member', 10.0, 2);
      final member2 = CoffeeGroupMember('Test Member', 10.0, 2);
      final member3 = CoffeeGroupMember('Test Member', 5.0, 1);

      expect(member1, member2);
      expect(member1 == member3, false);
    });
  });
}
