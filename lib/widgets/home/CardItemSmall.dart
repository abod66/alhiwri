import 'package:flutter/material.dart';
import 'package:nyoba/pages/product/ProductDetailScreen.dart';
import 'package:nyoba/models/ProductModel.dart';
import 'package:nyoba/utils/utility.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nyoba/widgets/webview/productWebview.dart';

class CardItem extends StatelessWidget {
  final ProductModel product;
  final int i, itemCount;

  CardItem({this.product, this.i, this.itemCount});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>   productWebview(id: product.productSlug.toString(),)));
      },
      child: Container(
        margin: EdgeInsets.only(
            left: i == 0 ? 15 : 0, right: i == itemCount - 1 ? 15 : 0),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(5)),
        width: MediaQuery.of(context).size.width / 3,
        height: double.infinity,
        child: Card(
          elevation: 5,
          margin: EdgeInsets.only(bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(5),
                      topLeft: Radius.circular(5)),
                  color: alternateColor,
                ),
                child: product.images != null
                    ? Image.network(
                        product.images[0].src,
                      height: 150,width: 150,fit: BoxFit.fill,)
                    : Image.asset("images/lobby/laptop.png"),
              ),
              Expanded(
                  flex: 3,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          flex: 3,
                          child: Text(
                            product.productName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: responsiveFont(10)),
                          ),
                        ),
                        Container(
                          height: 5,
                        ),
                        Visibility(
                          visible: product.discProduct != 0,
                          child: Flexible(
                            flex: 2,
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
                               product.productRegPrice+" BD"
                                      ,
                                  style: TextStyle(
                                      color: HexColor("C4C4C4"),
                                      decoration: TextDecoration.lineThrough,
                                      fontSize: responsiveFont(8)),
                                )
                              ],
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Container(
                            child: Text(

                                  product.productPrice+" BD",
                              style: TextStyle(
                                  fontSize: responsiveFont(10),
                                  color: secondaryColor,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        Container(
                          height: 5,
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
