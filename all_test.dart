import '../tests/setup_test.dart' as SetupTest;
import '../tests/stream/withdraw_amount.test.dart' as StreamTest;
import '../tests/stream/emi_withdraw.test.dart' as EMITest;
import '../tests/stream/restricted_users.test.dart' as RestrictedUsersTest;
import '../tests/gold/buy_gold.test.dart' as BuyGoldTest;
import '../tests/gold/sell_gold.test.dart' as SellGoldTest;

void main() {
  SetupTest.main();
  //StreamTest.main();
  // EMITest.main();
  // RestrictedUsersTest.main();
  BuyGoldTest.main();
  //SellGoldTest.main();
}
