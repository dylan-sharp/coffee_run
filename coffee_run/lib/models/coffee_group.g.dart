// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coffee_group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CoffeeGroup _$CoffeeGroupFromJson(Map<String, dynamic> json) => CoffeeGroup(
      json['name'] as String,
      (json['members'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry(k, CoffeeGroupMember.fromJson(e as Map<String, dynamic>)),
      ),
      orderRuns: (json['orderRuns'] as List<dynamic>?)
              ?.map((e) => CoffeeOrder.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      id: json['id'] as String?,
    );

Map<String, dynamic> _$CoffeeGroupToJson(CoffeeGroup instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'orderRuns': instance.orderRuns.map((e) => e.toJson()).toList(),
      'members': instance.members.map((k, e) => MapEntry(k, e.toJson())),
    };

CoffeeGroupMember _$CoffeeGroupMemberFromJson(Map<String, dynamic> json) =>
    CoffeeGroupMember(
      json['name'] as String,
      json['avatarId'] as String,
      (json['debt'] as num?)?.toDouble() ?? 0,
      (json['drinks'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$CoffeeGroupMemberToJson(CoffeeGroupMember instance) =>
    <String, dynamic>{
      'name': instance.name,
      'avatarId': instance.avatarId,
      'debt': instance.debt,
      'drinks': instance.drinks,
    };
