import 'package:coffee_run/firestore_service.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

import '../models/coffee_group.dart';
import '../models/user_profile.dart';

class AppViewModel extends ChangeNotifier {

  UserProfile? activeUser;
  List<CoffeeGroup>? coffeeGroups;


  final FirestoreService _firestoreService;
  final CompositeSubscription _appSubscriptions = CompositeSubscription();

  AppViewModel(this._firestoreService) {
    _firestoreService.activeUserStream.listen((user) {
      activeUser = user;
      notifyListeners();
    }).addTo(_appSubscriptions);

    _firestoreService.activeCoffeeGroupsStream.listen((groups) {
      coffeeGroups = groups;
      notifyListeners();
    }).addTo(_appSubscriptions);
  }

  @override
  void dispose() {
    _appSubscriptions.dispose();
    super.dispose();
  }

}