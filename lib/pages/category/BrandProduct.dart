import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:nyoba/models/ProductModel.dart';
import 'package:nyoba/pages/order/CartScreen.dart';
import 'package:nyoba/pages/product/ProductDetailScreen.dart';
import 'package:nyoba/provider/ProductProvider.dart';
import 'package:nyoba/services/Session.dart';

import 'package:nyoba/utils/utility.dart';
import 'package:nyoba/widgets/product/GridItemShimmer.dart';
import 'package:nyoba/widgets/webview/productWebview.dart';
import 'package:provider/provider.dart';

import '../../AppLocalizations.dart';

class BrandProducts extends StatefulWidget {
  final String categoryId;
  final String brandName;
  BrandProducts({Key key, this.categoryId, this.brandName}) : super(key: key);

  @override
  _BrandProductsState createState() => _BrandProductsState();
}

class _BrandProductsState extends State<BrandProducts> {
  int currentIndex = 0;

  int page = 1;
  String order = 'desc';
  String orderBy = 'popularity';
  int cartCount = 0;

  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    final product = Provider.of<ProductProvider>(context, listen: false);
    super.initState();
    loadProductByBrand();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (product.listBrandProduct.length % 8 == 0) {
          setState(() {
            page++;
          });
          loadProductByBrand();
        }
      }
    });
  }

  loadProductByBrand() async {
    await Provider.of<ProductProvider>(context, listen: false)
        .fetchBrandProduct(
            page: page,
            order: order,
            category: widget.categoryId.toString(),
            orderBy: orderBy);
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
    final product = Provider.of<ProductProvider>(context, listen: false);
    Widget buildItems = ListenableProvider.value(
      value: product,
      child: Consumer<ProductProvider>(builder: (context, value, child) {
        if (value.loadingBrand && page == 1) {
          return Expanded(
            child: GridView.builder(
                shrinkWrap: true,
                itemCount: 6,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 1 / 2,
                    crossAxisCount: 2,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 15),
                itemBuilder: (context, i) {
                  return GridItemShimmer();
                }),
          );
        }
        if (value.listBrandProduct.isEmpty) {
          return buildSearchEmpty();
        }
        return Expanded(
          child: GridView.builder(
              controller: _scrollController,
              shrinkWrap: true,
              itemCount: value.listBrandProduct.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 1 / 2,
                  crossAxisCount: 2,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15),
              itemBuilder: (context, i) {
                return itemGridList(
                    value.listBrandProduct[i].productName,
                    value.listBrandProduct[i].discProduct.toInt().toString(),
                    value.listBrandProduct[i].productPrice,
                    value.listBrandProduct[i].productRegPrice,
                    i,
                    value.listBrandProduct[i].productStock,
                    value.listBrandProduct[i].images[0].src,
                    value.listBrandProduct[i]);
              }),
        );
      }),
    );

    return DefaultTabController(
      length: 4,
      child: Scaffold(
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(convertHtmlUnescape(
                    widget.brandName),
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: responsiveFont(16),
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),

        ),
        body: Container(
          margin: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 15,
              ),
              Text(AppLocalizations.of(context)
                  .translate('sort'),
                  style: TextStyle(
                      fontSize: responsiveFont(12),
                      fontWeight: FontWeight.w500)),
              Container(
                margin: EdgeInsets.symmetric(vertical: 15),
                child: TabBar(
                  labelPadding: EdgeInsets.symmetric(horizontal: 5),
                  onTap: (i) {
                    setState(() {
                      currentIndex = i;
                      page = 1;
                    });
                    if (i == 0) {
                      setState(() {
                        order = 'desc';
                        orderBy = 'popularity';
                      });
                    } else if (i == 1) {
                      setState(() {
                        order = 'desc';
                        orderBy = 'date';
                      });
                    } else if (i == 2) {
                      setState(() {
                        order = 'desc';
                        orderBy = 'price';
                      });
                    } else if (i == 3) {
                      setState(() {
                        order = 'asc';
                        orderBy = 'price';
                      });
                    }
                    loadProductByBrand();
                  },
                  isScrollable: true,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: primaryColor,
                  ),
                  tabs: [
                    tabStyle(0, AppLocalizations.of(context)
                        .translate('popularity')),
                    tabStyle(1, AppLocalizations.of(context)
                        .translate('latest')),
                    tabStyle(2, AppLocalizations.of(context)
                        .translate('highest_price')),
                    tabStyle(3, AppLocalizations.of(context)
                        .translate('lowest_price')),
                  ],
                ),
              ),
              buildItems,
              if (product.loadingBrand && page != 1) customLoading()
            ],
          ),
        ),
      ),
    );
  }

  Widget tabStyle(int index, String total) {
    return Container(
      decoration: BoxDecoration(
          color: currentIndex == index ? Colors.transparent : Colors.white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
              color: currentIndex == index
                  ? Colors.transparent
                  : HexColor("c4c4c4"))),
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(total,
              style: TextStyle(
                  fontSize: responsiveFont(10),
                  color: currentIndex == index
                      ? Colors.white
                      : HexColor("c4c4c4")))
        ],
      ),
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
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => productWebview(id: productDetail.productSlug.toString(),)));
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
                  child: Image.network(image ,width: 200,height: 200,fit: BoxFit.fill,),
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
                            maxLines: 1,
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
                                        color: Colors.black,
                                        fontSize: responsiveFont(9)),
                                  ),
                                ),
                                Container(
                                  width: 5,
                                ),
                                Text(
                                  crossedPrice+ "BD",
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
                              price +" BD",
                              style: TextStyle(
                                  fontSize: responsiveFont(12),
                                  color: secondaryColor,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        Container(
                          height: 5,
                        ),
                        Text(
                          "${AppLocalizations.of(context)
                              .translate('available')} : $stock ${AppLocalizations.of(context)
                              .translate('stock')}",
                          style: TextStyle(fontSize: responsiveFont(9),color: Colors.green),
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
