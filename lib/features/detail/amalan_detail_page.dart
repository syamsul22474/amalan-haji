import 'package:flutter/material.dart';
import '../../core/models/amalan.dart';

class AmalanDetailPage extends StatelessWidget {
  final Amalan amalan;

  const AmalanDetailPage({super.key, required this.amalan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(amalan.nama),
      ),
      body: Center(
        child: Text(amalan.deskripsi),
      ),
    );
  }
}
