import 'package:coffee_run/firestore_service.dart';
import 'package:coffee_run/models/coffee_group.dart';
import 'package:coffee_run/pages/member_search.dart';
import 'package:coffee_run/pages/previous_orders.dart';
import 'package:coffee_run/view_models/new_order_run_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:random_avatar/random_avatar.dart';

import '../models/order.dart';
import '../theme.dart';
import '../view_models/app_view_model.dart';

/// text input filter for decimal numbers
final decimalFilteringTextInputFormatter =
    FilteringTextInputFormatter.allow(RegExp(r'^\d+(\.\d*)?'));

/// Page for inputting a new coffee order.  Corresponding view model is [NewOrderViewModel]
class NewCoffeeOrder extends StatelessWidget {
  const NewCoffeeOrder({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // dismiss keyboard
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: buildAppBar(context),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ChangeNotifierProvider(
              create: (context) =>
                  NewOrderViewModel(context.read<FirestoreService>()),
              builder: (context, child) {
                return PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: context.read<NewOrderViewModel>().pageController,
                  children: const [InputOrders(), ReviewOrder()],
                );
              }),
        ),
      ),
    );
  }
}

/// The input page responsible for editing and entering a new order
class InputOrders extends StatelessWidget {
  const InputOrders({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Form(
        key: context.read<NewOrderViewModel>().formKey,
        child: Column(
          children: [
            Expanded(
              child: Consumer<NewOrderViewModel>(
                builder: (BuildContext context, value, Widget? child) {
                  if (value.orderItems.isEmpty) {
                    return const InputOrderEmpty();
                  }

                  return Scrollbar(
                    controller: value.scrollController,
                    child: ListView.builder(
                        controller: value.scrollController,
                        shrinkWrap: true,
                        itemCount: value.orderItems.length,
                        itemBuilder: (context, idx) {
                          return OrderItemInput(
                              key: ValueKey<String>(value.orderItems[idx].id),
                              index: idx,
                              item: value.orderItems[idx]);
                        }),
                  );
                },
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: context.read<NewOrderViewModel>().addItem,
                      child: const Text('Add Item +'),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: context
                              .watch<NewOrderViewModel>()
                              .orderItems
                              .isNotEmpty
                          ? context.read<NewOrderViewModel>().reviewOrder
                          : null,
                      child: const Text('Review Order'),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

/// Widget to display in [InputOrder] when orderItems is empty
/// Allows copying from a previous order
class InputOrderEmpty extends StatelessWidget {
  const InputOrderEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 384,
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          shrinkWrap: true,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border:
                Border.all(color: Colors.brown, width: 1.0),
              ),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (pageContext) =>
                            PreviousOrders(
                              onTap: (order) {
                                context
                                    .read<NewOrderViewModel>()
                                    .populateFromPrevOrder(
                                    order);
                                Navigator.of(pageContext).pop();
                              },
                            ),
                        fullscreenDialog: true),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.coffee_rounded,
                        size: 56,
                        color: Colors.brown,
                      ),
                      Text(
                        'Start from previous order',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                            fontFamily: 'SnackBox',
                            color: Colors.brown),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border:
                Border.all(color: Colors.brown, width: 1.0),
              ),
              child: InkWell(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.camera_alt_rounded,
                        size: 56,
                        color: Colors.brown,
                      ),
                      Text(
                        'Parse from Receipt',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                            fontFamily: 'SnackBox',
                            color: Colors.brown),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        '<Coming Soon>',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(
                            fontFamily: 'SugarCream',
                            color: Colors.red),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border:
                Border.all(color: Colors.brown, width: 1.0),
              ),
              child: InkWell(
                onTap:
                context.read<NewOrderViewModel>().addItem,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.add_rounded,
                        size: 56,
                        color: Colors.brown,
                      ),
                      Text(
                        'Start from Scratch',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                            fontFamily: 'SnackBox',
                            color: Colors.brown),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The individual order item entry
/// Handles deleting, assigning member, and entering item name and price.
class OrderItemInput extends StatelessWidget {
  const OrderItemInput({super.key, required this.index, required this.item});

  final int index;
  final OrderItem item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (pageContext) => MemberSearch(
                        onTap: (memberId) {
                          context
                              .read<NewOrderViewModel>()
                              .onOrderInputChanged(index, memberId: memberId);
                          Navigator.of(pageContext).pop();
                        },
                      ),
                  fullscreenDialog: true),
            ),
            icon: Selector<NewOrderViewModel, ({String? memberId, bool valid})>(
                selector: (context, order) => (
                      memberId: order.orderItems[index].memberId,
                      valid: order.memberIdValidations[index]
                    ),
                builder: (context, data, child) {
                  return Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: data.memberId != null
                            ? Colors.brown
                            : Colors.grey.shade200,
                        child: data.memberId != null
                            ? RandomAvatar(
                                context
                                        .watch<AppViewModel>()
                                        .coffeeGroup
                                        ?.members[data.memberId]
                                        ?.avatarId ??
                                    '',
                                trBackground: true)
                            : const Text('?'),
                      ),
                      if (!data.valid)
                        Text(
                          'Enter\nBrewmate',
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(color: Colors.red.shade900),
                          textAlign: TextAlign.center,
                        )
                    ],
                  );
                }),
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            flex: 3,
            child: TextFormField(
              initialValue: item.name ?? '',
              onChanged: (val) => context
                  .read<NewOrderViewModel>()
                  .onOrderInputChanged(index, name: val),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Enter order item';
                }
                return null;
              },
              decoration: const InputDecoration(
                hintText: 'Order Item',
              ),
            ),
          ),
          const SizedBox(
            width: 4,
          ),
          Expanded(
            flex: 2,
            child: TextFormField(
              initialValue: item.cost?.toString() ?? '',
              onChanged: (val) => context
                  .read<NewOrderViewModel>()
                  .onOrderInputChanged(index, price: val),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.attach_money_rounded),
                hintText: 'Price',
              ),
              inputFormatters: [decimalFilteringTextInputFormatter],
              validator: (value) {
                if (value == null ||
                    value.isEmpty ||
                    double.tryParse(value) == null) {
                  return 'Enter Price';
                }
                return null;
              },
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded),
            onPressed: () =>
                context.read<NewOrderViewModel>().removeItem(index),
          ),
        ],
      ),
    );
  }
}

/// Review Order screen
/// Allows user to select payer and review total cost before saving order
class ReviewOrder extends StatelessWidget {
  const ReviewOrder({super.key});

  static const double textBoxWidth = 124;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  Text(
                    'Net Total:',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  SizedBox(
                    width: textBoxWidth,
                    child: TextFormField(
                      initialValue: context
                          .watch<NewOrderViewModel>()
                          .totalOrderCost
                          .toString(),
                      enabled: false,
                      style: const TextStyle(
                          color: Colors.black, fontStyle: FontStyle.italic),
                      decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.attach_money_rounded),
                          fillColor: Theme.of(context).colorScheme.background,
                          border: InputBorder.none),
                    ),
                  )
                ]),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  'Coming soon: Tax & Tip inputs',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontStyle: FontStyle.italic, color: Colors.brown),
                ),
                // Row(mainAxisSize: MainAxisSize.min, children: [
                //   Text(
                //     'Tax:',
                //     style: Theme.of(context).textTheme.titleLarge,
                //   ),
                //   SizedBox(
                //     width: 8,
                //   ),
                //   SizedBox(
                //     width: textBoxWidth,
                //     child: TextFormField(
                //       initialValue: '124',
                //       keyboardType:
                //           TextInputType.numberWithOptions(decimal: true),
                //       inputFormatters: [decimalFilteringTextInputFormatter],
                //       decoration: InputDecoration(
                //         prefixIcon: Icon(Icons.attach_money_rounded),
                //       ),
                //     ),
                //   )
                // ]),
                // SizedBox(
                //   height: 8,
                // ),
                // Row(mainAxisSize: MainAxisSize.min, children: [
                //   Text(
                //     'Tip:',
                //     style: Theme.of(context).textTheme.titleLarge,
                //   ),
                //   SizedBox(
                //     width: 8,
                //   ),
                //   SizedBox(
                //     width: textBoxWidth,
                //     child: TextFormField(
                //       initialValue: '124',
                //       keyboardType:
                //           TextInputType.numberWithOptions(decimal: true),
                //       inputFormatters: [decimalFilteringTextInputFormatter],
                //       decoration: InputDecoration(
                //         prefixIcon: Icon(Icons.attach_money_rounded),
                //       ),
                //     ),
                //   )
                // ]),
                const SizedBox(
                  width: textBoxWidth * 2,
                  child: Divider(),
                ),
                Row(mainAxisSize: MainAxisSize.min, children: [
                  Text(
                    'Gross Total',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  SizedBox(
                    width: textBoxWidth,
                    child: TextFormField(
                      initialValue: context
                          .watch<NewOrderViewModel>()
                          .totalOrderCost
                          .toString(),
                      enabled: false,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [decimalFilteringTextInputFormatter],
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontStyle: FontStyle.italic),
                      decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.attach_money_rounded),
                          fillColor: Theme.of(context).colorScheme.background,
                          border: InputBorder.none),
                    ),
                  ),
                ]),
                const SizedBox(
                  height: 32,
                ),
                SizedBox(
                  width: textBoxWidth * 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Who is paying?'),
                      Card(
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (pageContext) => MemberSearch(
                                  onTap: (memberId) {
                                    context
                                        .read<NewOrderViewModel>()
                                        .memberPaying = memberId;
                                    Navigator.of(pageContext).pop();
                                  },
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Consumer<NewOrderViewModel>(
                                builder: (context, order, child) {
                              CoffeeGroupMember? member = context
                                  .read<AppViewModel>()
                                  .coffeeGroup
                                  ?.members[order.memberPaying];

                              return Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: order.memberPaying != null
                                        ? Colors.brown
                                        : Colors.grey.shade400,
                                    child: order.memberPaying != null
                                        ? RandomAvatar(member?.avatarId ?? '',
                                            trBackground: true)
                                        : const Text('?'),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Expanded(child: Text(member?.name ?? '')),
                                  const Icon(Icons.arrow_forward_ios_rounded)
                                ],
                              );
                            }),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: context.read<NewOrderViewModel>().editOrder,
                    child: const Text('Back'),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: context.watch<NewOrderViewModel>().memberPaying != null ? () {
                      context.read<NewOrderViewModel>().submitOrder();
                      Navigator.of(context).pop();
                    } : null,
                    child: const Text('Submit'),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
