import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:task_manager/login.dart';
import 'package:task_manager/main.dart';

void main() {
  testWidgets('Firebase initialization', (tester)  async{
    await tester.pumpWidget(const MyApp());

    final FirebaseApp app = await Firebase.app();

    expect(app.name, '[DEFAULT]');
  });

  /*testWidgets('Navigates to LoginPage', (tester) async {
    await tester.pumpWidget(const MyApp());

    final loginPageFinder = find.byType(LoginPage);

    expect(loginPageFinder, findsOneWidget);
  });*/
}

/*
testWidgets('Firebase initialization', (tester) async {
await tester.pumpWidget(const MyApp());

final FirebaseApp app = await Firebase.app();

expect(app.name, '[DEFAULT]');
});

testWidgets('Navigates to LoginPage', (tester) async {
await tester.pumpWidget(const MyApp());

final loginPageFinder = find.byType(LoginPage);

expect(loginPageFinder, findsOneWidget);
});



testWidgets('Login functionality', (tester) async {
await tester.pumpWidget(const MyApp());

final loginPageFinder = find.byType(LoginPage);

final emailFieldFinder = find.byKey(const ValueKey('emailField'));
final passwordFieldFinder = find.byKey(const ValueKey('passwordField'));

await tester.enterText(emailFieldFinder, 'andygtz99@gmail.com');
await tester.enterText(passwordFieldFinder, '123456');

final loginButtonFinder = find.byKey(const ValueKey('loginButton'));
await tester.tap(loginButtonFinder);

await tester.pumpAndSettle();

..
});


testWidgets('Database access', (tester) async {
await tester.pumpWidget(const MyApp());

final database = FirebaseDatabase.instance;

final ref = database.ref('tasks');

final snapshot = await ref.once();

expect(snapshot.exists, true);

});*/
