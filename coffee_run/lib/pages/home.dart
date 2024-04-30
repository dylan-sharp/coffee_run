import 'package:coffee_run/models/coffee_group.dart';
import 'package:coffee_run/pages/app_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.brown,
          leading: const Icon(Icons.menu_rounded),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: CircleAvatar(
                child: Selector<AppViewModel, String>(
                  selector: (_, app) => app.activeUser?.name ?? '',
                  builder: (context, name, _) {
                    return Text(name.isNotEmpty ? name[0] : '?');
                  }
                ),
              ),
            )
          ],
        ),
        body: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                  color: Colors.brown,
                  borderRadius:
                      BorderRadius.only(bottomLeft: Radius.circular(56.0))),
              height: 256.0,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Selector<AppViewModel, String?>(
                  selector: (_, app) => app.activeUser?.name,
                  builder: (context, name, _) {
                    return Text(
                      'Good Morning${name != null ? ',\n  $name' : ''}',
                      style: Theme.of(context).textTheme.headlineLarge,
                    );
                  }
                ),
              ),
            ),
            Expanded(
              child: Selector<AppViewModel, List<CoffeeGroup>>(
                  selector: (_, app) => app.coffeeGroups ?? [],
                  builder: (context, groups, _) {
                    return ListView.builder(
                        itemCount: groups.length,
                        itemBuilder: (context, i) {
                          return ListTile(
                            tileColor: Colors.red,
                            title: Text(groups[i].name),
                          );
                        });
                  }),
            )
          ],
        ));
  }
}
