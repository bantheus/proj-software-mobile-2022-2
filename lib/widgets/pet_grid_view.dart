import 'package:flutter/material.dart';
import 'package:miaudote/models/style-card.dart';

class PetsGridView extends StatelessWidget {
  final List<Widget> pets;
  final bool isBack;

  const PetsGridView({
    super.key,
    required this.pets,
    required this.isBack,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: GridView.count(
        crossAxisCount: isBack ? 1 : 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        children: pets,
      ),
    );
  }
}
