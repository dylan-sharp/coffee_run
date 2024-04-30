import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

import 'order.dart';

part 'coffee_group.g.dart';

@JsonSerializable()
class CoffeeGroup {
  CoffeeGroup(this.name, this.members, {this.orderRuns = const [], String? id})
      : id = id ?? const Uuid().toString();

  String id;
  String name;
  List<OrderRun> orderRuns;
  Map<String, CoffeeGroupMember> members;

  factory CoffeeGroup.fromJson(Map<String, dynamic> json) =>
      _$CoffeeGroupFromJson(json);
  Map<String, dynamic> toJson() => _$CoffeeGroupToJson(this);

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

}

@JsonSerializable()
class CoffeeGroupMember extends Equatable {
  const CoffeeGroupMember(this.name, [this.debt = 0, this.drinks = 0]);

  final String name;
  final double debt;
  final int drinks;

  factory CoffeeGroupMember.fromJson(Map<String, dynamic> json) =>
      _$CoffeeGroupMemberFromJson(json);
  Map<String, dynamic> toJson() => _$CoffeeGroupMemberToJson(this);

  @override
  List<Object?> get props => [name, debt, drinks];
}