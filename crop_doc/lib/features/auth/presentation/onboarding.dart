// ignore: library_prefixes
import 'dart:math' as Math;
import 'package:crop_doc/core/providers/locale_provider.dart';
import 'package:crop_doc/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:go_router/go_router.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _onboardingData = [
    {
      'title': 'welcomeTitle',
      'description': 'welcomeDescription',
      'icon': LucideIcons.scan,
      'color': Colors.blue,
    },
    {
      'title': 'diseaseDetection',
      'description': 'diseaseDetectionDesc',
      'icon': LucideIcons.bug,
      'color': Colors.green,
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _continue() {
    context.go('/registration');
  }

  Widget _buildBackground() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(
                0.5 + 0.2 * Math.sin(_animationController.value * 3.14),
                0.5 + 0.2 * Math.cos(_animationController.value * 3.14),
              ),
              radius: 1.2,
              colors: [
                Colors.lightBlue.shade100.withAlpha(204),
                Colors.green.shade100.withAlpha(204),
                Colors.yellow.shade100.withAlpha(204),
                Colors.orange.shade100.withAlpha(204),
              ],
              stops: const [0.1, 0.4, 0.7, 1.0],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFeatureCard(
    Map<String, dynamic> data,
    AppLocalizations t,
    int index,
  ) {
    return GlassmorphicContainer(
      width: double.infinity,
      height: 200,
      borderRadius: 24,
      blur: 20,
      border: 1,
      linearGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.white.withAlpha(77), Colors.white.withAlpha(25)],
      ),
      borderGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.white.withAlpha(127), Colors.white.withAlpha(51)],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: data['color'].withAlpha(50),
              shape: BoxShape.circle,
            ),
            child: Icon(data['icon'], size: 40, color: data['color']),
          ).animate(delay: (200 * index).ms).scale().fadeIn(),
          const SizedBox(height: 20),
          Text(
            t.translate(data['title']),
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
          ).animate(delay: (300 * index).ms).slideY(begin: 0.5, end: 0),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              t.translate(data['description']),
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
          ).animate(delay: (400 * index).ms).fadeIn(),
        ],
      ),
    );
  }

  Widget _buildPagination() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _onboardingData.length,
        (index) => AnimatedContainer(
          duration: 300.ms,
          width: _currentPage == index ? 24 : 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: _currentPage == index
                ? Colors.green.shade700
                : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    ).animate(delay: 500.ms).fadeIn();
  }

  Widget _buildLanguagePicker() {
    final localeState = ref.watch(localeProvider);
    final String? localeCode = localeState.locale?.languageCode;

    // Ensure a default if null
    final String selected = localeCode ?? 'en';

    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.only(top: 24, right: 24),
        child: DropdownButton<String>(
          value: selected,
          underline: const SizedBox(),
          dropdownColor: Colors.white,
          icon: const Icon(Icons.language, color: Colors.black),
          onChanged: (val) {
            if (val != null) {
              ref.read(localeProvider.notifier).setLocale(Locale(val));
            }
          },
          items: const [
            DropdownMenuItem(value: 'en', child: Text("English")),
            DropdownMenuItem(value: 'sw', child: Text("Kiswahili")),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          _buildLanguagePicker(),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child:
                      Text(
                            t.appTitle,
                            style: GoogleFonts.poppins(
                              fontSize: 36,
                              fontWeight: FontWeight.w800,
                              color: Colors.green.shade800,
                              letterSpacing: 1.2,
                            ),
                          )
                          .animate(
                            onPlay: (controller) =>
                                controller.repeat(reverse: true),
                          )
                          .shimmer(
                            delay: 1.seconds,
                            duration: 2.seconds,
                            color: Colors.green.shade100,
                          )
                          .slideY(begin: -0.5, end: 0),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: size.height * 0.55,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _onboardingData.length,
                    onPageChanged: (int page) {
                      setState(() => _currentPage = page);
                    },
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: _buildFeatureCard(
                          _onboardingData[index],
                          t,
                          index,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                _buildPagination(),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 40,
                    left: 24,
                    right: 24,
                  ),
                  child:
                      ElevatedButton.icon(
                            icon: const Icon(LucideIcons.arrowRight),
                            label: Text(
                              t.continueButton,
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            onPressed: _continue,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green.shade700,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                vertical: 18,
                                horizontal: 32,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 8,
                              shadowColor: Colors.green.shade200,
                            ),
                          )
                          .animate(delay: 600.ms)
                          .scaleXY(
                            begin: 0.8,
                            end: 1,
                            curve: Curves.elasticOut,
                          ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Extend AppLocalizations for custom translation
extension LocalizationExtension on AppLocalizations {
  String translate(String key) {
    switch (key) {
      case 'welcomeTitle':
        return welcomeTitle;
      case 'welcomeDescription':
        return welcomeDescription;
      case 'diseaseDetection':
        return diseaseDetection;
      case 'diseaseDetectionDesc':
        return diseaseDetectionDesc;
      case 'cropManagement':
        return cropManagement;
      case 'cropManagementDesc':
        return cropManagementDesc;
      case 'continueButton':
        return continueButton;
      case 'appTitle':
        return appTitle;
      default:
        return key;
    }
  }
}
