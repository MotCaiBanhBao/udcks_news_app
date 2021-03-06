import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:udcks_news_app/models/user_model.dart';
import 'package:udcks_news_app/provider/auth_provider.dart';
import 'package:udcks_news_app/provider/language_provider.dart';
import 'package:udcks_news_app/routers.dart';
import 'package:udcks_news_app/services/firebase_database.dart';
import 'package:udcks_news_app/services/notifiaction/fcm_firebase.dart';
import 'package:udcks_news_app/styling.dart';
import 'package:udcks_news_app/views/auth/sign_in_screen.dart';
import 'package:udcks_news_app/views/home/home.dart';
import 'app_localization.dart';
import 'auth_widget_builder.dart';

class MyApp extends StatefulWidget {
  final FirestoreDatabase Function(BuildContext context, String uid)
      databaseBuilder;
  const MyApp({Key? key, required this.databaseBuilder}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    FCMServices.setUp();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(builder: (_, languageProviderRef, __) {
      return AuthWidgetBuilder(
          key: const Key("AuthWidget"),
          builder:
              (BuildContext context, AsyncSnapshot<UserModel> userSnapshot) {
            return MaterialApp(
              locale: languageProviderRef.appLocale,
              //Danh sách các khu vực được hỗ trợ
              supportedLocales: const [
                Locale('en', 'US'),
                Locale('vi', 'VN'),
              ],
              //These delegates make sure that the localization data for the proper language is loaded
              localizationsDelegates: [
                //A class which loads the translations from JSON files
                AppLocalizations.delegate,
                //Built-in localization of basic text for Material widgets (means those default Material widget such as alert dialog icon text)
                GlobalMaterialLocalizations.delegate,
                //Built-in localization for text direction LTR/RTL
                GlobalWidgetsLocalizations.delegate,
              ],
              //return a locale which will be used by the app
              localeResolutionCallback: (locale, supportedLocales) {
                //check if the current device locale is supported or not
                for (var supportedLocale in supportedLocales) {
                  if (supportedLocale.languageCode == locale?.languageCode ||
                      supportedLocale.countryCode == locale?.countryCode) {
                    return supportedLocale;
                  }
                }
                //if the locale from the mobile device is not supported yet,
                //user the first one from the list (in our case, that will be English)
                return supportedLocales.first;
              },
              theme: ThemeData(
                  buttonColor: AppTheme.grey,
                  textTheme: AppTheme.textTheme,
                  scaffoldBackgroundColor: AppTheme.notWhite,
                  accentColor: AppTheme.orange,
                  canvasColor: AppTheme.notWhite),
              debugShowCheckedModeBanner: false,
              title: "Sigin",
              routes: Routes.routes,
              home: Consumer<AuthProvider>(
                builder: (_, authProviderRef, __) {
                  if (userSnapshot.connectionState == ConnectionState.active) {
                    return userSnapshot.hasData &&
                            userSnapshot.data?.uid != "null"
                        ? HomeScreen()
                        : SignInScreen();
                  }

                  return const Material(
                    child: Center(child: CircularProgressIndicator()),
                  );
                },
              ),
            );
          },
          databaseBuilder: widget.databaseBuilder);
    });
  }
}
