import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_web/razorpay_web.dart';
import 'package:shopping_cart_may/config/app_config.dart';
import 'package:shopping_cart_may/controller/cart_screen_controller.dart';
import 'package:shopping_cart_may/view/cart_screen/widgets/cart_item_widget.dart';
import 'package:shopping_cart_may/view/home_screen/home_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        await context.read<CartScreenController>().getData();
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cartScreenController = context.watch<CartScreenController>();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("My Cart"),
        ),
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                      itemBuilder: (context, index) {
                        return CartItemWidget(
                          title: cartScreenController.cartItems[index]
                              [AppConfig.itemTitle],
                          price: cartScreenController.cartItems[index]
                                  [AppConfig.itemPrice]
                              .toString(),
                          qty: cartScreenController.cartItems[index]
                                  [AppConfig.itemQty]
                              .toString(),
                          image: cartScreenController.cartItems[index]
                                  [AppConfig.productImage] ??
                              "",
                          onIncrement: () {
                            int quantity = cartScreenController.cartItems[index]
                                [AppConfig.itemQty];
                            int id = cartScreenController.cartItems[index]
                                [AppConfig.primaryKey];
                            quantity++;
                            context
                                .read<CartScreenController>()
                                .updateData(quantity: quantity, id: id);
                          },
                          onDecrement: () {
                            int quantity = cartScreenController.cartItems[index]
                                [AppConfig.itemQty];
                            int id = cartScreenController.cartItems[index]
                                [AppConfig.primaryKey];
                            if (quantity > 1) {
                              quantity--;
                              context
                                  .read<CartScreenController>()
                                  .updateData(quantity: quantity, id: id);
                            }
                          },
                          onRemove: () {
                            context.read<CartScreenController>().deleteData(
                                id: cartScreenController.cartItems[index]
                                    [AppConfig.primaryKey]);
                          },
                        );
                      },
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 15),
                      itemCount: cartScreenController.cartItems.length),
                ),
                Container(
                  margin: EdgeInsets.all(15),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(4, 6),
                            color: Colors.grey,
                            blurRadius: 15),
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Total Price",
                              style: TextStyle(
                                  color: Colors.black.withValues(alpha: .5),
                                  fontWeight: FontWeight.bold)),
                          Text(
                            cartScreenController.totalAmount.toStringAsFixed(2),
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 25),
                          )
                        ],
                      ),
                      IconButton(
                          onPressed: () {
                            Razorpay razorpay = Razorpay();
                            var options = {
                              'key':
                                  'rzp_test_1DP5mmOlF5G5ag', // Your Razorpay test key
                              'amount': cartScreenController.totalAmount *
                                  100, // Amount in paise (e.g., 50000 = ₹500)
                              'name': 'Acme Corp.',
                              'description': 'Fine T-Shirt',
                              'send_sms_hash': true,
                              'timeout': 300, //time out in 5 minutes
                              'prefill': {
                                'contact': '8888888888',
                                'email': 'test@razorpay.com',
                              },
                              'external': {
                                'wallets': ['paytm']
                              },
                              'theme': {
                                'color': '#000000',
                                // 'backdrop_color':
                                //     '#ffffff' // Optional: background color
                              },
                            };
                            razorpay.on(RazorpayEvents.EVENT_PAYMENT_SUCCESS,
                                _handlePaymentSuccess);
                            razorpay.on(RazorpayEvents.EVENT_PAYMENT_ERROR,
                                _handlePaymentError);
                            razorpay.on(RazorpayEvents.EVENT_EXTERNAL_WALLET,
                                _handleExternalWallet);
                            razorpay.open(options);
                          },
                          icon: Icon(
                            Icons.double_arrow_sharp,
                            color: Colors.black,
                            size: 40,
                          ))
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }

  void _handlePaymentSuccess(
      BuildContext context, PaymentSuccessResponse response) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
      (Route<dynamic> route) => false,
    );
    context.read<CartScreenController>().deleteAlldata;
    print('Success Response: $response');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Payment Successful 🎉'),
        content: Text('Payment ID: ${response.paymentId!}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _handlePaymentError(
      BuildContext context, PaymentFailureResponse response) {
    print('Error Response: $response');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Payment Failed ❌'),
        content: Text('Error ${response.code}: ${response.message!}'),
        backgroundColor: Colors.red[50],
        titleTextStyle: const TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  void _handleExternalWallet(
      BuildContext context, ExternalWalletResponse response) {
    print('External SDK Response: $response');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('External Wallet Selected 💰'),
        content: Text('Wallet Name: ${response.walletName!}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
