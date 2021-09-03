import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:nyoba/pages/product/ProductDetailScreen.dart';
import 'package:nyoba/models/ProductModel.dart';
import 'package:nyoba/provider/WishlistProvider.dart';
import 'package:nyoba/utils/utility.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_screenutil/size_extension.dart';
import 'package:nyoba/widgets/webview/productWebview.dart';
import 'package:provider/provider.dart';

import '../../AppLocalizations.dart';

class ListItemWishlist extends StatelessWidget {
  final ProductModel product;
  final int i, itemCount;
  final Future<dynamic> Function() loadCartCount;

  ListItemWishlist({this.i, this.itemCount, this.product, this.loadCartCount});

  @override
  Widget build(BuildContext context) {
    var setWishlist = () async {
      final wishlist = Provider.of<WishlistProvider>(context, listen: false);

      wishlist.listWishlistProduct.removeAt(i);

      final Future<Map<String, dynamic>> setWishlist =
          wishlist.setWishlistProduct(context,productId: product.id.toString());

      setWishlist.then((value) {
        print("200");
      });
    };

    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>  productWebview(id: product.productSlug.toString(),)));
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(5)),
        width: MediaQuery.of(context).size.width / 3,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  width: 80.h,
                  height: 80.h,
                  child: Image.network(product.images[0].src),
                ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.productName,
                        style: TextStyle(fontSize: responsiveFont(12)),
                      ),
                      Visibility(
                        visible: product.discProduct != 0,
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: secondaryColor,
                              ),
                              padding: EdgeInsets.symmetric(
                                  vertical: 3, horizontal: 7),
                              child: Text(
                                "${product.discProduct.toInt()}%",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: responsiveFont(9)),
                              ),
                            ),
                            Container(
                              width: 5,
                            ),
                            Text(
                             product.productRegPrice,
                              style: TextStyle(
                                  fontSize: responsiveFont(8),
                                  color: HexColor("C4C4C4"),
                                  decoration: TextDecoration.lineThrough),
                            )
                          ],
                        ),
                      ),
                      Text(
                        product.productPrice,
                        style: TextStyle(
                            fontSize: responsiveFont(10),
                            fontWeight: FontWeight.w600,
                            color: secondaryColor),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: setWishlist,
                            child: Container(
                              width: 25.h,
                              height: 25.h,
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: secondaryColor,
                                ),
                              ),
                              child: Image.asset("images/account/trash.png"),
                            ),
                          ),

                        ],
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
