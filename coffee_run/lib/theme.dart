import 'package:flutter/material.dart';

ThemeData lightTheme(BuildContext context) {
  return ThemeData.from(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown))
      .copyWith(
    textTheme: Theme.of(context).textTheme.apply(fontFamily: 'Roboto'),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      )
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      )
    ),
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        )
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
      fillColor: Color(0xFFEBEBEB),
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Colors.grey.shade100),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Colors.grey.shade100),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Colors.grey.shade100),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Colors.grey.shade100),
      ),
    ),
  );
}

AppBar buildAppBar(BuildContext context) {
  return AppBar(
    title: Text(
      '<Coffee Run>',
      style: Theme.of(context)
          .textTheme
          .headlineLarge
          ?.copyWith(fontFamily: 'SugarCream', color: Colors.white),
    ),
    backgroundColor: Colors.brown,
    iconTheme: const IconThemeData(color: Colors.white),
  );
}