import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PetsGridView extends StatelessWidget {
  final List<Widget> pets;

  const PetsGridView({
    super.key,
    required this.pets,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: GridView.count(
        crossAxisSpacing: 24,
        mainAxisSpacing: 24,
        crossAxisCount: 1,
        children: pets,
      ),
    );
  }
}
