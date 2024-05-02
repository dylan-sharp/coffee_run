import 'package:coffee_run/firestore_service.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

import '../models/coffee_group.dart';
import '../models/user_profile.dart';

/// Basic app wide view model for keeping track of
/// the current user and coffee group
class AppViewModel extends ChangeNotifier {

  UserProfile? activeUser;
  UserStatus userStatus = UserStatus.loading;
  CoffeeGroup? coffeeGroup;

  final FirestoreService _firestoreService;
  final CompositeSubscription _appSubscriptions = CompositeSubscription();

  AppViewModel(this._firestoreService) {
    _firestoreService.activeUserStream.listen((event) {
      activeUser = event.userProfile;
      userStatus = event.userStatus;
      notifyListeners();
    }).addTo(_appSubscriptions);

    _firestoreService.activeCoffeeGroup.listen((group) {
      coffeeGroup = group;
      notifyListeners();
    }).addTo(_appSubscriptions);
  }

  @override
  void dispose() {
    _appSubscriptions.dispose();
    super.dispose();
  }

}