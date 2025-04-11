import 'package:agro_scan/features/image-analysis/presentation/widgets/image_picker.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: ImagePickerWidget());
  }
}