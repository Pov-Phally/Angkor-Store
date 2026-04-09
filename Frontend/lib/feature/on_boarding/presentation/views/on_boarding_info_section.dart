import 'package:angkor_store/core/extensions/text_style_extension.dart';
import 'package:angkor_store/core/res/media.dart';
import 'package:angkor_store/core/res/style/color.dart';
import 'package:angkor_store/core/res/style/text.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class OnBoardingInfoSection extends StatelessWidget {
  const OnBoardingInfoSection.first({super.key}) : first = true;

  const OnBoardingInfoSection.second({super.key}) : first = false;

  final bool first;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: AlignmentDirectional.center,
      children: [
        first ? Lottie.asset(Media.onBoarding) : Lottie.asset(Media.onBoarding),
        Column(
          children: [
            switch (first) {
              true => Text.rich(
                textAlign: TextAlign.left,
                TextSpan(
                  text: "${DateTime.now().year}\n",
                  style: TextStyles.headingBold.orange,
                  children: [
                    TextSpan(
                      text: "Autumn sale is live now",
                      style: TextStyle(
                        color: Colours.classicAdaptiveTextColor(context),
                      ),
                    ),
                  ],
                ),
              ),
              _ => Text.rich(
                textAlign: TextAlign.left,
                TextSpan(
                  text: "Flash Sales \n",
                  style: TextStyles.headingBold.orange,
                  children: [
                    TextSpan(
                      text: "First come first serve",
                      style: TextStyle(
                        color: Colours.classicAdaptiveTextColor(context),
                      ),
                    ),
                  ],
                ),
              ),
            },
          ],
        ),
      ],
    );
  }
}
