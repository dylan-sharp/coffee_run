import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'order.g.dart';

@JsonSerializable(explicitToJson: true)
class CoffeeOrder {
  CoffeeOrder(this.payerId, this.orderTime, this.items, {String? id})
      : id = id ?? const Uuid().v4();

  String id;
  String payerId;
  DateTime orderTime;
  List<OrderItem> items;

  factory CoffeeOrder.fromJson(Map<String, dynamic> json) => _$CoffeeOrderFromJson(json);
  Map<String, dynamic> toJson() => _$CoffeeOrderToJson(this);

  double get totalCost =>
      items.map((e) => e.cost ?? 0).reduce((value, element) => value+=element);
}

@JsonSerializable()
class OrderItem {
  OrderItem(this.name, this.cost, this.memberId, {String? id})
      : id = id ?? const Uuid().v4();

  String id;
  String? name;
  double? cost;
  String? memberId;

  factory OrderItem.fromJson(Map<String, dynamic> json) =>
      _$OrderItemFromJson(json);

  Map<String, dynamic> toJson() => _$OrderItemToJson(this);
}
