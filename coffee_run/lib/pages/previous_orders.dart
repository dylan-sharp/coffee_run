import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:random_avatar/random_avatar.dart';

import '../models/order.dart';
import '../theme.dart';
import '../view_models/app_view_model.dart';

/// Page for showing a list of previous order
/// has an optional callback for using this page as a selector
class PreviousOrders extends StatelessWidget {
  const PreviousOrders({super.key, this.onTap});

  final Function(CoffeeOrder)? onTap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Column(
        children: [
          const SizedBox(
            height: 8,
          ),
          Expanded(
            child: Consumer<AppViewModel>(builder: (context, app, child) {
              var orders = app.coffeeGroup?.orderRuns ?? [];
              orders.sort((a, b) => b.orderTime.compareTo(a.orderTime));
              var avatars = orders
                  .map((e) => e.items
                      .map((e) => e.memberId)
                      .nonNulls
                      .map((e) => app.coffeeGroup?.getMemberAvatarId(e))
                      .nonNulls
                      .toList())
                  .toList();

              return Scrollbar(
                child: ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (context, idx) {
                      return Card(
                        child: ListTile(
                          onTap: onTap != null
                              ? () => onTap!(orders[idx])
                              : null,
                          leading: const Icon(Icons.coffee_rounded),
                          title: Text(
                            DateFormat.yMd().format(orders[idx].orderTime),
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          trailing: Text(
                            '\$${orders[idx].totalCost.toString()}',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          subtitle: Row(
                            children: avatars[idx].take(5)
                                .map((e) => CircleAvatar(backgroundColor: Colors.brown, child: RandomAvatar(e, trBackground: true)))
                                .toList(),
                          ),
                        ),
                      );
                    }),
              );
            }),
          ),
        ],
      ),
    );
  }
}
