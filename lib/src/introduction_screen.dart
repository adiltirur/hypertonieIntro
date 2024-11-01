library introduction_screen;

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:introduction_screen/src/model/page_view_model.dart';
import 'package:introduction_screen/src/ui/intro_button.dart';
import 'package:introduction_screen/src/ui/intro_page.dart';

class IntroductionScreen extends StatefulWidget {
  /// All pages of the onboarding
  final List<PageViewModel> pages;

  /// Callback when Done button is pressed
  final VoidCallback onDone;

  /// Done button
  final Widget done;

  /// Callback when Skip button is pressed
  final VoidCallback? onSkip;

  /// Callback when page change
  final ValueChanged<int>? onChange;

  /// Skip button
  final Widget? skip;

  /// Next button
  final Widget? next;

  /// Is the Skip button should be display
  ///
  /// @Default `false`
  final bool showSkipButton;

  /// Is the Next button should be display
  ///
  /// @Default `true`
  final bool showNextButton;

  /// Is the progress indicator should be display
  ///
  /// @Default `true`
  final bool isProgress;

  /// Is the user is allowed to change page
  ///
  /// @Default `false`
  final bool freeze;

  /// Global background color (only visible when a page has a transparent background color)
  final Color? globalBackgroundColor;

  /// Dots decorator to custom dots color, size, and spacing
  final DotsDecorator dotsDecorator;

  /// Animation duration in milliseconds
  ///
  /// @Default `350`
  final int animationDuration;

  /// Index of the initial page
  ///
  /// @Default `0`
  final int initialPage;

  /// Flex ratio of the skip button
  ///
  /// @Default `1`
  final int skipFlex;

  /// Flex ratio of the progress indicator
  ///
  /// @Default `1`
  final int dotsFlex;

  /// Flex ratio of the next/done button
  ///
  /// @Default `1`
  final int nextFlex;

  /// Type of animation between pages
  ///
  /// @Default `Curves.easeIn`
  final Curve curve;

  const IntroductionScreen({
    Key? key,
    required this.pages,
    required this.onDone,
    required this.done,
    this.onSkip,
    this.onChange,
    this.skip,
    this.next,
    this.showSkipButton = false,
    this.showNextButton = true,
    this.isProgress = true,
    this.freeze = false,
    this.globalBackgroundColor,
    this.dotsDecorator = const DotsDecorator(),
    this.animationDuration = 350,
    this.initialPage = 0,
    this.skipFlex = 1,
    this.dotsFlex = 1,
    this.nextFlex = 1,
    this.curve = Curves.easeIn,
  })  : assert((showSkipButton && skip != null) || !showSkipButton),
        assert(skipFlex >= 0 && dotsFlex >= 0 && nextFlex >= 0),
        assert(initialPage >= 0),
        super(key: key);

  @override
  IntroductionScreenState createState() => IntroductionScreenState();
}

class IntroductionScreenState extends State<IntroductionScreen> {
  late final PageController _pageController;
  int _currentPage = 0;

  PageController get controller => _pageController;

  @override
  void initState() {
    super.initState();
    int initialPage = min(widget.initialPage, widget.pages.length - 1);
    _currentPage = initialPage;
    _pageController = PageController(initialPage: initialPage);
  }

  bool _onScroll(ScrollNotification notification) {
    final metrics = notification.metrics;
    if (metrics is PageMetrics) {
      setState(() => _currentPage = metrics.page?.toInt() ?? 0);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = (_currentPage.round() == widget.pages.length - 1);

    final nextBtn = IntroButton(
      child: widget.next ?? const SizedBox(),
      onPressed: widget.onDone,
    );

    final doneBtn = IntroButton(
      child: widget.done,
      onPressed: widget.onDone,
    );

    return Scaffold(
      backgroundColor: widget.globalBackgroundColor,
      body: Stack(
        children: [
          NotificationListener<ScrollNotification>(
            onNotification: _onScroll,
            child: PageView(
              controller: _pageController,
              physics: widget.freeze
                  ? const NeverScrollableScrollPhysics()
                  : const BouncingScrollPhysics(),
              children: widget.pages.map((p) => IntroPage(page: p)).toList(),
              onPageChanged: widget.onChange,
            ),
          ),
          Positioned(
            bottom: 74.0,
            left: 16.0,
            right: 16.0,
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    flex: widget.dotsFlex,
                    child: Center(
                      child: widget.isProgress
                          ? DotsIndicator(
                              dotsCount: widget.pages.length,
                              position: _currentPage,
                              decorator: widget.dotsDecorator,
                            )
                          : const SizedBox(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 16.0,
            left: 16.0,
            right: 16.0,
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    flex: widget.nextFlex,
                    child: isLastPage
                        ? doneBtn
                        : widget.showNextButton
                            ? nextBtn
                            : Opacity(opacity: 0.0, child: nextBtn),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
