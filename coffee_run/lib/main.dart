import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_run/firestore_service.dart';
import 'package:coffee_run/view_models/app_view_model.dart';
import 'package:coffee_run/pages/home.dart';
import 'package:coffee_run/pages/new_user_walkthrough.dart';
import 'package:coffee_run/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // initialize firebase app with current platform's app configuration
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Enable firebase emulators in debug mode
  if (kDebugMode) {
    try {
      FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
      await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  // Startup our FirestoreService
  final firebaseAuth = FirebaseAuth.instance;
  await firebaseAuth.signInAnonymously();
  final firestoreService = FirestoreService(FirebaseFirestore.instance, firebaseAuth);

  // Disable orientation rotation
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(
    MultiProvider(
      providers: [
        Provider.value(value: firestoreService),
        ChangeNotifierProvider(create: (_) => AppViewModel(firestoreService))
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightTheme(context),
      debugShowCheckedModeBanner: false,
      home: const NewUserWrapper(child: Home()),
    );
  }
}
