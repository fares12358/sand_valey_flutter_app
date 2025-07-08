import 'package:flutter/material.dart';
import 'package:sand_valley/widgets/backgroundOrange.dart';
import 'package:sand_valley/widgets/customButton.dart';
import 'package:sand_valley/widgets/customWidget.dart';
import 'package:sand_valley/widgets/customWidgetReversed.dart';
import 'package:sand_valley/widgets/roundedContainer.dart';
import 'package:sand_valley/widgets/background_container.dart';

class SeedMainPage extends StatelessWidget {
  const SeedMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BackgroundContainer(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              children: [
                SizedBox(
                  height: 300,
                  width: double.infinity,
                  child: BackgroundOrange(
                    child: Stack(
                      children: [
                        Positioned(
                          top: 0,
                          left: 0,
                          child: CustomButton(
                            routeName: '/home',
                            icon: Image.asset(
                              'assets/images/arrow.png',
                              width: 60,
                              color: Colors.white, // optional
                            ),
                          ),
                        ),
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 50),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text(
                                      "بذور",
                                      style: TextStyle(
                                        fontSize: 50,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    ImageIcon(
                                      AssetImage('assets/images/page_icon.png'),
                                      size: 100,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: RoundedContainer(
                            image: 'assets/images/seeds-main-img.png',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Items List
                ...List.generate(10, (index) {
                  Widget content;
                  if (index % 2 == 0) {
                    content = customLayout(
                      text: "shehabshehab",
                      image: 'assets/images/seeds-img.png',
                      routeName: '/',
                    );
                  } else {
                    content = customLayoutReversed(
                      text: "shehab",
                      image: 'assets/images/seeds-img.png',
                      routeName: '/',
                    );
                  }
                  return Column(
                    children: [content, const SizedBox(height: 20)],
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
