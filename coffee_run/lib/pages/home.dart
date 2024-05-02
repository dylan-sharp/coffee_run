import 'package:coffee_run/view_models/app_view_model.dart';
import 'package:coffee_run/pages/menu.dart';
import 'package:coffee_run/pages/new_coffee_order.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:random_avatar/random_avatar.dart';

import '../theme.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Index for our current scaffold body page
  int currentPageIndex = 0;

  // callback for changing page via navigation bar
  void onDestinationSelected(int idx) {
    setState(() {
      currentPageIndex = idx;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: onDestinationSelected,
        selectedIndex: currentPageIndex,
        indicatorColor: Colors.brown,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.coffee_rounded),
              selectedIcon: Icon(
                Icons.coffee_rounded,
                color: Colors.white,
              ),
              label: ''),
          NavigationDestination(
              icon: Icon(Icons.menu_rounded),
              selectedIcon: Icon(
                Icons.menu_rounded,
                color: Colors.white,
              ),
              label: '')
        ],
      ),
      body: <Widget>[
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 215, 204, 200),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(56.0),
                      ),
                    ),
                    height: 256.0,
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 32.0),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 148, 119, 109),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(56.0),
                      ),
                    ),
                    height: 256.0,
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 16.0),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.brown,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(56.0),
                      ),
                    ),
                    height: 256.0,
                    width: double.infinity,
                    child: SafeArea(
                      child: Stack(
                        children: [
                          Align(
                              alignment: Alignment.bottomRight,
                              child: Image.asset(
                                'assets/coffee_beans.png',
                                alignment: Alignment.bottomRight,
                              )),
                          Padding(
                            padding: const EdgeInsets.only(left: 24.0, bottom: 24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Selector<AppViewModel, String?>(
                                    selector: (_, app) => app.activeUser?.name,
                                    builder: (context, name, _) {
                                      return Text(
                                        'Hello${name != null ? ',\n$name' : ''}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayLarge
                                            ?.copyWith(color: Colors.white, fontFamily: 'SnackBox'),
                                      );
                                    }),
                                const Spacer(),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(32.0),
                                          bottomRight: Radius.circular(8.0),
                                          topLeft: Radius.circular(8.0),
                                          topRight: Radius.circular(8.0),
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const NewCoffeeOrder(),
                                            fullscreenDialog: true),
                                      );
                                    },
                                    child: Text(
                                      'New Coffee Run',
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.brown),
                                    ))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Consumer<AppViewModel>(
                            builder: (context, app, child) {
                              var nextPayerId = app.coffeeGroup?.determineNextPayerId();
                              var nextPayer = app.coffeeGroup?.members[nextPayerId];

                              return Row(
                                children: [
                                  CircleAvatar(
                                    radius: 32,
                                    backgroundColor: Colors.brown,
                                    child: RandomAvatar(
                                      nextPayer?.avatarId ?? '',
                                      trBackground: true,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Next Coffee On',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall,
                                        ),
                                        Text(nextPayer?.name ?? '',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium)
                                      ],
                                    ),
                                  )
                                ],
                              );
                            }
                        ),
                      ),
                    ),
                  ),

                  // Dummy code for showing order cards on home screen horizontally
                  // Text(
                  //   'Recent Group Orders',
                  //   style: Theme.of(context).textTheme.titleMedium,
                  // ),
                  // Expanded(
                  //   child: ListView(
                  //     scrollDirection: Axis.horizontal,
                  //     children: [
                  //       OrderCard(),
                  //       OrderCard(),
                  //       OrderCard(),
                  //       OrderCard(),
                  //       OrderCard(),
                  //       OrderCard(),
                  //       OrderCard(),
                  //       OrderCard(),
                  //     ],
                  //   ),
                  // ),
                  const Spacer()
                ],
              ),
            )
          ],
        ),
        const Menu()
      ][currentPageIndex],
    );
  }
}


