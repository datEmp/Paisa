import 'package:flutter/material.dart';

import '../../../core/enum/card_type.dart';
import '../../widgets/paisa_chip.dart';

class CardTypeButtons extends StatefulWidget {
  const CardTypeButtons({
    Key? key,
    required this.onSelected,
    required this.selectedCardType,
  }) : super(key: key);

  final Function(CardType) onSelected;
  final CardType selectedCardType;
  @override
  CardTypeButtonsState createState() => CardTypeButtonsState();
}

class CardTypeButtonsState extends State<CardTypeButtons> {
  late CardType selectedType = widget.selectedCardType;

  @override
  void initState() {
    super.initState();
    widget.onSelected(selectedType);
  }

  void _update(CardType type) {
    selectedType = type;
    setState(() {});
    widget.onSelected(type);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: CardType.values.map((type) {
        final isSelected = selectedType == type;
        return PaisaMaterialYouChip(
          title: type.name,
          isSelected: isSelected,
          onPressed: () => _update(type),
        );
      }).toList(),
    );
  }
}
