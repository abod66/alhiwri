/* Dart Package */
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:nyoba/pages/category/BrandProduct.dart';
import 'package:nyoba/pages/product/ProductDetailScreen.dart';
import 'package:nyoba/pages/product/ProductMoreScreen.dart';
import 'package:nyoba/pages/product/AllProductsScreen.dart';
import 'package:nyoba/pages/wishlist/WishlistScreen.dart';
import 'package:nyoba/pages/auth/LoginScreen.dart';
import 'package:nyoba/pages/notification/NotificationScreen.dart';
import 'package:nyoba/models/ProductModel.dart';
import 'package:nyoba/pages/order/MyOrder.dart';
import 'package:nyoba/pages/search/SearchScreen.dart';
import 'package:nyoba/provider/FlashSaleProvider.dart';
import 'package:nyoba/provider/GeneralSettingsProvider.dart';
import 'package:nyoba/provider/HomeProvider.dart';
import 'package:nyoba/provider/ProductProvider.dart';
import 'package:nyoba/services/Session.dart';
import 'package:nyoba/widgets/home/CustomClipPath.dart';
import 'package:nyoba/widgets/home/banner/BannerContainerShimmer.dart';
import 'package:nyoba/widgets/home/categories/BadgeShimmer.dart';
import 'package:nyoba/widgets/home/flashsale/FlashSaleCountdown.dart';
import 'package:provider/provider.dart';

/* Widget  */
import 'package:nyoba/widgets/home/banner/BannerContainer.dart';
import 'package:shimmer/shimmer.dart';
import '../../AppLocalizations.dart';
import '../../widgets/home/categories/BadgeCategory.dart';
import '../../widgets/home/CardItemSmall.dart';
import '../../widgets/home/GridItem.dart';

/* Provider */
import '../../provider/BannerProvider.dart';
import '../../provider/CategoryProvider.dart';

/* Helper */
import '../../utils/utility.dart';

class LobbyScreen extends StatefulWidget {
  LobbyScreen({Key key}) : super(key: key);

  @override
  _LobbyScreenState createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen>
    with TickerProviderStateMixin {
  AnimationController _colorAnimationController;
  AnimationController _textAnimationController;
  Animation _colorTween, _titleColorTween, _iconColorTween, _moveTween;

  int itemCount = 10;
  int itemCategoryCount = 9;
  int clickIndex = 0;
  String selectedCategory;

  @override
  void initState() {
    super.initState();

    final products = Provider.of<ProductProvider>(context, listen: false);
    final home = Provider.of<HomeProvider>(context, listen: false);
    _colorAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 0));
    _colorTween = ColorTween(
      begin: primaryColor.withOpacity(0.0),
      end: primaryColor.withOpacity(1.0),
    ).animate(_colorAnimationController);
    _titleColorTween = ColorTween(
      begin: Colors.white,
      end: HexColor("ED625E"),
    ).animate(_colorAnimationController);
    _iconColorTween = ColorTween(begin: Colors.white, end: HexColor("#4A3F35"))
        .animate(_colorAnimationController);
    _textAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 0));
    _moveTween = Tween(
      begin: Offset(0, 0),
      end: Offset(-25, 0),
    ).animate(_colorAnimationController);

    if (home.isReload) {
      reloadProducts();
    }
    if (products.listNewProduct.isEmpty) {
      loadNewProduct(true);
    }
    if (Session.data.getBool('isLogin') != null &&
        Session.data.getBool('isLogin')) {
      loadRecentProduct();
    }
  }

  bool scrollListener(ScrollNotification scrollInfo) {
    if (scrollInfo.metrics.axis == Axis.horizontal) {
      _colorAnimationController.animateTo(scrollInfo.metrics.pixels / 150);
      _textAnimationController
          .animateTo((scrollInfo.metrics.pixels - 350) / 50);
      return true;
    } else {
      return false;
    }
  }

  int item = 6;

  loadNewProduct(bool loading) async {
    await Provider.of<ProductProvider>(context, listen: false)
        .fetchNewProducts(clickIndex == 0 ? '' : clickIndex.toString());
  }

  loadRecentProduct() async {
    await Provider.of<ProductProvider>(context, listen: false)
        .fetchRecentProducts();
  }

  reloadProducts() async {
    await Provider.of<HomeProvider>(context, listen: false)
        .fetchFlashSale(context);
  }

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ProductProvider>(context, listen: false);
    final general =
        Provider.of<GeneralSettingsProvider>(context, listen: false);

    Widget buildNewProducts = Container(
      child: ListenableProvider.value(
        value: products,
        child: Consumer<ProductProvider>(builder: (context, value, child) {
          if (value.loadingNew) {
            return Container(
                height: MediaQuery.of(context).size.height / 3.0,
                child: shimmerProductItemSmall());
          }
          return Container(
              height: MediaQuery.of(context).size.height / 3.0,
              child: ListView.separated(
                itemCount: value.listNewProduct.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, i) {
                  return CardItem(
                    product: value.listNewProduct[i],
                    i: i,
                    itemCount: value.listNewProduct.length,
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    width: 5,
                  );
                },
              ));
        }),
      ),
    );

    Widget buildRecentProducts = Container(
      child: ListenableProvider.value(
        value: products,
        child: Consumer<ProductProvider>(builder: (context, value, child) {
          if (value.loadingNew) {
            return Container(
                height: MediaQuery.of(context).size.height / 3.0,
                child: shimmerProductItemSmall());
          }
          return Visibility(
              visible: value.listRecentProduct.isNotEmpty,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 15, right: 15, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Recently Viewed Products",
                          style: TextStyle(
                              fontSize: responsiveFont(14),
                              fontWeight: FontWeight.w600),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AllProductsScreen()));
                          },
                          child: Text(
                            AppLocalizations.of(context).translate('more'),
                            style: TextStyle(
                                fontSize: responsiveFont(12),
                                fontWeight: FontWeight.w600,
                                color: secondaryColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      height: MediaQuery.of(context).size.height / 3.0,
                      child: ListView.separated(
                        itemCount: value.listRecentProduct.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, i) {
                          return CardItem(
                            product: value.listRecentProduct[i],
                            i: i,
                            itemCount: value.listRecentProduct.length,
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(
                            width: 5,
                          );
                        },
                      ))
                ],
              ));
        }),
      ),
    );

    Widget buildRecommendation = Container(
      child: ListenableProvider.value(
        value: products,
        child: Consumer<ProductProvider>(builder: (context, value, child) {

          if (value.loadingRecommendation) {
            return customLoading();
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(left: 15, top: 15),
                child: Text(
                  AppLocalizations.of(context).translate('recommendation'),
                  style: TextStyle(
                      fontSize: responsiveFont(14),
                      fontWeight: FontWeight.w600),
                ),
              ),

              //recommendation item
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: GridView.builder(
                  primary: false,
                  shrinkWrap: true,
                  itemCount: value.listRecommendationProduct.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      crossAxisCount: 2,
                      childAspectRatio: 80 / 130),
                  itemBuilder: (context, i) {
                    return GridItem(
                      i: i,
                      itemCount: value.listRecommendationProduct.length,
                      product: value.listRecommendationProduct[i],
                    );
                  },
                ),
              ),
            ],
          );
        }),
      ),
    );

    return ColorfulSafeArea(
      color: primaryColor,
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    appBar(),
                    Stack(
                      children: [
                        ClipPath(
                          clipper: CustomClipPath(),
                          child: Container(
                            height: 150,
                            color: primaryColor,
                          ),
                        ),
                        // ),
                        Column(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height / 12,
                              margin: EdgeInsets.all(15),
                              child: Row(
                                children: [
                                  Image.asset("images/lobby/logoRevo.jpeg"),
                                  Container(
                                    width: 12,
                                  ),
                                  Visibility(
                                      visible:
                                          Session.data.getBool('isLogin') ==
                                                  null ||
                                              !Session.data.getBool('isLogin'),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              "ALHIWRI",
                                              style: TextStyle(
                                                  fontSize: responsiveFont(14),
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                          ),
                                          Flexible(
                                            child: Row(
                                              children: [
                                                Text(
                                                  "${AppLocalizations.of(context).translate('please_login')} ",
                                                  style: TextStyle(
                                                      fontSize:
                                                          responsiveFont(10),
                                                      color: Colors.white),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    Login(
                                                                      isFromNavBar:
                                                                          false,
                                                                    )));
                                                  },
                                                  child: Text(
                                                    AppLocalizations.of(context)
                                                        .translate('here'),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize:
                                                            responsiveFont(10),
                                                        color: Colors.white),
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      )),
                                  Session.data.getString('firstname') != null
                                      ? Visibility(
                                          visible:
                                              Session.data.getBool('isLogin'),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  "${AppLocalizations.of(context).translate('hello')}, ${Session.data.getString('firstname').length > 10 ? Session.data.getString('firstname').substring(0, 10) + '... ' : Session.data.getString('firstname')} !",
                                                  style: TextStyle(
                                                      fontSize:
                                                          responsiveFont(14),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                ),
                                              ),
                                              Flexible(
                                                child: Text(
                                                  AppLocalizations.of(context)
                                                      .translate(
                                                          'welcome_back'),
                                                  style: TextStyle(
                                                      fontSize:
                                                          responsiveFont(10),
                                                      color: Colors.white),
                                                ),
                                              )
                                            ],
                                          ))
                                      : Container()
                                ],
                              ),
                            ),
                            Container(
                              height: 0,
                            ),
                            //Banner Item start Here



                          ],
                        ),
                      ],
                    ),
                    Container(
                      height: 15,
                    ),
                    //category secttion
                    Consumer<CategoryProvider>(
                        builder: (context, value, child) {
                      if (value.loading) {
                        return BadgeShimmer();
                      } else {
                        return BadgeCategory(value.categories,
                        );
                      }
                    }),
                    //flash sale countdown & card product item
                    Consumer<FlashSaleProvider>(
                        builder: (context, value, child) {
                      return FlashSaleCountdown(
                        dataFlashSaleCountDown: value.flashSales,
                        dataFlashSaleProducts: value.flashSaleProducts,
                        textAnimationController: _textAnimationController,
                        colorAnimationController: _colorAnimationController,
                        colorTween: _colorTween,
                        iconColorTween: _iconColorTween,
                        moveTween: _moveTween,
                        titleColorTween: _titleColorTween,
                        loading: value.loading,
                      );
                    }),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(
                          left: 15, bottom: 10, right: 15, top: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context)
                                .translate('new_product'),
                            style: TextStyle(
                                fontSize: responsiveFont(14),
                                fontWeight: FontWeight.w600),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BrandProducts(
                                            categoryId: clickIndex == 0
                                                ? ''
                                                : clickIndex.toString(),
                                            brandName: clickIndex == 0
                                                ? 'NEW PRODUCTS'
                                                : selectedCategory,
                                          )));
                            },
                            child: Text(
                              AppLocalizations.of(context).translate('more'),
                              style: TextStyle(
                                  fontSize: responsiveFont(12),
                                  fontWeight: FontWeight.w600,
                                  color: secondaryColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Consumer<CategoryProvider>(
                        builder: (context, value, child) {
                      if (value.loading) {
                        return Container();
                      } else {
                        return Container(
                          height: MediaQuery.of(context).size.height / 21,
                          child: ListView.separated(
                              itemCount: value.productCategories.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, i) {
                                return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        clickIndex =
                                            value.productCategories[i].id;
                                        selectedCategory =
                                            value.productCategories[i].name;
                                      });
                                      loadNewProduct(true);
                                    },
                                    child: tabCategory(
                                        value.productCategories[i],
                                        i,
                                        value.productCategories.length));
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return SizedBox(
                                  width: 8,
                                );
                              }),
                        );
                      }
                    }),
                    Container(
                      height: 10,
                    ),
                    buildNewProducts,
                    Container(
                      height: 15,
                    ),

                    //Mini Banner Item start Here



                    //special for you item
                    Consumer<ProductProvider>(builder: (context, value, child) {
                      return Container(
                        color: Colors.red,
                        child: Column(
                          children: [
                            Container(
                                width: double.infinity,
                                margin: EdgeInsets.only(
                                    left: 15, bottom: 10, right: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        value.productSpecial != null
                                            ? Text(
                                                value.productSpecial.title,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                    fontSize: responsiveFont(14),
                                                    fontWeight: FontWeight.w600),
                                              )
                                            : Container(),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ProductMoreScreen(
                                                          include: value
                                                              .productSpecial
                                                              .products,
                                                          name: value
                                                              .productSpecial
                                                              .title,
                                                        )));
                                          },
                                          child: Text(
                                            AppLocalizations.of(context)
                                                .translate('more'),
                                            style: TextStyle(
                                                fontSize: responsiveFont(12),
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                    value.productSpecial != null
                                        ? Text(
                                            value.productSpecial.description,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                            ),
                                          )
                                        : Container(),
                                  ],
                                )),
                            Container(
                                height: 250,
                                padding: EdgeInsets.only(bottom: 10),
                                child: value.loadingSpecial
                                    ? shimmerProductItemSmall()
                                    : ListView.separated(
                                        itemCount:
                                            value.listSpecialProduct.length,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, i) {
                                          return CardItem(
                                            product: value.listSpecialProduct[i],
                                            i: i,
                                            itemCount:
                                                value.listSpecialProduct.length,
                                          );
                                        },
                                        separatorBuilder:
                                            (BuildContext context, int index) {
                                          return SizedBox(
                                            width: 5,
                                          );
                                        },
                                      )),
                          ],
                        ),
                      );
                    }),
                    Container(
                      height: 10,
                    ),
                    Stack(
                      children: [
                        Container(
                          color: alternateColor,
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height / 3.5,
                        ),
                        Consumer<ProductProvider>(
                            builder: (context, value, child) {
                          if (value.loadingBest) {
                            return Column(
                              children: [
                                Shimmer.fromColors(
                                    child: Container(
                                      width: double.infinity,
                                      margin: EdgeInsets.only(
                                          left: 15, right: 15, top: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                width: 150,
                                                height: 10,
                                                color: Colors.white,
                                              )
                                            ],
                                          ),
                                          Container(
                                            height: 2,
                                          ),
                                          Container(
                                            width: 100,
                                            height: 8,
                                            color: Colors.white,
                                          )
                                        ],
                                      ),
                                    ),
                                    baseColor: Colors.grey[300],
                                    highlightColor: Colors.grey[100]),
                                Container(
                                  height: 10,
                                ),
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height / 3.0,
                                  child: shimmerProductItemSmall(),
                                )
                              ],
                            );
                          }
                          return Column(
                            children: [
                              Container(
                                width: double.infinity,
                                margin: EdgeInsets.only(
                                    left: 15, right: 15, top: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context).translate('bestsale'),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: responsiveFont(14),
                                              fontWeight: FontWeight.w600),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ProductMoreScreen(
                                                          name: value
                                                              .productBest
                                                              .title,
                                                          include: value
                                                              .productBest
                                                              .products,
                                                        )));
                                          },
                                          child: Text(
                                            AppLocalizations.of(context)
                                                .translate('more'),
                                            style: TextStyle(
                                                fontSize: responsiveFont(12),
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      AppLocalizations.of(context).translate('bestdec'),
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 10,
                              ),
                              Container(
                                height:
                                    MediaQuery.of(context).size.height / 3.0,
                                child: ListView.separated(
                                  itemCount: value.listBestProduct.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, i) {
                                    return CardItem(
                                      product: value.listBestProduct[i],
                                      i: i,
                                      itemCount: value.listBestProduct.length,
                                    );
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return SizedBox(
                                      width: 5,
                                    );
                                  },
                                ),
                              )
                            ],
                          );
                        }),
                      ],
                    ),

                    //love this


                    //Mini Banner Item start Here

                    //recently viewed item
                    buildRecentProducts,
                    Container(
                      height: 15,
                    ),
                    Container(
                      width: double.infinity,
                      height: 7,
                      color: HexColor("EEEEEE"),
                    ),
                    buildRecommendation,

                  ],
                ),
              ),
              appBar()
            ],
          )),
    );
  }

  Widget tabCategory(ProductCategoryModel model, int i, int count) {
    return Container(
      margin: EdgeInsets.only(
          left: i == 0 ? 15 : 0, right: i == count - 1 ? 15 : 0),
      child: Tab(
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            decoration: BoxDecoration(
              color: clickIndex == model.id ? primaryColor.withOpacity(0.5) : Colors.white,
              border: Border.all(
                  color: clickIndex == model.id
                      ? secondaryColor
                      : HexColor("B0b0b0")),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              convertHtmlUnescape(model.name),
              style: TextStyle(
                  fontSize: 13,
                  color: clickIndex == model.id
                      ? secondaryColor
                      : HexColor("B0b0b0")),
            )),
      ),
    );
  }

  Widget appBar() {
    return Material(
      elevation: 5,
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: primaryColor,
        ),
        child: Container(
          height: 70,
          padding: EdgeInsets.only(left: 15, right: 10, top: 15, bottom: 15),
          child: Row(
            children: [
              Expanded(
                  flex: 4,
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
                        prefixIcon: Icon(
                          Icons.search,
                          color: primaryColor,
                        ),
                        hintText:
                            AppLocalizations.of(context).translate('search'),
                        hintStyle: TextStyle(
                            fontSize: responsiveFont(10), color: Colors.black),
                      ),
                    ),
                  )),
              Container(
                width: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => WishList()));
                    },
                    child: Container(
                        width: 27.w,
                        child: Image.asset("images/lobby/heart.png")),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => MyOrder()));
                    },
                    child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        width: 27.w,
                        child: Image.asset("images/lobby/document.png")),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NotificationScreen()));
                    },
                    child: Container(
                        width: 27.w,
                        child: Image.asset("images/lobby/bellRinging.png")),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
