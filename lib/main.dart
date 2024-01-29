import 'package:flutter/material.dart';
import 'package:tracker_app/widget/expense.dart';

var colorScheme =
    ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 96, 59, 181));

var darkColorScheme = ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: const Color.fromARGB(255, 5, 99, 125));

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "T R A C K E R  A P P",
      darkTheme: ThemeData.dark().copyWith(
        useMaterial3: true,
        colorScheme: darkColorScheme,
        cardTheme: const CardTheme().copyWith(
          color: darkColorScheme.secondaryContainer,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: darkColorScheme.primaryContainer,
            foregroundColor: darkColorScheme.onPrimaryContainer,
          ),
        ),
        dropdownMenuTheme: DropdownMenuThemeData().copyWith(
          textStyle: TextStyle(
            color: darkColorScheme.onSecondaryContainer,
          ),
        ),
        textTheme: ThemeData().textTheme.copyWith(
              bodyLarge: TextStyle(
                color: darkColorScheme.onSecondaryContainer,
              ),
              bodyMedium: TextStyle(
                color: darkColorScheme.onSecondaryContainer,
              ),
              bodySmall: TextStyle(
                color: darkColorScheme.onSecondaryContainer,
              ),
              titleLarge: TextStyle(
                color: darkColorScheme.onSecondaryContainer,
                fontWeight: FontWeight.w900,
                fontSize: 17,
              ),
              titleSmall: TextStyle(
                color: darkColorScheme.onSecondaryContainer,
                fontWeight: FontWeight.w300,
                fontSize: 12,
              ),
            ),
      ),
      theme: ThemeData().copyWith(
        useMaterial3: true,
        colorScheme: colorScheme,
        appBarTheme: const AppBarTheme().copyWith(
          backgroundColor: colorScheme.onPrimaryContainer,
          foregroundColor: colorScheme.primaryContainer,
        ),
        cardTheme: const CardTheme().copyWith(
          color: colorScheme.secondaryContainer,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primaryContainer,
          ),
        ),
        textTheme: ThemeData().textTheme.copyWith(
            bodyLarge: TextStyle(
              color: colorScheme.onSecondaryContainer,
            ),
            titleLarge: TextStyle(
              fontSize: 17,
              color: colorScheme.onSecondaryContainer,
              fontWeight: FontWeight.w900,
            ),
            titleSmall: TextStyle(
              fontSize: 12,
              color: colorScheme.onSecondaryContainer,
              fontWeight: FontWeight.w300,
            ),
            ),
      ),
      home: const Expense(),
    ),
  );
}
