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
    String? nextMemberId;
    double highestDebt = double.negativeInfinity;

    members.forEach((key, value) {
      if (value.debt > highestDebt) {
        nextMemberId = key;
        highestDebt = value.debt;
      }
    });

    return nextMemberId;
  }

  // helping function for returning a member's avatarId
  String? getMemberAvatarId(String memberId) {
    if(members.containsKey(memberId)) return members[memberId]?.avatarId;
    return null;
  }

}

@JsonSerializable()
class CoffeeGroupMember extends Equatable {
  const CoffeeGroupMember(this.name, this.avatarId, [this.debt = 0, this.drinks = 0]);

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