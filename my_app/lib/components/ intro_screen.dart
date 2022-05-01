import 'package:fithompro/Screens/appMenu/menu.dart';
import 'package:fithompro/Screens/home_page/home_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:introduction_screen/introduction_screen.dart';
import '../Screens/appMenu/menu.dart';
//import on board me dependency

class IntroScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _IntroScreen();
  }
}

class _IntroScreen extends State<IntroScreen> {
  @override
  Widget build(BuildContext context) {
    //this is a page decoration for intro screen
    PageDecoration pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(
          fontSize: 28.0,
          fontWeight: FontWeight.w700,
          color: Colors.white), //tile font size, weight and color
      bodyTextStyle: TextStyle(fontSize: 19.0, color: Colors.white),
      //body text size and color
      //decription padding
      imagePadding: EdgeInsets.all(20), //image padding
      boxDecoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          stops: [0.1, 0.5, 0.7, 0.9],
          colors: [
            Colors.purple,
            Colors.deepPurpleAccent,
            Colors.grey,
            Color.fromARGB(255, 255, 255, 255),
          ],
        ),
      ), //show linear gradient background of page
    );

    return IntroductionScreen(
      globalBackgroundColor: Color.fromARGB(255, 255, 255, 255),
      //main background of screen
      pages: [
        //set your page view here
        PageViewModel(
          title: "Home Page",
          body:
              "1. access to home page (when the icon is yellow you are on the page)\n2. search page\n3. Upload your clothes\n4. profil page\n5. access to the side menu",
          image: introImage('assets/IMG_TUTO/modif_screen_home.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Profile page",
          body:
              "1. In this page you can consult your profile\n2. Here you can see the clothes that you have upload\n 3. The name of your profil (first and last name)",
          image:
              introImage('assets/IMG_TUTO/thumbnail_Screenshot_1646741144.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Search ",
          body:
              "This page display the historic of clothes that your brand has upload\n1. Your brand's name\n2. The seach bar, your can search clothes that your brand has upload\n3. You can see the images of the clothes ",
          image:
              introImage('assets/IMG_TUTO/thumbnail_Screenshot_1646741139.png'),
          decoration: pageDecoration,
        ),

        //add more screen here
      ],

      onDone: () => goHomepage(context), //go to home page on done
      onSkip: () => goHomepage(context), // You can override on skip
      showSkipButton: true,
      nextFlex: 0,
      skip: Text(
        'Skip',
        style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
      ),
      next: Icon(
        Icons.arrow_forward,
        color: Color.fromARGB(255, 0, 0, 0),
      ),
      done: Text(
        'Getting Stated',
        style: TextStyle(
            fontWeight: FontWeight.w600, color: Color.fromARGB(255, 0, 0, 0)),
      ),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0), //size of dots
        color: Color.fromARGB(255, 0, 0, 0), //color of dots
        activeSize: Size(22.0, 10.0),
        //activeColor: Colors.white, //color of active dot
        activeShape: RoundedRectangleBorder(
          //shave of active dot
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }

  void goHomepage(context) {
    Navigator.of(context).pop(false);
    //Navigate to home page and remove the intro screen history
    //so that "Back" button wont work.
  }

  Widget introImage(String assetName) {
    //widget to show intro image
    return Align(
      child: Image.asset('$assetName', width: 350.0),
      alignment: Alignment.bottomCenter,
    );
  }
}
