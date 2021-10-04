import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:udcks_news_app/provider/auth_provider.dart';
import 'package:udcks_news_app/styling.dart';

import '../../app_localization.dart';
import '../../routers.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: "");
    _passwordController = TextEditingController(text: "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: _buildForm(context),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget _buildForm(BuildContext context) {
    const AssetImage logo = AssetImage('assets/images/udck_logo.png');

    final authProvider = Provider.of<AuthProvider>(context);
    return Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.all(70.0),
                  child: Image(
                    image: logo,
                    height: 128,
                  ),
                ),
                TextFormField(
                  controller: _emailController,
                  style: Theme.of(context).textTheme.bodyText2,
                  validator: (value) => value!.isEmpty
                      ? AppLocalizations.of(context)
                          .translate("loginTxtErrorEmail")
                      : null,
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.email,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      labelText: AppLocalizations.of(context)
                          .translate("loginTxtEmail"),
                      border: OutlineInputBorder()),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: TextFormField(
                    obscureText: true,
                    maxLength: 12,
                    controller: _passwordController,
                    style: Theme.of(context).textTheme.bodyText2,
                    validator: (value) => value!.length < 6
                        ? AppLocalizations.of(context)
                            .translate("loginTxtErrorPassword")
                        : null,
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        labelText: AppLocalizations.of(context)
                            .translate("loginTxtPassword"),
                        border: OutlineInputBorder()),
                  ),
                ),
                authProvider.status == Status.authenticating
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : RaisedButton(
                        child: Text(
                          AppLocalizations.of(context)
                              .translate("loginBtnSignIn"),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            FocusScope.of(context)
                                .unfocus(); //to hide the keyboard - if any

                            bool status =
                                await authProvider.signInWithEmailAndPassword(
                                    _emailController.text,
                                    _passwordController.text);

                            if (!status) {
                              _scaffoldKey.currentState!.showSnackBar(SnackBar(
                                content: Text(AppLocalizations.of(context)
                                    .translate("loginTxtErrorSignIn")),
                              ));
                            } else {
                              Navigator.of(context)
                                  .pushReplacementNamed(Routes.mainPage);
                              print("Login thanh cong");
                            }
                          }
                        }),
                authProvider.status == Status.authenticating
                    ? const Center(
                        child: null,
                      )
                    : Padding(
                        padding: const EdgeInsets.only(top: 48),
                        child: Center(
                            child: Text(
                          AppLocalizations.of(context)
                              .translate("loginTxtDontHaveAccount"),
                          style: Theme.of(context).textTheme.button,
                        )),
                      ),
                authProvider.status == Status.authenticating
                    ? const Center(
                        child: null,
                      )
                    : FlatButton(
                        child: Text(
                            AppLocalizations.of(context)
                                .translate("loginBtnLinkCreateAccount"),
                            style: AppTheme.headline),
                        textColor: Theme.of(context).iconTheme.color,
                        onPressed: () {
                          Navigator.of(context)
                              .pushReplacementNamed(Routes.register);
                        },
                      ),
              ],
            ),
          ),
        ));
  }
}
