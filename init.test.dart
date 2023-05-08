import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jify_mobile/app.dart';
import 'package:jify_mobile/main.dart';
import 'package:patrol/patrol.dart';

import '../constants/timeouts_constant.dart';

Future<void> initApp() async {
  await main();
}

Future<void> pumpMainApp(
  PatrolTester tester,
) async {
  await tester.tester.pumpWidget(Phoenix(child: const MyApp()));
  await tester.tester.pumpAndSettle(
      const Duration(seconds: TimeOuts.DefaultTimeForPumpMainApp));
}
