import 'package:flutter/material.dart';

enum SpeechAnimalCorner { topLeft, topRight, bottomLeft, bottomRight }

class SpeechAnimal {
  final String text;
  final Color textColor;
  final bool isEmoji;
  final SpeechAnimalCorner? speakMessageCorner;
  final Offset? position;

  SpeechAnimal({
    required this.text,
    required this.textColor,
    required this.isEmoji,
    this.speakMessageCorner,
    this.position,
  });
}

class OnboardingData {
  final List<String> leftSideSpeechAnimalTexts;
  final List<String> rightSideSpeechAnimalTexts;
  final List<double> leftSideSpeechAnimalRatios;
  final List<double> rightSideSpeechAnimalRatios;
  final String animalImage;
  final String header;
  final String description;
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;
  final Color animalBackgroundColor;

  OnboardingData({
    required this.leftSideSpeechAnimalTexts,
    required this.rightSideSpeechAnimalTexts,
    required this.leftSideSpeechAnimalRatios,
    required this.rightSideSpeechAnimalRatios,
    required this.animalImage,
    required this.header,
    required this.description,
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
    required this.animalBackgroundColor,
  });
}

// leftSideText: 4-16 char
// rightSideText: 4-8 char
// header: max 36 char
// Description: max 128 char

final List<OnboardingData> mockOnboadingData = [
  OnboardingData(
    leftSideSpeechAnimalTexts: ["🐱", "Health Monitoring"],
    rightSideSpeechAnimalTexts: ["24/7 Vet", "🐶"],
    leftSideSpeechAnimalRatios: [0.1, 0.8],
    rightSideSpeechAnimalRatios: [0.04, 0.6],
    animalImage: 'assets/onboarding/dog_2.png',
    header: "Your Pet's Health Companion",
    description:
        "Connect with expert vets anytime to ensure your pet receives personalized, round-the-clock care.",
    primaryColor: Color(0xFFB8D5B8),
    secondaryColor: Color(0xFFBC412B),
    accentColor: Colors.white,
    animalBackgroundColor: Color(0xffDC602E),
  ),
  OnboardingData(
    leftSideSpeechAnimalTexts: ["🏩", "Pro Grooming"],
    rightSideSpeechAnimalTexts: ["Spa Care", "🐩"],
    leftSideSpeechAnimalRatios: [0.0, 0.9],
    rightSideSpeechAnimalRatios: [0.15, 0.8],
    animalImage: 'assets/onboarding/dog_1.png',
    header: "Grooming & Spa Excellence",
    description:
        "Give your pet a stylish makeover with top-notch grooming and luxurious spa sessions tailored to their needs.",
    primaryColor: Color(0xFFDDDBF1),
    secondaryColor: Color(0xFF383F51),
    accentColor: Color(0xffD1BEB0),
    animalBackgroundColor: Color(0xffAB9F9D),
  ),
  OnboardingData(
    leftSideSpeechAnimalTexts: ["📅", "Easy Booking"],
    rightSideSpeechAnimalTexts: ["Alerts", "⏱️"],
    leftSideSpeechAnimalRatios: [0.1, 0.8],
    rightSideSpeechAnimalRatios: [0.05, 0.5],
    animalImage: 'assets/onboarding/dog_3.png',
    header: "Seamless Scheduling",
    description:
        "Easily book vet visits and grooming sessions while staying updated with timely notifications.",
    primaryColor: Color(0xFFF6F5AE),
    secondaryColor: Color(0xFF564138),
    accentColor: Color(0xffF5F749),
    animalBackgroundColor: Color(0xffF18701),
  ),
  OnboardingData(
    leftSideSpeechAnimalTexts: ["🐈", "Vet Experts"],
    rightSideSpeechAnimalTexts: ["Emergency", "🚑"],
    leftSideSpeechAnimalRatios: [0.02, 0.8],
    rightSideSpeechAnimalRatios: [0.04, 0.7],
    animalImage: 'assets/onboarding/cat_2.png',
    header: "Expert Care on Demand",
    description:
        "Rely on our network of certified professionals for prompt, reliable care—even in emergencies.",
    primaryColor: Color(0xFFE7ECEF),
    secondaryColor: Color(0xFF272932),
    accentColor: Color(0xffD8A47F),
    animalBackgroundColor: Color(0xff0F7173),
  ),
  OnboardingData(
    leftSideSpeechAnimalTexts: ["📊", "Health Records"],
    rightSideSpeechAnimalTexts: ["Vaccines", "📝"],
    leftSideSpeechAnimalRatios: [0.1, 0.8],
    rightSideSpeechAnimalRatios: [0.04, 0.6],
    animalImage: 'assets/onboarding/cat_1.png',
    header: "Track & Thrive",
    description:
        "Keep a detailed record of your pet' s wellness and receive timely reminders to help them live a healthy, happy life.",
    primaryColor: Color(0xFFF5DD90),
    secondaryColor: Color(0xff324376),
    accentColor: Color(0xffF68E5F),
    animalBackgroundColor: Color(0xffF76C5E),
  ),
];
