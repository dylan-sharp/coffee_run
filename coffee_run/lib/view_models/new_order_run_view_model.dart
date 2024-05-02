import 'package:coffee_run/firestore_service.dart';
import 'package:coffee_run/pages/new_coffee_order.dart';
import 'package:flutter/widgets.dart';

import '../models/order.dart';


/// View model for the [NewCoffeeOrder] page.
class NewOrderViewModel extends ChangeNotifier {
  NewOrderViewModel(this.firestoreService);

  @override
  void dispose() {
    pageController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  // controller for our PageView
  final PageController pageController = PageController();

  // controller for our ListView
  final ScrollController scrollController = ScrollController();

  // Key for accessing our form state and validate method
  final formKey = GlobalKey<FormState>();

  final FirestoreService firestoreService;

  // Order items we are currently building
  List<OrderItem> orderItems = [];
  int get numItems => orderItems.length;

  // List synced with orderItems for showing validator errors with items that don't have member's assigned
  List<bool> memberIdValidations = [];

  // getter for calculating the current order's total cost
  double get totalOrderCost => orderItems.map((e) => e.cost).nonNulls.reduce((value, element) => value+=element);

  // for keeping track of who is paying for this order
  String? _memberPaying;
  String? get memberPaying => _memberPaying;
  set memberPaying(String? memberId) {
    _memberPaying = memberId;
    notifyListeners();
  }

  // Add a new blank order item and scroll to bottom of list view
  void addItem() {
    orderItems.add(OrderItem(null, null, null));
    memberIdValidations.add(true); // Setting this to true to not show validation text initially
    notifyListeners();

    // Scroll to bottom of List View
    if(orderItems.length > 2) {
      Future.delayed(const Duration(milliseconds: 5), () => scrollController.animateTo(scrollController.position.maxScrollExtent,
          duration: const Duration(seconds: 1), curve: Curves.fastOutSlowIn));
    }
  }

  // Remove an order item at a specific index in orderItems
  void removeItem(idx) {
    if (idx >= 0 && idx < orderItems.length) {
      debugPrint(idx.toString());
      orderItems.removeAt(idx);
      memberIdValidations.removeAt(idx);
      notifyListeners();
    }
  }

  // Take a previous order and populate this order with it.
  void populateFromPrevOrder(CoffeeOrder order) {
    orderItems = order.items;
    memberIdValidations = List.generate(order.items.length, (index) => true);
    notifyListeners();
  }


  // function for handling various order item related edits at a specific index
  void onOrderInputChanged(idx,
      {String? name, String? price, String? memberId}) {

    if (idx < 0 || idx >= orderItems.length) return;

    if (name != null && name.isNotEmpty) {
      orderItems[idx].name = name;
    }

    if (price != null && price.isNotEmpty) {
      var castedPrice = double.tryParse(price);
      if (castedPrice != null) {
        orderItems[idx].cost = castedPrice;
      }
    }

    if (memberId != null && memberId.isNotEmpty) {
      orderItems[idx].memberId = memberId;
      memberIdValidations[idx] = true;
    }

    notifyListeners();
  }

  // function for navigating to our review order page
  void reviewOrder() {
    var membersValid = _validateMemberIds();
    // form validation & memberId validation for non form avatar fields
    if(orderItems.isNotEmpty && (formKey.currentState?.validate() ?? false) && membersValid) {
      // Dismiss Keyboard if focused
      FocusManager.instance.primaryFocus?.unfocus();
      // Animate to the next view page
      pageController.animateToPage(1, duration: const Duration(milliseconds: 500), curve: Curves.fastOutSlowIn);
    }
  }

  // private function for validating that all our order items have members assigned
  bool _validateMemberIds() {
    var valid = true;

    orderItems.asMap().forEach((idx, item) {
      if (item.memberId == null) {
        valid = false;
        memberIdValidations[idx] = false;
      } else {
        memberIdValidations[idx] = true;
      }
    });
    notifyListeners();
    return valid;
  }

  // Animate back to edit order page
  void editOrder() {
    // Animate to the next view page
    pageController.animateToPage(0, duration: const Duration(milliseconds: 500), curve: Curves.fastOutSlowIn);
  }

  // Submit and save order using FirestoreService
  void submitOrder() {
    if(memberPaying==null) return;
    // create order
    var order = CoffeeOrder(memberPaying!, DateTime.now(), orderItems);
    firestoreService.saveOrder(order);
  }

}