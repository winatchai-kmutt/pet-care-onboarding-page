import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pet_care_onboarding/models.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final animalImageKey = GlobalKey();
  final animalSpeechBoxKey = GlobalKey();
  final detailTextsKey = GlobalKey();
  late OnboardingController controller;
  late PageController animalImagePageController;
  late PageController animalSpeechPageController;
  late PageController detailTextsPageController;

  @override
  void initState() {
    super.initState();
    controller = OnboardingController();
    animalImagePageController = PageController();
    animalSpeechPageController = PageController();
    detailTextsPageController = PageController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initialize(
        animalImageKey: animalImageKey,
        animalSpeechBoxKey: animalSpeechBoxKey,
        detailTextsKey: detailTextsKey,
        onboardingData: mockOnboadingData,
        animalImagePageController: animalImagePageController,
        animalSpeechPageController: animalSpeechPageController,
        detailTextsPageController: detailTextsPageController,
      );
    });
  }

  @override
  void dispose() {
    controller.dispose();
    animalImagePageController.dispose();
    animalSpeechPageController.dispose();
    detailTextsPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ValueListenableBuilder(
            valueListenable: controller,
            builder: (context, value, _) {
              return AnimatedContainer(
                duration: Duration(milliseconds: 500),
                color: mockOnboadingData[value.currentPageIndex].primaryColor,
              );
            },
          ),
          SafeArea(
            child: Column(
              children: [
                ValueListenableBuilder(
                  valueListenable: controller,
                  builder: (context, value, _) {
                    return TitleText(
                      text: "Pet care",
                      color:
                          mockOnboadingData[value.currentPageIndex]
                              .secondaryColor,
                    );
                  },
                ),
                SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 72),
                  child: ValueListenableBuilder(
                    valueListenable: controller,
                    builder: (context, value, child) {
                      return AnimatedContainer(
                        duration: Duration(milliseconds: 500),
                        key: animalImageKey,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          color:
                              mockOnboadingData[value.currentPageIndex]
                                  .animalBackgroundColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: child,
                      );
                    },
                    child: AspectRatio(
                      aspectRatio: 9 / 10,
                      child: PageView.builder(
                        controller: animalImagePageController,
                        itemCount: mockOnboadingData.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Image(
                            image: AssetImage(
                              mockOnboadingData[index].animalImage,
                            ),
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 32),
                ValueListenableBuilder(
                  valueListenable: controller,
                  builder: (context, value, _) {
                    return PageIndicator(
                      pageLength: mockOnboadingData.length,
                      previousPageIndex: value.previousPageIndex,
                      currentPageIndex: value.currentPageIndex,
                      color:
                          mockOnboadingData[value.currentPageIndex]
                              .secondaryColor,
                    );
                  },
                ),
                SizedBox(height: 32),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 180,
                  key: detailTextsKey,
                  child: PageView.builder(
                    allowImplicitScrolling: true,
                    controller: detailTextsPageController,
                    itemCount: mockOnboadingData.length,
                    itemBuilder: (context, index) {
                      final data = mockOnboadingData[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: DetailTexts(
                          header: data.header,
                          description: data.description,
                          color: data.secondaryColor,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          ValueListenableBuilder(
            valueListenable: controller,
            builder: (context, value, _) {
              return Visibility(
                key: animalSpeechBoxKey,
                visible: value.isInitialized,
                replacement: Container(),
                child: PageView.builder(
                  controller: animalSpeechPageController,
                  itemCount: mockOnboadingData.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        ...value.speechAnimalsPages[index].map((el) {
                          return AnimalSpeechBox(
                            isEmoji: el.isEmoji,
                            xPoint: el.position!.dx,
                            yPoint: el.position!.dy,
                            text: el.text,
                            corner: el.speakMessageCorner,
                            textColor: el.textColor,
                            backgroundColor:
                                mockOnboadingData[index].secondaryColor,
                          );
                        }),
                      ],
                    );
                  },
                ),
              );
            },
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ValueListenableBuilder(
                valueListenable: controller,
                builder: (context, value, _) {
                  final data = mockOnboadingData[value.currentPageIndex];
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SignUpButton(
                        onTap: () {},
                        backgroudColor: data.secondaryColor,
                        spashColor: data.primaryColor,
                        textColor: data.accentColor,
                      ),
                      SizedBox(height: 16),
                      LoginTextButton(onTap: () {}, color: data.secondaryColor),
                      SizedBox(height: 32),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PageIndicator extends StatelessWidget {
  final int pageLength;
  final int? previousPageIndex;
  final int? currentPageIndex;
  final Color color;
  const PageIndicator({
    super.key,
    required this.pageLength,
    required this.previousPageIndex,
    required this.currentPageIndex,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ...List.generate(pageLength, (index) {
          if (index == 0 && previousPageIndex == null) {
            return TweenAnimationBuilder(
              tween: Tween<double>(begin: 5, end: 30),
              duration: Duration(milliseconds: 500),
              builder: (context, animateValue, _) {
                return Container(
                  width: animateValue,
                  height: 5,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(30),
                  ),
                );
              },
            );
          }
          if (index == currentPageIndex) {
            return TweenAnimationBuilder(
              tween: Tween<double>(begin: 5, end: 30),
              duration: Duration(milliseconds: 500),
              builder: (context, animateValue, _) {
                return Container(
                  width: animateValue,
                  height: 5,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(30),
                  ),
                );
              },
            );
          }
          if (index == previousPageIndex) {
            return TweenAnimationBuilder(
              tween: Tween<double>(begin: 30, end: 5),
              duration: Duration(milliseconds: 500),
              builder: (context, animateValue, _) {
                return Container(
                  width: animateValue,
                  height: 5,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(30),
                  ),
                );
              },
            );
          }
          return Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          );
        }),
      ],
    );
  }
}

class DetailTexts extends StatelessWidget {
  final String header;
  final String description;
  final Color color;
  const DetailTexts({
    super.key,
    required this.header,
    required this.description,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          header,
          textAlign: TextAlign.center,
          style: GoogleFonts.oswald(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        SizedBox(height: 8),
        Text(
          description,
          style: GoogleFonts.notoSans(
            fontSize: 16,
            color: color.withValues(alpha: 0.7),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class LoginTextButton extends StatelessWidget {
  final VoidCallback onTap;
  final Color color;
  const LoginTextButton({super.key, required this.onTap, required this.color});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Text(
        "Login",
        textAlign: TextAlign.center,
        style: GoogleFonts.oswald(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}

class SignUpButton extends StatelessWidget {
  final VoidCallback onTap;
  final Color backgroudColor;
  final Color spashColor;
  final Color textColor;
  const SignUpButton({
    super.key,
    required this.onTap,
    required this.backgroudColor,
    required this.spashColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: spashColor,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: backgroudColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(3, 2),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Text(
          "SignUp",
          textAlign: TextAlign.center,
          style: GoogleFonts.oswald(
            fontSize: 16,
            letterSpacing: 1,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
    );
  }
}

class TitleText extends StatelessWidget {
  final String text;
  final Color color;
  const TitleText({super.key, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.oswald(
        fontSize: 32,
        letterSpacing: 2,
        fontWeight: FontWeight.bold,
        color: color,
      ),
    );
  }
}

class OnboardingValue {
  final List<List<SpeechAnimal>> speechAnimalsPages;
  final bool isInitialized;
  final int currentPageIndex;
  final int? previousPageIndex;
  OnboardingValue({
    required this.speechAnimalsPages,
    required this.isInitialized,
    required this.currentPageIndex,
    required this.previousPageIndex,
  });

  OnboardingValue copywith({
    speechAnimalsPages,
    isInitialized,
    currentPageIndex,
    previousPageIndex,
  }) {
    return OnboardingValue(
      speechAnimalsPages: speechAnimalsPages ?? this.speechAnimalsPages,
      isInitialized: isInitialized ?? this.isInitialized,
      currentPageIndex: currentPageIndex ?? this.currentPageIndex,
      previousPageIndex: previousPageIndex ?? this.previousPageIndex,
    );
  }
}

class OnboardingController extends ValueNotifier<OnboardingValue> {
  double _previousPageOffset = 0.0;
  OnboardingController()
    : super(
        OnboardingValue(
          speechAnimalsPages: [],
          isInitialized: false,
          currentPageIndex: 0,
          previousPageIndex: null,
        ),
      );

  void initialize({
    required GlobalKey<State<StatefulWidget>> animalImageKey,
    required GlobalKey<State<StatefulWidget>> animalSpeechBoxKey,
    required GlobalKey<State<StatefulWidget>> detailTextsKey,
    required List<OnboardingData> onboardingData,
    required PageController animalImagePageController,
    required PageController animalSpeechPageController,
    required PageController detailTextsPageController,
  }) {
    final RenderBox animalImageBox =
        animalImageKey.currentContext!.findRenderObject() as RenderBox;
    final RenderBox animalSpeechBox =
        animalSpeechBoxKey.currentContext!.findRenderObject() as RenderBox;
    final RenderBox detailTextsBox =
        detailTextsKey.currentContext!.findRenderObject() as RenderBox;

    final animalImagePosition = animalImageBox.localToGlobal(Offset.zero);
    final animalImageSize = animalImageBox.size;
    final animalSpeechSize = animalSpeechBox.size;
    final detailTextsSize = detailTextsBox.size;

    final List<List<SpeechAnimal>> speechAnimalsPages = [];
    for (OnboardingData data in onboardingData) {
      speechAnimalsPages.add([
        ..._createAnimalMessage(
          texts: data.leftSideSpeechAnimalTexts,
          textColor: data.primaryColor,
          position: animalImagePosition,
          size: animalImageSize,
          ratios: data.leftSideSpeechAnimalRatios,
          isRightSide: false,
        ),
        ..._createAnimalMessage(
          texts: data.rightSideSpeechAnimalTexts,
          textColor: data.primaryColor,
          position: animalImagePosition,
          size: animalImageSize,
          ratios: data.rightSideSpeechAnimalRatios,
          isRightSide: true,
        ),
      ]);
    }
    value = value.copywith(
      speechAnimalsPages: speechAnimalsPages,
      isInitialized: true,
    );

    animalSpeechPageController.addListener(() {
      final currentAnimalSpeechOffset = animalSpeechPageController.offset;
      if (_previousPageOffset == currentAnimalSpeechOffset) return;

      final duringPageIndex = animalSpeechPageController.page;
      if (duringPageIndex == null) return;

      // Fix: There is some delay or the color changes slowly when switching pages.
      // right slide, greater then 60%
      if (duringPageIndex - value.currentPageIndex > 0.5) {
        value = value.copywith(
          previousPageIndex: value.currentPageIndex,
          currentPageIndex: value.currentPageIndex + 1,
        );
        // left slide, less then 60%
      } else if (value.currentPageIndex - duringPageIndex > 0.5) {
        value = value.copywith(
          previousPageIndex: value.currentPageIndex,
          currentPageIndex: value.currentPageIndex - 1,
        );
      }

      final animalSpeechOffsetPerWidth =
          currentAnimalSpeechOffset / animalSpeechSize.width;
      animalImagePageController.jumpTo(
        animalSpeechOffsetPerWidth * animalImageSize.width,
      );
      detailTextsPageController.jumpTo(
        animalSpeechOffsetPerWidth * detailTextsSize.width,
      );
      _previousPageOffset = currentAnimalSpeechOffset;
    });
  }

  List<SpeechAnimal> _createAnimalMessage({
    required List<String> texts,
    required Color textColor,
    required Offset position,
    required Size size,
    required List<double> ratios,
    required bool isRightSide,
  }) {
    List<SpeechAnimal> animalMessages = [];
    for (final entry in texts.asMap().entries) {
      double x;
      final index = entry.key;

      final isEmoji = entry.value.length == 2;
      if (isEmoji) {
        // -+ 24 If text is Emoji
        x = position.dx - 24 + (isRightSide ? size.width : 0);
      } else {
        // -+ 48 from Parent padding animal Image If text
        x = position.dx - 48 + (isRightSide ? size.width : 0);
      }

      final topY = position.dy;
      final stepY = size.height * ratios[index];
      final middleY = topY + stepY;
      SpeechAnimalCorner? corner;
      if (index == texts.length - 1) {
        if (isRightSide) {
          corner = SpeechAnimalCorner.topLeft;
        } else {
          corner = SpeechAnimalCorner.topRight;
        }
      } else {
        if (isRightSide) {
          corner = SpeechAnimalCorner.bottomLeft;
        } else {
          corner = SpeechAnimalCorner.bottomRight;
        }
      }
      animalMessages.add(
        SpeechAnimal(
          text: entry.value,
          textColor: textColor,
          isEmoji: isEmoji,
          position: Offset(x, middleY),
          speakMessageCorner: corner,
        ),
      );
    }
    return animalMessages;
  }
}

class AnimalSpeechBox extends StatelessWidget {
  final bool isEmoji;
  final double xPoint;
  final double yPoint;
  final String text;
  final Color textColor;
  final Color backgroundColor;
  final SpeechAnimalCorner? corner;

  AnimalSpeechBox({
    super.key,
    required this.isEmoji,
    required this.xPoint,
    required this.yPoint,
    required this.text,
    required this.textColor,
    required this.backgroundColor,
    this.corner,
  });

  final Map<SpeechAnimalCorner, BorderRadiusGeometry> cornerWithBorderRadius = {
    SpeechAnimalCorner.topRight: BorderRadius.only(
      topLeft: Radius.circular(12),
      bottomLeft: Radius.circular(12),
      bottomRight: Radius.circular(12),
    ),
    SpeechAnimalCorner.bottomRight: BorderRadius.only(
      topLeft: Radius.circular(12),
      topRight: Radius.circular(12),
      bottomLeft: Radius.circular(12),
    ),
    SpeechAnimalCorner.topLeft: BorderRadius.only(
      topRight: Radius.circular(12),
      bottomLeft: Radius.circular(12),
      bottomRight: Radius.circular(12),
    ),
    SpeechAnimalCorner.bottomLeft: BorderRadius.only(
      topLeft: Radius.circular(12),
      topRight: Radius.circular(12),
      bottomRight: Radius.circular(12),
    ),
  };
  @override
  Widget build(BuildContext context) {
    BorderRadiusGeometry borderRadius = BorderRadius.all(Radius.circular(12));
    borderRadius =
        corner != null ? cornerWithBorderRadius[corner]! : borderRadius;
    return Positioned(
      left: xPoint,
      top: yPoint,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: isEmoji ? null : borderRadius,
          shape: isEmoji ? BoxShape.circle : BoxShape.rectangle,
        ),
        child: Text(
          text,
          style: GoogleFonts.notoSans(
            color: textColor,
            fontSize: isEmoji ? 32 : 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
