import 'package:coffee_run/view_models/app_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:random_avatar/random_avatar.dart';

import '../theme.dart';


/// Page that simply lists members in order of who should pay next
/// Has optional callback support for using as a member selector
class MemberSearch extends StatelessWidget {
  const MemberSearch({super.key, this.onTap});

  final Function(String)? onTap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Column(
        children: [
          // SizedBox(
          //   width: double.infinity,
          //   child: Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: TextField(
          //       decoration: InputDecoration(
          //         prefixIcon: Icon(Icons.search_rounded)
          //       ),
          //     ),
          //   ),
          // ),
          const SizedBox(height: 8,),
          Expanded(
            child: Consumer<AppViewModel>(builder: (context, app, child) {

              // Sort coffee members by highest debt
              // Break ties by sorting id
              var coffeeMembers =
                  app.coffeeGroup?.members.entries.toList() ?? [];
              coffeeMembers.sort((a,b) {
                int debtCompare = b.value.debt.compareTo(a.value.debt);
                if (debtCompare != 0) return debtCompare;

                return b.key.compareTo(a.key);
              });

              return Scrollbar(
                child: ListView.builder(
                    itemCount: coffeeMembers.length,
                    itemBuilder: (context, idx) {
                      return Card(
                        child: ListTile(
                          onTap: onTap != null ? () => onTap!(coffeeMembers[idx].key) : null,
                          leading: CircleAvatar(
                            backgroundColor: Colors.brown,
                            child: RandomAvatar(coffeeMembers[idx].value.avatarId, trBackground: true),
                          ),
                          title: Text(coffeeMembers[idx].value.name, style: Theme.of(context).textTheme.titleLarge,),
                          subtitle: Text('Debts: \$${coffeeMembers[idx].value.debt.toString()} | Drinks: ${coffeeMembers[idx].value.drinks}', style: Theme.of(context).textTheme.titleSmall),
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
