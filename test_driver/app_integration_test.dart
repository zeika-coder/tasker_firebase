import 'package:task_manager/main.dart';
import 'package:task_manager/login.dart';
import 'package:flutter_driver/flutter_driver.dart';
void main() {
  print("hola");
  /*group('Login App Integration Test', () {
    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('Login with valid credentials', () async {
      await driver.tap(find.byValueKey('emailField'));
      await driver.enterText('test@example.com');
      await driver.tap(find.byValueKey('passwordField'));
      await driver.enterText('password123');

      await driver.tap(find.byValueKey('loginButton'));

      await driver.waitFor(find.text('Welcome')); // Cambia 'Welcome' por el texto correcto

      expect(await driver.getText(find.text('Welcome')), 'Welcome'); // Cambia 'Welcome' por el texto correcto
    });

  });*/
}