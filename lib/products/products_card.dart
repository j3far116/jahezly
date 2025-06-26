import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jahezly_5/provider/orders.dart';
import 'package:provider/provider.dart';
import '../models/markets_model.dart';
import '../models/products_model.dart';
import '../widgets/colors.dart';
import '../widgets/price.dart';
import 'product_detail.dart';

/*
|--------------------------------------------------------------------------
|
|
|
|
|
|
|
|
|
|
|
|
|
|
|
|
|
|
|
|
|
|
|  Product Card
|
|--------------------------------------------------------------------------
*/

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.marketInfo, required this.catName, required this.listProduct});

  final Markets marketInfo;
  final String? catName;
  final List listProduct;

  // ---------------------------------------------------------
  // Run Class
  // ---------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Consumer<OrderConfig>(
      builder: (context, provider, child) {
        return Column(
          children: [
            // ---------------------------------------------------------
            // View Tab Name
            // ---------------------------------------------------------
            (catName == null)
                ? const SizedBox(height: 15)
                : Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    catName!,
                    style: TextStyle(
                      fontSize: 20,
                      color: J3Colors('Orange').color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            // ---------------------------------------------------------
            // Build List Product
            // ---------------------------------------------------------
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: listProduct.length,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                // .. Product Info
                Products productInfo = Products.fromJson(listProduct[index]);
                // .. Start Build
                return Padding(
                  padding: const EdgeInsets.fromLTRB(10, 3, 10, 5),
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueGrey.withValues(alpha: 0.3),
                          blurRadius: 20, // soften the shadow
                          spreadRadius: -8, //extend the shadow
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    // ---------------------------------------------------------
                    // Build Product Info Into Sheet Page
                    // ---------------------------------------------------------
                    child: InkWell(
                      onTap: () {
                        // .. Init To Add New Order
                        provider.reset();
                        provider.setTotalProduct(productInfo.price!);
                        // .. Start Builder

                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          isDismissible: true,
                          useRootNavigator: true,
                          backgroundColor: Colors.white,
                          builder:
                              (context) => DraggableScrollableSheet(
                                initialChildSize: 0.90,
                                //minChildSize: 0.9,
                                maxChildSize: 0.9,
                                expand: false,

                                builder:
                                    (context, scrollController) => SafeArea(
                                      child: ProductDetail(scrollController, marketInfo, productInfo),
                                    ),
                              ),
                        );
                      },
                      // ---------------------------------------------------------
                      // Card Product
                      // ---------------------------------------------------------
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        elevation: 0,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Stack(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  height: 130,
                                  child: Container(
                                    padding: const EdgeInsets.fromLTRB(10, 12, 20, 10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          '${productInfo.name} #id: ${productInfo.id}',
                                          style: const TextStyle(fontSize: 18, fontFamily: 'jahezlyBold'),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 5),
                                          child: Text(
                                            '${marketInfo.disc}',
                                            style: TextStyle(fontSize: 13, color: Colors.grey[400]),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        const SizedBox(height: 5),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(height: 5),
                              ],
                            ),
                            Positioned(
                              right: 20,
                              bottom: 10,
                              child: J3Price(
                                productInfo.price!,
                                style: TextStyle(fontSize: 20, color: J3Colors('Orange').color),
                              ),
                            ),
                            Positioned(
                              left: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: CachedNetworkImage(
                                    height: 110,
                                    width: 110,
                                    fit: BoxFit.cover,
                                    imageUrl:
                                        'https://jahezly.net/admincp/upload/${productInfo.cover ?? 'noImage.jpg'}',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

/*
|--------------------------------------------------------------------------
| ***********************************************************************
|
|
|
|
|
|
|
|
|
|
|
|
|
|
|
|
|
|
|
|
|
|
| Bigen Class
|
|--------------------------------------------------------------------------
*/
class ControlProductDetailInBottom extends StatelessWidget {
  const ControlProductDetailInBottom(this.productInfo, this.onPress, {super.key});

  final Products productInfo;
  final Function onPress;

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderConfig>(
      builder: (context, provider, child) {
        return Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 5, right: 15, bottom: 0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.yellow[600],
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            if (provider.quantity > 1) {
                              provider.removeQuantity();
                              provider.setTotalProduct(productInfo.price!);
                            }
                          },
                          child: Container(
                            width: 50,
                            height: 45,
                            decoration: const BoxDecoration(
                              //color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                            child: const Center(child: Text('-', style: TextStyle(fontSize: 24))),
                          ),
                        ),
                        InkWell(
                          child: Container(
                            width: 50,
                            height: 45,
                            decoration: const BoxDecoration(
                              //color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text('${provider.quantity}', style: const TextStyle(fontSize: 20)),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            provider.addQuantity();
                            provider.setTotalProduct(productInfo.price!);
                          },
                          child: Container(
                            width: 50,
                            height: 45,
                            decoration: const BoxDecoration(
                              //color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                            child: const Center(child: Text('+', style: TextStyle(fontSize: 24))),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 5, bottom: 0),
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.yellow[600],
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: InkWell(
                        onTap: () => onPress(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [const Text('إضافة'), const Text(' '), J3Price(provider.totalProduct)],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
