import 'package:flutter/material.dart';
import 'package:misty_tracer/common/widgets/text_icon.dart';
import 'package:misty_tracer/theme/colors.dart';

class VerificationPhotoDetails extends StatelessWidget {
  final String title;
  final String desc;
  final bool isValid;
  final bool fullyVaccinated;

  const VerificationPhotoDetails({
    Key? key,
    required this.title,
    required this.desc,
    required this.isValid,
    required this.fullyVaccinated,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final onPrimary = Theme.of(context).colorScheme.onPrimary;

    return DefaultTextStyle(
      style: TextStyle(color: onPrimary),
      child: Row(
        children: [
          Expanded(child: _buildLeft(context), flex: 6),
          Expanded(child: _buildRight(), flex: 4),
        ],
      ),
    );
  }

  Widget _buildLeft(BuildContext context) {
    final h6 = Theme.of(context).textTheme.headline6;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: h6?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
        ),
        const SizedBox(height: 4),
        Text(desc),
      ],
    );
  }

  IconData get _validityIcon => isValid ? Icons.verified : Icons.warning;

  Color get _validityIconColor => isValid ? acceptChip : rejectChip;

  String get _validityText => isValid ? "Valid" : "Invalid";

  Color get _vaccineColor => fullyVaccinated ? acceptChip : rejectChip;

  String get _vaccineText =>
      fullyVaccinated ? "Fully Vaccinated" : "Not fully vaccinated";

  Widget _buildRight() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextIcon(
          icon: Icon(_validityIcon, color: _validityIconColor),
          text: Text(_validityText),
        ),
        const SizedBox(height: 8),
        TextIcon(
          icon: Icon(Icons.vaccines, color: _vaccineColor),
          text: Expanded(child: Text(_vaccineText)),
        ),
      ],
    );
  }
}
