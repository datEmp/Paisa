import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../widgets/paisa_card.dart';
import '../data.dart';

class LocaleGridView extends StatefulWidget {
  const LocaleGridView({
    Key? key,
    required this.locales,
    required this.onPressed,
    required this.crossAxisCount,
  }) : super(key: key);

  final List<CountryMap> locales;
  final Function(Locale) onPressed;
  final int crossAxisCount;

  @override
  State<LocaleGridView> createState() => _LocaleGridViewState();
}

class _LocaleGridViewState extends State<LocaleGridView> {
  CountryMap? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.only(bottom: 82, left: 8, right: 8),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.crossAxisCount,
        childAspectRatio: 16 / 12,
      ),
      shrinkWrap: true,
      itemCount: widget.locales.length,
      itemBuilder: (_, index) {
        final map = widget.locales[index];
        final format = NumberFormat.compactSimpleCurrency(
          locale: widget.locales[index].locale.toString(),
        );

        return PaisaCard(
          color: Theme.of(context).colorScheme.surface,
          shape: selectedIndex == map
              ? RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                  side: BorderSide(
                    width: 2,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                )
              : null,
          child: InkWell(
            onTap: () {
              setState(() {
                selectedIndex = map;
              });
              widget.onPressed(map.locale);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    format.currencySymbol,
                    style: GoogleFonts.manrope(
                      textStyle: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                ),
                ListTile(
                  title: Text(map.name),
                  subtitle: Text(
                    '${format.currencyName}',
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
