import 'package:flutter/material.dart';

class CarouselIndicator extends StatelessWidget {
  final int count;
  final int selected;
  final void Function(int index) onTap;

  final Color? selectedColor;
  final Color? disabledColor;

  const CarouselIndicator({
    Key? key,
    required this.count,
    this.selected = 0,
    required this.onTap,
    this.selectedColor,
    this.disabledColor,
  })  : assert(
          selected <= count,
          "The selected index must be less than or equal to count!",
        ),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        count,
        (index) {
          final isSelected = selected == index;

          return GestureDetector(
            onTap: !isSelected ? () => onTap(index) : null,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: CircleAvatar(
                radius: 6,
                backgroundColor: isSelected
                    ? selectedColor ?? Theme.of(context).colorScheme.primary
                    : disabledColor ?? Theme.of(context).disabledColor,
              ),
            ),
          );
        },
      ),
    );
  }
}
