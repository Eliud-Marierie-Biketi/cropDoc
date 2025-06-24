import 'package:flutter/material.dart';

class HistoryTab extends StatelessWidget {
  const HistoryTab({super.key});

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

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: dummyHistory.length,
      itemBuilder: (context, index) {
        final item = dummyHistory[index];
        return Card(
          child: ListTile(
            leading: Image.asset(item['image']!, width: 50),
            title: Text('${item['crop']} - ${item['disease']}'),
            subtitle: Text('Confidence: ${item['confidence']}'),
            onTap: () {
              // Show details or allow re-analysis
            },
          ),
        );
      },
    );
  }
}
