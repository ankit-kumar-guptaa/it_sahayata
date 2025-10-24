import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../config/routes.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController pageController = PageController();
  int page = 0;

  final List<Map<String, String>> slides = [
    {
      'image': 'assets/images/onboarding1.png',
      'title': 'Instant IT Support',
      'desc': 'Raise your IT issue in seconds and get instant help!',
    },
    {
      'image': 'assets/images/onboarding2.png',
      'title': 'Chat with Experts',
      'desc': 'Get real-time updates & talk directly to support agents.',
    },
    {
      'image': 'assets/images/onboarding3.png',
      'title': 'Track & Rate',
      'desc': 'Track issue status, upload screenshots and rate resolutions.',
    },
    {
      'image': 'assets/images/onboarding4.png',
      'title': '24x7 Assistance',
      'desc': 'Anytime, anywhere IT help – always at your service!',
    },
  ];

  void _finishOnboarding() {
    GetStorage().write('onboarding_seen', true);
    Get.offAllNamed(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              controller: pageController,
              onPageChanged: (i) => setState(() => page = i),
              itemCount: slides.length,
              itemBuilder: (context, i) {
                final slide = slides[i];
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 4,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        child: Image.asset(slide['image']!,
                            fit: BoxFit.contain, height: 250),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          Text(slide['title']!,
                              style: const TextStyle(
                                  fontSize: 26, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Text(slide['desc']!,
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.black54),
                                textAlign: TextAlign.center),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
            // Dots indicator
            Positioned(
              bottom: 90,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                    slides.length,
                    (i) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: i == page ? 22 : 9,
                          height: 9,
                          decoration: BoxDecoration(
                            color: i == page
                                ? Colors.blue
                                : Colors.blue.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(40),
                          ),
                        )),
              ),
            ),
            // NEXT/SKIP BUTTONS
            Positioned(
              right: 16,
              bottom: 28,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: StadiumBorder(),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 14)),
                child: Text(page == slides.length - 1 ? "Get Started" : "Next"),
                onPressed: () {
                  if (page == slides.length - 1) {
                    _finishOnboarding();
                  } else {
                    pageController.animateToPage(
                      page + 1,
                      duration: Duration(milliseconds: 400),
                      curve: Curves.easeOut,
                    );
                  }
                },
              ),
            ),
            Positioned(
              left: 16,
              top: 16,
              child: TextButton(
                onPressed: _finishOnboarding,
                child: const Text("Skip", style: TextStyle(fontSize: 15)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
