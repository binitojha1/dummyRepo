import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:patrol/patrol.dart';

import '../fixtures/init.test.dart';

void main() {
  // final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  // binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  group('Setup :', () {
    patrolTest(
      'Init App',
      nativeAutomation: true,
      nativeAutomatorConfig: const NativeAutomatorConfig(
        androidAppName: 'Jify-Dev',
        packageName: 'com.jify.mobile.development',
        bundleId: 'com.jify.mobile.development',
      ),
      (PatrolTester tester) async {
        await initApp();
      },
      skip: false,
      timeout: const Timeout(Duration(minutes: 5)),
    );
  });
}
