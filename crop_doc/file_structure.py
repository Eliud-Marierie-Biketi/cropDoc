import os

structure = {
    "lib": [
        "main.dart",
        "app.dart",
        "core/database/app_database.dart",
        "core/database/daos/.gitkeep",
        "core/database/models/.gitkeep",
        "core/ml/disease_classifier.dart",
        "core/network/sync_service.dart",
        "core/services/image_service.dart",
        "core/services/permission_service.dart",
        "core/constants/app_strings.dart",
        "core/utils/utils.dart",
        "features/auth/data/.gitkeep",
        "features/auth/logic/.gitkeep",
        "features/auth/presentation/.gitkeep",
        "features/profile/.gitkeep",
        "features/disease_detection/logic/.gitkeep",
        "features/disease_detection/data/.gitkeep",
        "features/disease_detection/presentation/.gitkeep",
        "features/result/.gitkeep",
        "features/image_samples/.gitkeep",
        "features/sync/.gitkeep",
        "shared/providers/.gitkeep",
        "shared/theme/.gitkeep",
        "shared/widgets/.gitkeep"
    ],
    "assets": [
        "tflite/maize_disease_model.tflite",
        "dummy_samples/.gitkeep",
        "images/.gitkeep"
    ],
    "test": [
        ".gitkeep"
    ],
    ".": [
        "pubspec.yaml"
    ]
}

def create_structure(base_path="."):
    for root_folder, paths in structure.items():
        for path in paths:
            full_path = os.path.join(base_path, root_folder, path)
            dir_path = os.path.dirname(full_path)
            os.makedirs(dir_path, exist_ok=True)
            if not path.endswith('/'):
                # Touch file (skip if it's a .gitkeep placeholder to keep folder empty)
                if not os.path.exists(full_path):
                    with open(full_path, 'w') as f:
                        if path.endswith('.dart'):
                            f.write(f"// {os.path.basename(full_path)}\n")
                        elif path == "pubspec.yaml":
                            f.write("name: your_app_name\n")
                        elif path.endswith('.tflite'):
                            pass  # leave binary files empty
                        else:
                            f.write("")
    print("✅ Flutter folder structure created successfully.")

if __name__ == "__main__":
    create_structure()
