import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:task_manager/main.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:task_manager/login.dart';
import 'package:task_manager/main.dart';
import 'package:task_manager/firebase_options.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  testWidgets('Flutter Secure Storage Test', (WidgetTester tester) async {
    WidgetsFlutterBinding.ensureInitialized();

    final storage = FlutterSecureStorage();
    await storage.write(key: 'pass', value: '123456');

    String? storedValue = await storage.read(key: 'pass');

    expect(storedValue, '123456');
  });
 /* testWidgets('Navigates to LoginPage', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    final loginPageFinder = find.byType(LoginPage);
    expect(loginPageFinder, findsOneWidget);
  });

  testWidgets('Login functionality', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    final loginPageFinder = find.byType(LoginPage);
    final emailFieldFinder = find.byKey(const ValueKey('emailField'));
    final passwordFieldFinder = find.byKey(const ValueKey('passwordField'));
    await tester.enterText(emailFieldFinder, 'andygtz99@gmail.com');
    await tester.enterText(passwordFieldFinder, '123456');

    final loginButtonFinder = find.byKey(const ValueKey('loginButton'));
    await tester.tap(loginButtonFinder);
    await tester.pumpAndSettle();
  });

  testWidgets('Database access', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    DatabaseReference ref = FirebaseDatabase.instance.ref();
    DatabaseReference tasksRef = ref.child('tasks');
    tasksRef.onValue.listen((DatabaseEvent event) {
      try {
        final data = event.snapshot.value;
        expect(data, isNotNull);
        expect(data, isNotEmpty);
      } catch (e) {
        print('Error in database access test: $e');
      }
    });
  });*/

}
