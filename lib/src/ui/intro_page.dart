import 'package:flutter/material.dart';
import 'package:introduction_screen/src/model/page_view_model.dart';
import 'package:introduction_screen/src/ui/intro_content.dart';

class IntroPage extends StatelessWidget {
  final PageViewModel page;

  const IntroPage({required this.page});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: page.decoration.pageColor,
      decoration: page.decoration.boxDecoration,
      child: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 44,
              left: 0,
              right: 0,
              child: page.image ?? SizedBox(),
            ),
            Positioned(
              top: 0,
              right: 16,
              left: 16,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: IntroContent(page: page),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
