import 'package:coffee_run/view_models/app_view_model.dart';
import 'package:coffee_run/pages/member_search.dart';
import 'package:coffee_run/pages/previous_orders.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:random_avatar/random_avatar.dart';

// Builds a list of items to display in our menu screen
List<ListTile> buildMenuItems(context) => <ListTile>[
      ListTile(
        leading: const Icon(
          Icons.account_circle_rounded,
          size: 42,
          color: Colors.brown,
        ),
        title: const Text('Account - Coming soon!'),
        subtitle: const Text('Edit your account'),
        trailing: const Icon(Icons.arrow_forward_ios_rounded),
        onTap: () {},
      ),
      ListTile(
        leading: const Icon(
          Icons.people,
          size: 42,
          color: Colors.brown,
        ),
        title: const Text('Brewmates'),
        trailing: const Icon(Icons.arrow_forward_ios_rounded),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => MemberSearch(), fullscreenDialog: true));
        },
      ),
      ListTile(
        leading: const Icon(
          Icons.list_rounded,
          size: 42,
          color: Colors.brown,
        ),
        title: const Text('Previous Orders'),
        trailing: const Icon(Icons.arrow_forward_ios_rounded),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => PreviousOrders(), fullscreenDialog: true));
        },
      ),
    ];

/// Our menu screen that displays the current user's profile
/// and other lists / actions
class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Center(
              child: Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 16, left: 16),
                    child: const CircleAvatar(
                      backgroundColor: Color.fromARGB(255, 215, 204, 200),
                      radius: 96,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 8, left: 8),
                    child: const CircleAvatar(
                      backgroundColor: Color.fromARGB(255, 148, 119, 109),
                      radius: 96,
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.brown,
                    radius: 96,
                    child: RandomAvatar(
                        context.watch<AppViewModel>().activeUser?.avatarId ??
                            '',
                        trBackground: true),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: buildMenuItems(context)
                  .map(
                    (e) => Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 4.0),
                      child: Card(child: e),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
