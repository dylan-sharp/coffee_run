import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'order.g.dart';

@JsonSerializable()
class OrderRun {
  OrderRun(this.payerId, this.orderTime, this.items, {String? id})
      : id = id ?? const Uuid().toString();

  String id;
  String payerId;
  DateTime orderTime;
  List<OrderItem> items;

  factory OrderRun.fromJson(Map<String, dynamic> json) => _$OrderRunFromJson(json);
  Map<String, dynamic> toJson() => _$OrderRunToJson(this);

  double get totalCost =>
      items.map((e) => e.cost).reduce((value, element) => value+=element);
}

@JsonSerializable()
class OrderItem {
  OrderItem(this.name, this.cost, this.memberId, {String? id})
      : id = id ?? const Uuid().toString();

  String id;
  String name;
  double cost;
  String memberId;

  factory OrderItem.fromJson(Map<String, dynamic> json) =>
      _$OrderItemFromJson(json);

  Map<String, dynamic> toJson() => _$OrderItemToJson(this);
}
