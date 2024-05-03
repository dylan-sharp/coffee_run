import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

import 'order.dart';

part 'coffee_group.g.dart';

@JsonSerializable(explicitToJson: true)
class CoffeeGroup {
  CoffeeGroup(this.name, this.members, {this.orderRuns = const [], String? id})
      : id = id ?? const Uuid().v4();

  String id;
  String name;
  List<CoffeeOrder> orderRuns;
  Map<String, CoffeeGroupMember> members;

  factory CoffeeGroup.fromJson(Map<String, dynamic> json) =>
      _$CoffeeGroupFromJson(json);

  Map<String, dynamic> toJson() => _$CoffeeGroupToJson(this);

  // Determent the next member to pay by returning
  // the individual with the highest debt owed to the group
  String? determineNextPayerId() {
    // Sort coffee members by highest debt
    // Break ties by sorting id
    // Below is inefficient for only finding the next member
    // But this aligns with the member_search screen for now.
    var coffeeMembers = members.entries.toList();
    coffeeMembers.sort((a, b) {
      int debtCompare = b.value.debt.compareTo(a.value.debt);
      if (debtCompare != 0) return debtCompare;

      return b.key.compareTo(a.key);
    });

    if (coffeeMembers.isNotEmpty) {
      return coffeeMembers[0].key;
    }

    return null;
  }

  // helping function for returning a member's avatarId
  String? getMemberAvatarId(String memberId) {
    if (members.containsKey(memberId)) return members[memberId]?.avatarId;
    return null;
  }
}

@JsonSerializable()
class CoffeeGroupMember extends Equatable {
  const CoffeeGroupMember(this.name, this.avatarId,
      [this.debt = 0, this.drinks = 0]);

  final String name;
  final String avatarId;
  final double debt;
  final int drinks;

  factory CoffeeGroupMember.fromJson(Map<String, dynamic> json) =>
      _$CoffeeGroupMemberFromJson(json);

  Map<String, dynamic> toJson() => _$CoffeeGroupMemberToJson(this);

  @override
  List<Object?> get props => [name, debt, drinks, avatarId];
}
