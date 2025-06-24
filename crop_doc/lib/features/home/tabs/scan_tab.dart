import 'dart:io';
import 'package:crop_doc/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:crop_doc/l10n/app_localizations.dart';
import 'package:crop_doc/core/database/app_database.dart';

class ScanTab extends HookConsumerWidget {
  const ScanTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final db = ref.read(appDatabaseProvider); // Provide AppDatabase instance

    final imageFile = useState<File?>(null);
    final isProcessing = useState(false);

    final crops = useState<List<Crop>>([]);
    final selectedCrop = useState<Crop?>(null);

    // Load crops from local database
    useEffect(() {
      Future.microtask(() async {
        final allCrops = await db.getCrops();
        crops.value = allCrops;
        if (allCrops.isNotEmpty) {
          selectedCrop.value = allCrops.first;
        }
      });
      return null;
    }, []);

    Future<void> pickImage(ImageSource source) async {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: source);
      if (picked != null) {
        imageFile.value = File(picked.path);
      }
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          DropdownButtonFormField<Crop>(
            value: selectedCrop.value,
            decoration: InputDecoration(labelText: t.cropLabel),
            items: crops.value.map((crop) {
              return DropdownMenuItem(value: crop, child: Text(crop.name));
            }).toList(),
            onChanged: (value) => selectedCrop.value = value,
          ),
          const SizedBox(height: 16),
          if (imageFile.value != null)
            Image.file(imageFile.value!, height: 200)
          else
            const Placeholder(fallbackHeight: 200),

          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton.icon(
                onPressed: () => pickImage(ImageSource.camera),
                icon: const Icon(Icons.camera_alt),
                label: Text(t.camera),
              ),
              ElevatedButton.icon(
                onPressed: () => pickImage(ImageSource.gallery),
                icon: const Icon(Icons.photo_library),
                label: Text(t.gallery),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: imageFile.value == null || isProcessing.value
                ? null
                : () {
                    isProcessing.value = true;
                    Future.delayed(const Duration(seconds: 2), () {
                      isProcessing.value = false;
                      // Navigate to result screen
                      // You can pass selectedCrop.value to results
                    });
                  },
            child: isProcessing.value
                ? const CircularProgressIndicator()
                : Text(t.analyze),
          ),
        ],
      ),
    );
  }
}
