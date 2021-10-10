import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:udcks_news_app/models/user_model.dart';
import 'package:udcks_news_app/provider/auth_provider.dart';
import 'package:udcks_news_app/styling.dart';

import '../../app_localization.dart';
import '../../routers.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: "");
    _firstNameController = TextEditingController(text: "");
    _lastNameController = TextEditingController(text: "");
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
    final authProvider = Provider.of<AuthProvider>(context);
    const AssetImage logo = AssetImage('assets/images/udck_logo.png');

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
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    AppLocalizations.of(context).translate("registerFormTxt"),
                    style: AppTheme.display1,
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
                      border: const OutlineInputBorder()),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: TextFormField(
                                controller: _firstNameController,
                                style: Theme.of(context).textTheme.bodyText2,
                                validator: (value) => value!.isEmpty
                                    ? AppLocalizations.of(context)
                                        .translate("registerFormFirstNameError")
                                    : null,
                                decoration: InputDecoration(
                                    labelText: AppLocalizations.of(context)
                                        .translate("registerFormFirstName"),
                                    border: const OutlineInputBorder()),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: TextFormField(
                                controller: _lastNameController,
                                style: Theme.of(context).textTheme.bodyText2,
                                validator: (value) => value!.isEmpty
                                    ? AppLocalizations.of(context)
                                        .translate("registerFormLastNameError")
                                    : null,
                                decoration: InputDecoration(
                                    labelText: AppLocalizations.of(context)
                                        .translate("registerFormLastName"),
                                    border: const OutlineInputBorder()),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextFormField(
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
                      ],
                    )),
                authProvider.status == Status.registering
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : RaisedButton(
                        child: Text(
                          AppLocalizations.of(context)
                              .translate("loginBtnSignUp"),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            FocusScope.of(context)
                                .unfocus(); //to hide the keyboard - if any

                            UserModel? userModel =
                                await authProvider.registerWithEmailAndPassword(
                                    _emailController.text,
                                    _passwordController.text,
                                    _firstNameController.text,
                                    _lastNameController.text);

                            if (userModel.uid == "null") {
                              _scaffoldKey.currentState!.showSnackBar(SnackBar(
                                content: Text(AppLocalizations.of(context)
                                    .translate("loginTxtErrorSignIn")),
                              ));
                            }
                            if (userModel.uid != "null") {
                              Navigator.of(context)
                                  .pushReplacementNamed(Routes.welcomePage);
                            }
                          }
                        }),
                authProvider.status == Status.registering
                    ? const Center(
                        child: null,
                      )
                    : Padding(
                        padding: const EdgeInsets.only(top: 48),
                        child: Center(
                            child: Text(
                          AppLocalizations.of(context)
                              .translate("loginTxtHaveAccount"),
                          style: Theme.of(context).textTheme.button,
                        )),
                      ),
                authProvider.status == Status.registering
                    ? const Center(
                        child: null,
                      )
                    : FlatButton(
                        child: Text(
                            AppLocalizations.of(context)
                                .translate("loginBtnLinkSignIn"),
                            style: AppTheme.headline),
                        textColor: Theme.of(context).iconTheme.color,
                        onPressed: () {
                          Navigator.of(context)
                              .pushReplacementNamed(Routes.login);
                        },
                      ),
              ],
            ),
          ),
        ));
  }
}
