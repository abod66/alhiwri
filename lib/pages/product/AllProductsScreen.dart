import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:nyoba/models/ProductModel.dart';
import 'package:nyoba/pages/order/CartScreen.dart';
import 'package:nyoba/pages/product/ProductDetailScreen.dart';
import 'package:nyoba/pages/search/SearchScreen.dart';
import 'package:nyoba/services/Session.dart';
import 'package:nyoba/widgets/contact/ContactFAB.dart';
import 'package:nyoba/utils/utility.dart';
import 'package:nyoba/widgets/webview/cartWebView.dart';
import 'package:nyoba/widgets/webview/productWebview.dart';

class AllProductsScreen extends StatefulWidget {
  final List<ProductModel> listProduct;
  AllProductsScreen({Key key, this.listProduct}) : super(key: key);

  @override
  _AllProductsScreenState createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> {
  int cartCount = 0;
  int page = 1;
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loadCartCount();
  }

  Future loadCartCount() async {
    print('Load Count');
    List<ProductModel> productCart = [];
    int _count = 0;

    if (Session.data.containsKey('cart')) {
      List listCart = await json.decode(Session.data.getString('cart'));

      productCart = listCart
          .map((product) => new ProductModel.fromJson(product))
          .toList();

      productCart.forEach((element) {
        _count += element.cartQuantity;
      });
    }
    setState(() {
      cartCount = _count;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget buildItems = Expanded(
      child: GridView.builder(
          controller: _scrollController,
          shrinkWrap: true,
          itemCount: widget.listProduct.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 1 / 2,
              crossAxisCount: 2,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15),
          itemBuilder: (context, i) {
            return itemGridList(
                widget.listProduct[i].productName,
                widget.listProduct[i].discProduct.toInt().toString(),
                widget.listProduct[i].productPrice+" BD",
                widget.listProduct[i].productRegPrice+" BD",
                i,
                widget.listProduct[i].productStock,
                widget.listProduct[i].images[0].src,
                widget.listProduct[i]);
          }),
    );

    return Scaffold(
      floatingActionButton: ContactFAB(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: Container(
          height: 38,
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SearchScreen()));
                  },
                  child: TextField(
                    style: TextStyle(fontSize: 14),
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      isDense: true,
                      isCollapsed: true,
                      enabled: false,
                      filled: true,
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(5),
                        ),
                      ),
                      prefixIcon: Icon(Icons.search),
                      hintText: "Search",
                      hintStyle: TextStyle(fontSize: responsiveFont(10)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

      ),
      body: Container(
          margin: EdgeInsets.all(10),
          child: Column(
            children: [
              buildItems,
            ],
          )),
    );
  }

  Widget itemGridList(
      String title,
      String discount,
      String price,
      String crossedPrice,
      int i,
      int stock,
      String image,
      ProductModel productDetail) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(5)),
      child: InkWell(
        onTap: (){
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>productWebview(id: productDetail.productSlug.toString(),)));
        },
        child: Card(
          elevation: 5,
          margin: EdgeInsets.only(bottom: 1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Image.network(image),
                ),
              ),
              Expanded(
                  flex: 2,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          flex: 2,
                          child: Text(
                            title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: responsiveFont(10)),
                          ),
                        ),
                        Container(
                          height: 5,
                        ),
                        Visibility(
                          visible: discount != "0",
                          child: Flexible(
                            flex: 1,
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
                                    '$discount%',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: responsiveFont(9)),
                                  ),
                                ),
                                Container(
                                  width: 5,
                                ),
                                Text(
                                  crossedPrice+" BD",
                                  style: TextStyle(
                                      fontSize: responsiveFont(8),
                                      color: HexColor("C4C4C4"),
                                      decoration: TextDecoration.lineThrough),
                                )
                              ],
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: FittedBox(
                            child: Text(
                             price+" BD",
                              style: TextStyle(
                                  fontSize: responsiveFont(10),
                                  color: Colors.green,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        Container(
                          height: 5,
                        ),
                        Text(
                          "Available : $stock In Stock",
                          style: TextStyle(fontSize: responsiveFont(8)),
                        )
                      ],
                    ),
                  )),

            ],
          ),
        ),
      ),
    );
  }

  Widget buildSearchEmpty() {
    return Center(
      child: ListView(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        children: [
          Image.asset("images/search/search_empty.png"),
          Container(
            alignment: Alignment.topCenter,
            child: Text(
              "Can't find the products",
              style: TextStyle(fontSize: 18),
            ),
          )
        ],
      ),
    );
  }
}
