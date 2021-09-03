import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/gestures.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nyoba/pages/language/LanguageScreen.dart';
import 'package:nyoba/provider/LoginProvider.dart';
import 'package:provider/provider.dart';
import '../../AppLocalizations.dart';
import 'ForgotPasswordScreen.dart';
import 'SignUpScreen.dart';
import '../../utils/utility.dart';
import 'package:auto_size_text/auto_size_text.dart';

class Login extends StatefulWidget {
  final bool isFromNavBar;
  Login({Key key, this.isFromNavBar}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isVisible = false;

  TextEditingController username = new TextEditingController();
  TextEditingController password = new TextEditingController();

  bool isFromNavBar = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.isFromNavBar != null) {
      isFromNavBar = widget.isFromNavBar;
    }
  }





  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<LoginProvider>(context, listen: false);

    var loginByDefault = () async {
      if (username.text.isNotEmpty && password.text.isNotEmpty) {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
        await Provider.of<LoginProvider>(context, listen: false)
            .login(context, password: password.text, username: username.text)
            .then((value) => this.setState(() {}));
      } else {
        snackBar(context, message: 'Username & password should not empty');
      }
    };

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          leading: !isFromNavBar
              ? IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ))
              : null,
          title: AutoSizeText(
            AppLocalizations.of(context).translate('login'),
            style:
                TextStyle(fontSize: responsiveFont(16), color: secondaryColor),
          ),
          backgroundColor: Colors.white),
      body: Container(
        margin: EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${AppLocalizations.of(context).translate('welcome')}!",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: responsiveFont(14),
                ),
              ),
              Text(
                AppLocalizations.of(context).translate('subtitle_login'),
                style: TextStyle(
                  fontSize: responsiveFont(9),
                ),
              ),
              Container(
                height: 20,
              ),
              Container(
                height: MediaQuery.of(context).size.height / 12,
                child: TextField(
                  controller: username,
                  decoration: InputDecoration(
                      prefixIcon: Container(
                          width: 24.w,
                          height: 24.h,
                          padding: EdgeInsets.only(right: 5),
                          child: Image.asset("images/account/akun.png")),
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: responsiveFont(10),
                      ),
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: responsiveFont(12),
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelText: "Username",
                      hintText: AppLocalizations.of(context)
                          .translate('hint_username')),
                ),
              ),
              Container(
                height: 15,
              ),
              Container(
                height: MediaQuery.of(context).size.height / 12,
                child: TextField(
                  controller: password,
                  obscureText: isVisible ? false : true,
                  decoration: InputDecoration(
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            isVisible = !isVisible;
                          });
                        },
                        child: Container(
                            padding: EdgeInsets.only(top: 20, bottom: 20),
                            child: Image.asset(isVisible
                                ? "images/account/melek.png"
                                : "images/account/merem.png")),
                      ),
                      prefixIcon: Container(
                          width: 24.w,
                          height: 24.h,
                          padding: EdgeInsets.only(right: 5),
                          child: Image.asset("images/account/lock.png")),
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: responsiveFont(10),
                      ),
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: responsiveFont(12),
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelText: "Password",
                      hintText: AppLocalizations.of(context)
                          .translate('hint_password')),
                ),
              ),
              Container(
                height: 10,
              ),
              InkWell(
                onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ForgotPasswordScreen()))
                    .then((value) => this.setState(() {})),
                child: Container(
                  alignment: Alignment.centerRight,
                  width: double.infinity,
                  child: Text(
                    AppLocalizations.of(context).translate('forgot_password'),
                    style: TextStyle(
                      color: HexColor("FD490C"),
                      fontSize: responsiveFont(10),
                    ),
                  ),
                ),
              ),
              Container(
                height: 15,
              ),
              Container(
                width: double.infinity,
                child: TextButton(
                  style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      backgroundColor:
                          auth.loading ? Colors.grey : secondaryColor),
                  onPressed: loginByDefault,
                  child: auth.loading
                      ? customLoading()
                      : Text(
                          AppLocalizations.of(context).translate('login'),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: responsiveFont(10),
                          ),
                        ),
                ),
              ),
              Container(
                height: 15,
              ),
              Image.asset("images/account/baris.png"),
              Container(
                height: 15,
              ),
              Center(
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: responsiveFont(10),
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text:
                            "${AppLocalizations.of(context).translate("don't_have_account")} ",
                      ),
                      TextSpan(
                          recognizer: new TapGestureRecognizer()
                            ..onTap = () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUp())),
                          text:
                              AppLocalizations.of(context).translate('sign_up'),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: secondaryColor)),
                    ],
                  ),
                ),
              ),
              Container(
                height: 15,
              ),
              accountButton("languange",
                  AppLocalizations.of(context).translate('title_language'),
                  func: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LanguageScreen()));
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Widget accountButton(String image, String title, {var func}) {
    return Column(
      children: [
        InkWell(
          onTap: func,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                        width: 25.w,
                        height: 25.h,
                        child: Image.asset("images/account/$image.png")),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      title,
                      style: TextStyle(fontSize: responsiveFont(11)),
                    )
                  ],
                ),
                Icon(Icons.keyboard_arrow_right)
              ],
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 15),
          width: double.infinity,
          height: 2,
          color: Colors.black12,
        )
      ],
    );
  }
}
