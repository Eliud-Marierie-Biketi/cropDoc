import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with real Drift data
    final dummyHistory = List.generate(
      5,
      (i) => {
        'crop': 'Maize',
        'disease': 'Leaf Blight',
        'confidence': '93%',
        'image': 'assets/dummy_samples/sample_$i.jpg',
      },
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Detection History'), centerTitle: true),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: dummyHistory.length,
        itemBuilder: (context, index) {
          final item = dummyHistory[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: Image.asset(
                item['image']!,
                width: 50,
                fit: BoxFit.cover,
              ),
              title: Text('${item['crop']} - ${item['disease']}'),
              subtitle: Text('Confidence: ${item['confidence']}'),
              onTap: () {
                // Navigate to details page or perform action
              },
            ),
          );
        },
      ),
    );
  }
}
