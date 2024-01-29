import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

final formatter = DateFormat.yMd();

const uuid = Uuid();

enum Categories { food, travel, leisure, work }

const categoryIcons = {
  Categories.food: Icons.lunch_dining,
  Categories.travel: Icons.flight_takeoff,
  Categories.leisure: Icons.movie,
  Categories.work: Icons.work,
};

class Expenses {
  Expenses({
    required this.date,
    required this.title,
    required this.amount,
    required this.category,
  }) : id = uuid.v4();

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Categories category;

  String get formattedDate {
    return formatter.format(date);
  }

  // Convert Expenses object to a Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(), // Convert DateTime to a string
      'category':
          category.toString().split('.').last, // Store category as a string
    };
  }

  @override
  String toString() {
    return 'Expenses{id: $id, title: $title, amount: $amount, date: $date, category: $category}';
  }

  factory Expenses.fromJson(Map<String, dynamic> map) {
    if (map.containsKey('date') &&
        map.containsKey('title') &&
        map.containsKey('amount') &&
        map.containsKey('category')) {
      return Expenses(
        date: DateTime.parse(map['date']),
        title: map['title'],
        amount: (map['amount'] as num)
            .toDouble(), // Ensure the type is converted to double
            
        category: Expenses.convertToCategories(map['category']),
      );
    } else {
      // Handle the case where one or more expected keys are missing
      throw FormatException('Invalid map structure for Expenses.fromMap');
    }
  }

  // Save Expenses object to shared preferences
  // In the saveToLocal

  static Future<void> saveToLocal(List<Expenses> expenses) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(expenses);
    try {
      await prefs.setString('expenses', jsonString);
      // print(jsonString);
    } catch (e) {
      print('Error saving expense from local storage: $e');
      // Handle the error accordingly
    }
  }

  // static Future<void> removeToLocal(Expenses expense) async {
  //   try {
  //     final SharedPreferences prefs = await SharedPreferences.getInstance();
  //     List<String>? expenseList = prefs.getStringList('expenses');

  //     if (expenseList == null) return;

  //     // Decode the JSON strings to Expenses objects
  //     final expenses =
  //         expenseList.map((e) => Expenses.fromJson(json.decode(e))).toList();

  //     // Remove the expense from the list
  //     expenses.removeWhere((e) => e.id == expense.id);

  //     // Encode the Expenses objects back to JSON strings
  //     expenseList = expenses.map((e) => json.encode(e.toJson())).toList();

  //     // Save the updated list to shared preferences
  //     await prefs.setStringList('expenses', expenseList);

  //     print("Updated expenseList: $expenseList");
  //   } catch (e) {
  //     print('Error removing expense from local storage: $e');
  //     // Handle the error accordingly
  //   }
  // }

  static Future<List<Expenses>> getLocalExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('expenses');
    try {
      
      if (jsonString == null) return [];
      final expensesList = jsonDecode(jsonString) as List<dynamic>;
      // print(expensesList);
      return expensesList.map((expense) => Expenses.fromJson(expense)).toList();
    } catch (e) {
      print('Error retrieving expenses from local storage: $e');

      return [];
    }
  }
// // In the getLocalExpenses method
//   static Future<List<Expenses>> getLocalExpenses() async {
//     try {
//       final SharedPreferences prefs = await SharedPreferences.getInstance();

//       // Read the list of strings from shared preferences
//       final List<String> encodedList = prefs.getStringList('expenses') ?? [];

//       // Convert List<String> to List<Expenses>
//       final List<Expenses> expensesList =
//           encodedList.map((e) => Expenses.fromMap(json.decode(e))).toList();

//       return expensesList;
//     } catch (e) {
//       print('Error retrieving expenses from local storage: $e');
//       // Handle the error accordingly
//       return [];
//     }
//   }

  // Helper function to convert a String to Categories enum
  static Categories convertToCategories(String categoryString) {
    switch (categoryString) {
      case 'food':
        return Categories.food;
      case 'travel':
        return Categories.travel;
      case 'leisure':
        return Categories.leisure;
      case 'work':
        return Categories.work;
      default:
        // Handle the case where the string doesn't match any enum value
        // You could throw an exception, return a default value, or handle it in another way.
        return Categories.leisure;
    }
  }
}

class ExpenseBucket {
  
 ExpenseBucket({
    required this.categories,
    required this.expenses,
  });


  
  ExpenseBucket.forCategory(List<Expenses> allExpense, this.categories)
      : expenses = allExpense
            .where((expense) => expense.category == categories)
            .toList();

  final Categories categories;
  final List<Expenses> expenses;
  

 double get totalExpenses {
    double sum = 0;
    for (final expense in expenses) {
      sum += expense.amount;
    }
    return sum;
    
  }

  
}

