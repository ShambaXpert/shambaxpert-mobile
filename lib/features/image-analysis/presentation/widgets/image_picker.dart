import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:device_info_plus/device_info_plus.dart';

class ImagePickerWidget extends StatefulWidget {
  final Function(File)? onImageSelected;

  const ImagePickerWidget({super.key, this.onImageSelected});

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  File? imageFile;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 50),
          imageFile == null
              ? Container(
                height: 300,
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.add_photo_alternate,
                  size: 100,
                  color: Colors.grey,
                ),
              )
              : ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  imageFile!,
                  height: 300,
                  width: 300,
                  fit: BoxFit.cover,
                ),
              ),
          const SizedBox(height: 50),
          ElevatedButton(
            onPressed: () async {
              bool permissionsGranted = await _requestPermissions();
              if (permissionsGranted) {
                _showImagePickerOptions(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text(
                      "Permission denied. Please enable camera and storage permissions in app settings.",
                    ),
                    duration: const Duration(seconds: 4),
                    action: SnackBarAction(
                      label: 'Settings',
                      onPressed: openAppSettings,
                    ),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text("Pick Image", style: TextStyle(fontSize: 16)),
          ),
          if (imageFile != null)
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    imageFile = null;
                  });
                },
                child: const Text("Remove Image"),
              ),
            ),
        ],
      ),
    );
  }

  Future<bool> _requestPermissions() async {
    // For Android 13+, we need different permissions
    if (Platform.isAndroid) {
      int sdkVersion = int.parse(await _getAndroidVersion());

      // Request camera permission
      if (await Permission.camera.status.isDenied) {
        await Permission.camera.request();
      }

      // Check SDK version for storage permissions
      if (sdkVersion >= 33) {
        // Android 13+ requires specific media permissions
        if (await Permission.photos.status.isDenied) {
          await Permission.photos.request();
        }
      } else {
        // Below Android 13 uses storage permissions
        if (await Permission.storage.status.isDenied) {
          await Permission.storage.request();
        }
      }

      // Check if permissions are granted
      bool cameraGranted = await Permission.camera.status.isGranted;
      bool storageGranted =
          sdkVersion >= 33
              ? await Permission.photos.status.isGranted
              : await Permission.storage.status.isGranted;

      return cameraGranted && storageGranted;
    } else {
      // For iOS, permissions are handled differently through the plugins
      return true;
    }
  }

  Future<String> _getAndroidVersion() async {
    if (Platform.isAndroid) {
      return (await DeviceInfoPlugin().androidInfo).version.sdkInt.toString();
    }
    return '0';
  }

  void _showImagePickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (builder) {
        return Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Choose an option",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildOptionButton(
                    icon: Icons.photo_library,
                    label: "Gallery",
                    onTap: () {
                      _pickImageFromGallery();
                      Navigator.pop(context);
                    },
                  ),
                  _buildOptionButton(
                    icon: Icons.camera_alt,
                    label: "Camera",
                    onTap: () {
                      _pickImageFromCamera();
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOptionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: 120,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Icon(icon, size: 50, color: Colors.blue),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImageFromGallery() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (pickedFile != null) {
      _cropImage(File(pickedFile.path));
    }
  }

  Future<void> _pickImageFromCamera() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
    );

    if (pickedFile != null) {
      _cropImage(File(pickedFile.path));
    }
  }

  Future<void> _cropImage(File imgFile) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imgFile.path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 90,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Colors.blue,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9,
          ],
        ),
        IOSUiSettings(
          title: 'Crop Image',
          doneButtonTitle: 'Done',
          cancelButtonTitle: 'Cancel',
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9,
          ],
        ),
      ],
    );

    if (croppedFile != null) {
      setState(() {
        imageFile = File(croppedFile.path);

        // If parent widget needs the selected image
        if (widget.onImageSelected != null) {
          widget.onImageSelected!(imageFile!);
        }
      });
    }
  }
}
