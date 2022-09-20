import 'package:flutter/material.dart';
import 'package:CareTalk/frontend/auth_screens/login.dart';
import 'package:CareTalk/global_uses/constants.dart';
import 'package:flutter_overboard/flutter_overboard.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final pages = [
    PageModel(
        color: kWhite,
        titleColor: kSecondaryAppColor,
        bodyColor: kGrey,
        imageAssetPath: 'assets/images/onboarding1.jpg',
        title: 'Chat anytime, anywhere',
        body: 'Accessing therapy has never been so simple, you will find a safe space and with specialists willing to help you, do not give up!',
        doAnimateImage: true),
    PageModel(
        color: kWhite,
        titleColor: kSecondaryAppColor,
        bodyColor: kGrey,
        imageAssetPath: 'assets/images/onboarding2.jpg',
        title: 'Make video and audio calls',
        body: 'Experience a lag-free video and audio chat connection, with the objective to make easier the communication',
        doAnimateImage: true),
    PageModel(
        color: kWhite,
        titleColor: kSecondaryAppColor,
        bodyColor: kGrey,
        imageAssetPath: 'assets/images/onboarding3.jpg',
        title: 'Reach many people and you can help them',
        body: 'You as Specialist can meet and connect with people waiting for a help, all over the world',
        doAnimateImage: true),
  ];

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: kWhite,
      body: Padding(
        padding: const EdgeInsets.only(top:12.0),
        child: OverBoard(
          pages: pages,
          showBullets: true,
          buttonColor: kPrimaryAppColor,
          skipText: 'SKIP',
          nextText: 'NEXT',
          activeBulletColor: kPrimaryAppColor,
          inactiveBulletColor: kGrey,
          finishText: 'GOT IT',
          skipCallback: () {
            Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => const LoginPage()));
          },
          finishCallback: () {
            Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => const LoginPage()));
          },
        ),
      ),
    );
  }
}
