import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:udcks_news_app/app_localization.dart';
import 'package:udcks_news_app/routers.dart';
import 'package:udcks_news_app/styling.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  List<Slide> slides = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    slides.add(
      Slide(
        title: AppLocalizations.of(context).translate("welcomeSlideWelcomeTxt"),
        description:
            AppLocalizations.of(context).translate("welcomeSlideWelcomeDesTxt"),
        pathImage: "assets/images/udck_logo.png",
        backgroundColor: AppTheme.grey,
      ),
    );
    slides.add(
      Slide(
        title: AppLocalizations.of(context).translate("welcomeSlide1Txt"),
        description:
            AppLocalizations.of(context).translate("welcomeSlide1DesTxt"),
        pathImage: "assets/images/notification_slide.jpg",
        backgroundColor: const Color(0xFF8ECAF8),
      ),
    );
    slides.add(
      Slide(
        title: AppLocalizations.of(context).translate("welcomeSlide2Txt"),
        description:
            AppLocalizations.of(context).translate("welcomeSlide2DesTxt"),
        pathImage: "assets/images/subcribe_slide.jpg",
        backgroundColor: const Color(0xFFF66754),
      ),
    );
    slides.add(
      Slide(
        title: AppLocalizations.of(context).translate("welcomeSlide3Txt"),
        description:
            AppLocalizations.of(context).translate("welcomeSlide3DesTxt"),
        pathImage: "assets/images/localization_slide.jpg",
        backgroundColor: const Color(0xFFFFA561),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  void onDonePress() {
    Navigator.of(context).pushReplacementNamed(Routes.mainPage);
  }

  @override
  Widget build(BuildContext context) {
    return IntroSlider(
      slides: slides,
      onDonePress: onDonePress,
    );
  }
}
