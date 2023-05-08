import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:jify_mobile/routes/router_pages.gr.dart';
import 'package:jify_mobile/utils/common_functions.dart';
import 'package:jify_mobile/utils/screen_extension.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

import '../../clients/data/credentials_client.dart';
import '../../constants/gold_flow_constant.dart';
import '../../constants/stream_request_constant.dart';
import '../../fixtures/init.test.dart';
import '../../screens/golds/buy_gold/buy_gold_screen.dart';
import '../../screens/golds/buy_gold/order_confirmation_screen.dart';
import '../../screens/golds/golds_home/save_with_gold_screen.dart';
import '../../screens/home/dashboard_screen.dart';
import '../../util/rupees_converter.util.dart';
import '../../workflows/onboarding_workflow.dart';

void main() {
  group('Buy Gold Test :', () {
    patrolTest(
      'Validate User able to buy gold with Positive Cases',
      nativeAutomation: true,
      nativeAutomatorConfig: const NativeAutomatorConfig(
        androidAppName: 'Jify-Dev',
        packageName: 'com.jify.mobile.development',
        bundleId: 'com.jify.mobile.development',
      ),
      (PatrolTester tester) async {
        await pumpMainApp(tester);

        final onboardingWorkflow = OnboardingWorkFlow(tester);
        final dashboardScreen = DashboardScreen(tester);
        final goldHomeScreen = GoldHomeScreen(tester);
        final buyGoldScreen = BuyGoldScreen(tester);
        final goldPurchaseDetailsScreen = GoldPurchaseDetailsScreen(tester);

        final credential =
            await CredentialsClient().getAllTestGroupKycUserCredential();
        final quickOptionRupee = GoldFlowData.quickOptionRupee[
            Random().nextInt(GoldFlowData.quickOptionRupee.length)];
        final quickOptionRupeeInNumber =
            num.parse(convertRupeeAmountToValue(quickOptionRupee));

        await onboardingWorkflow.login(credential);

        await dashboardScreen.navigateToSaveGoldScreen();
        expect(
          await goldHomeScreen.isUserOnGoldHomeScreen(),
          true,
          reason: 'Expect user should be on Gold Home Screen',
        );
        final currentValueOfGoldBeforBuying =
            await goldHomeScreen.getCurrentValueOfLocker();
        await goldHomeScreen.clickOnBuyGoldButton();
        expect(
          await buyGoldScreen.isUserOnBuyGoldScreen(),
          true,
          reason: 'Expect user should be on Buy Gold Screen',
        );

        // await buyGoldScreen.selectBuyGoldInGramRadioButton();

        await buyGoldScreen.selectQuickOption(quickOptionRupee);

        expect(
          await buyGoldScreen.getEnteredAmountValue(),
          convertRupeeAmountToValue(quickOptionRupee),
          reason:
              'Expected After selecting Quick Option, Amount should set to the enter amount field. Expected $quickOptionRupee.',
        );

        final contvertedUnitsInGram =
            await buyGoldScreen.getConvertedUnitInGrams();
        final calculatedgramsOfGoldFromRupee = await buyGoldScreen
            .calculateGramsOfGoldFromRupee(quickOptionRupeeInNumber);

        // expect(
        //   contvertedUnitsInGram,
        //   calculatedgramsOfGoldFromRupee,
        //   reason: 'Expected gms should be $calculatedgramsOfGoldFromRupee but found $contvertedUnitsInGram',
        // );

        await buyGoldScreen.clickOnContinueButton();
        expect(
          await goldPurchaseDetailsScreen.isUserGoldPurchaseDetailsScreen(),
          true,
          reason: 'Expected user should be on GoldPurchaseDetailsScreen',
        );
        final weightOfGold =
            await goldPurchaseDetailsScreen.getTotalPurchasedWeight();
        final gstAmount = await goldPurchaseDetailsScreen.getGstAmount();
        final totalPriceOfGold =
            await goldPurchaseDetailsScreen.getTotalGoldPurchasedPrice();
        final totalPayableAmount =
            await goldPurchaseDetailsScreen.getTotalPayableAmount();

        // expect(
        //   gstAmount,
        //   goldPurchaseDetailsScreen
        //       .calculateGstAmount(quickOptionRupeeInNumber),
        //   reason:
        //       'Expected gst amount should be on ${goldPurchaseDetailsScreen.calculateGstAmount(quickOptionRupeeInNumber)}, but found $gstAmount',
        // );
        // expect(
        //   totalPriceOfGold,
        //   goldPurchaseDetailsScreen
        //       .calculatePriceOfGold(quickOptionRupeeInNumber),
        //   reason:
        //       'Expected price of gold should be on ${goldPurchaseDetailsScreen.calculatePriceOfGold(quickOptionRupeeInNumber)}, but found $totalPriceOfGold',
        // );
        // expect(
        //   totalPayableAmount,
        //   quickOptionRupeeInNumber.toString(),
        //   reason:
        //       'Expected price of gold should be on ${quickOptionRupeeInNumber.toString()}, but found $totalPayableAmount',
        // );

        await goldPurchaseDetailsScreen.clickOnContinueButton();
        await tester.native.tap(Selector(text: 'UPI & more'));
        await tester.enterText(find.byType(EditableText), 'success@razorpay');
        await tester.native.tap(find.text('Pay Now'));
        //await $(#vpa%2upi).enterText('success@razorpay');
      },
      skip: false,
      timeout: const Timeout(Duration(minutes: 7)),
    );

    // patrolTest('payment test', ($) async {

    // });
  });
}
