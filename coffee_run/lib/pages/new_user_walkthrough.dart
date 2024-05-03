import 'dart:math';

import 'package:coffee_run/firestore_service.dart';
import 'package:coffee_run/models/user_profile.dart';
import 'package:coffee_run/view_models/app_view_model.dart';
import 'package:coffee_run/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:random_avatar/random_avatar.dart';

/// A wrapper around it's [child] which directs new users to onboarding flow
class NewUserWrapper extends StatelessWidget {
  const NewUserWrapper({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Selector<AppViewModel, UserStatus>(
      selector: (context, app) => app.userStatus,
      builder: (context, userStatus, consumerChild) {
        // While the userprofile is loading, display loading circle
        if (userStatus == UserStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // Direct new user to onboarding flow
        if (userStatus == UserStatus.newUser) {
          return const NewUserOnboarding();
        }

        return consumerChild!;
      },
      child: child,
    );
  }
}

/// A simple new user onboarding flow that handles
/// that collects the name and avatar of the new user
/// and creates the user document in firestore via our [FirestoreService]
// TODO - Abstract the state-fullness to a view model
class NewUserOnboarding extends StatefulWidget {
  const NewUserOnboarding({super.key});

  @override
  State<NewUserOnboarding> createState() => _NewUserOnboardingState();
}

class _NewUserOnboardingState extends State<NewUserOnboarding> {
  // Page controller for controlling the onboarding PageView
  final PageController pageController = PageController();

  // Text controller for accessing the name our user enters
  final TextEditingController nameController = TextEditingController();

  bool nextButtonEnabled = false;
  bool creatingUser = false;

  // A list of random strings for the [RandomAvatar] our user can select from
  List<String> avatarStrings =
      List.generate(4, (index) => generateRandomString(), growable: false);

  // Currently selected avatar index
  int selectedAvatar = -1;

  // Helper function for animation to certain pages
  void animateToPage(int page) {
    pageController.animateToPage(page,
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn);
  }

  // Regenerates new random avatar strings and resets our avatar selection
  void shuffleAvatarStrings() {
    setState(() {
      avatarStrings =
          List.generate(4, (index) => generateRandomString(), growable: false);
      selectedAvatar = -1;
    });
  }

  // select a specific avatar index
  void selectAvatar(int index) {
    setState(() {
      selectedAvatar = index;
    });
  }

  // Use our [FirestoreService] to write our new user to the database
  Future<void> createUser(BuildContext context) async {
    var userId = context.read<FirestoreService>().activeUserId;
    if (selectedAvatar == -1 || nameController.text.isEmpty || userId == null) {
      return;
    }

    // Set our button to a loading state
    setState(() {
      creatingUser = true;
    });

    var userProfile = UserProfile(
        userId, nameController.text, avatarStrings[selectedAvatar], []);

    await context.read<FirestoreService>().createUser(userProfile);

    if (mounted) {
      setState(() {
        creatingUser = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: PageView(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [buildNamePage(context), buildAvatarPage(context)],
      ),
    );
  }

  // Helper function to but the name entry page in our PageView
  Widget buildNamePage(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 32.0,
        ),
        Text(
          'Welcome',
          style: Theme.of(context)
              .textTheme
              .displayLarge
              ?.copyWith(fontFamily: 'SnackBox', color: Colors.brown),
        ),
        const SizedBox(
          height: 16,
        ),
        Text(
          'What is your name?',
          style: Theme.of(context)
              .textTheme
              .displaySmall
              ?.copyWith(fontFamily: 'SnackBox', color: Colors.brown),
        ),
        const SizedBox(
          height: 8,
        ),
        SizedBox(
          width: 256,
          child: TextField(
            controller: nameController,
            onChanged: (text) {
              setState(() {
                nextButtonEnabled = text.isNotEmpty;
              });
            },
            decoration: const InputDecoration(hintText: 'Enter your name'),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        SizedBox(
          width: 256,
          child: Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: nextButtonEnabled ? () => animateToPage(1) : null,
              child: const Text('Next'),
            ),
          ),
        )
      ],
    );
  }

  // Helper function to build our avatar selection page in our PageView
  Widget buildAvatarPage(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 32.0,
        ),
        Text(
          'Welcome',
          style: Theme.of(context)
              .textTheme
              .displayLarge
              ?.copyWith(fontFamily: 'SnackBox', color: Colors.brown),
        ),
        const SizedBox(
          height: 16,
        ),
        Text(
          'Choose your Avatar',
          style: Theme.of(context)
              .textTheme
              .displaySmall
              ?.copyWith(fontFamily: 'SnackBox', color: Colors.brown),
        ),
        const SizedBox(
          height: 8,
        ),
        OutlinedButton(
            onPressed: shuffleAvatarStrings, child: const Text('Shuffle')),
        const SizedBox(
          height: 8,
        ),
        SizedBox(
          width: 384,
          child: Column(
            children: [
              GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 2,
                shrinkWrap: true,
                children: List.generate(
                  4,
                  (index) => Container(
                    decoration: BoxDecoration(
                        color: selectedAvatar == index
                            ? Theme.of(context).colorScheme.surfaceTint
                            : null,
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: Colors.brown, width: 1.0)),
                    child: InkWell(
                      onTap: () => selectAvatar(index),
                      child: FittedBox(
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Center(
                            child: CircleAvatar(
                                backgroundColor: Colors.brown,
                                child: RandomAvatar(avatarStrings[index],
                                    trBackground: true)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: () => animateToPage(0),
                      child: const Text('Back')),
                  ElevatedButton(
                      onPressed: selectedAvatar != -1 && creatingUser == false
                          ? () => createUser(context)
                          : null,
                      child: creatingUser
                          ? const SizedBox(
                              height: 25,
                              width: 25,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),)
                          : const Text('Create Account'),)
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Generate a random string
String generateRandomString([int length = 20]) {
  const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
  final random = Random();
  return String.fromCharCodes(Iterable.generate(
      length, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
}
