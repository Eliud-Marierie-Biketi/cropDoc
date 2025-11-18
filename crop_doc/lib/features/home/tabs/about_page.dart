import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'About',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color.fromARGB(255, 63, 238, 87),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'MaizeDoc Overview',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'MaizeDoc is an AI-driven mobile application designed to deliver digital extension officer services to maize farmers, especially smallholder farmers in Kenya. It also supports extension officers by reducing errors in manual diagnosis of maize leaf diseases. The system relies on a ConvDeiT-tiny model— a hybrid vision transformer — trained specifically for maize disease classification.',
              style: GoogleFonts.poppins(fontSize: 15),
            ),
            const SizedBox(height: 16),
            Text(
              'The app enables farmers to capture photos of infected maize leaves, upload them to the cloud, and receive accurate disease predictions. Alongside this, MaizeDoc includes a localized maize disease treatment database, providing farmers with actionable recommendations when a disease is detected.',
              style: GoogleFonts.poppins(fontSize: 15),
            ),
            const SizedBox(height: 16),
            Text(
              'To enhance trust and transparency, MaizeDoc incorporates Explainable AI using LIME, generating heatmaps that highlight image regions contributing most to the model’s prediction.',
              style: GoogleFonts.poppins(fontSize: 15),
            ),
            const SizedBox(height: 16),
            Text(
              'The model is currently trained on six common maize leaf disease and pest categories: fall armyworm, grey leaf spot, northern leaf blight, rust, northern leaf spot, and healthy. Future updates aim to expand the list of detectable diseases.',
              style: GoogleFonts.poppins(fontSize: 15),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
