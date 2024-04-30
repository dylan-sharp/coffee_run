// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderRun _$OrderRunFromJson(Map<String, dynamic> json) => OrderRun(
      json['payerId'] as String,
      DateTime.parse(json['orderTime'] as String),
      (json['items'] as List<dynamic>)
          .map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      id: json['id'] as String?,
    );

Map<String, dynamic> _$OrderRunToJson(OrderRun instance) => <String, dynamic>{
      'id': instance.id,
      'payerId': instance.payerId,
      'orderTime': instance.orderTime.toIso8601String(),
      'items': instance.items,
    };

OrderItem _$OrderItemFromJson(Map<String, dynamic> json) => OrderItem(
      json['name'] as String,
      (json['cost'] as num).toDouble(),
      json['memberId'] as String,
      id: json['id'] as String?,
    );

Map<String, dynamic> _$OrderItemToJson(OrderItem instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'cost': instance.cost,
      'memberId': instance.memberId,
    };
