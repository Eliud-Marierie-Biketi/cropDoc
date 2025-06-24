import 'package:flutter/material.dart';

class SampleTab extends StatelessWidget {
  const SampleTab({super.key});

  @override
  Widget build(BuildContext context) {
    final sampleImages = List.generate(
      6,
      (i) => 'assets/dummy_samples/sample_$i.jpg',
    );

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: sampleImages.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            // Simulate image scan
          },
          child: Image.asset(sampleImages[index], fit: BoxFit.cover),
        );
      },
    );
  }
}
