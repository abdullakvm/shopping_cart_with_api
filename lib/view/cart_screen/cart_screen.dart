import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart_may/config/app_config.dart';
import 'package:shopping_cart_may/controller/cart_screen_controller.dart';
import 'package:shopping_cart_may/view/cart_screen/widgets/cart_item_widget.dart';

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
                          onPressed: () {},
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
}
