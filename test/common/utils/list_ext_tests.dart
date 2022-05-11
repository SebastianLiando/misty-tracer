import 'package:flutter_test/flutter_test.dart';
import 'package:misty_tracer/common/utils/list_ext.dart';

class _Dummy {
  final String id;
  final int value;

  const _Dummy(this.id, this.value);
}

void main() {
  group("List Extensions", () {
    test("UpdateOnSameId - New Item", () {
      final start = [const _Dummy("1", 10)];
      const newItem = _Dummy("2", 10);
      final actual = start.updateOnSameId([newItem], (p0) => p0.id);

      expect(actual, contains(newItem));
    });

    test("UpdateOnSameId - Same Item", () {
      final start = [const _Dummy("1", 10)];
      const newItem = _Dummy("1", 30);
      final actual = start.updateOnSameId([newItem], (p0) => p0.id);

      expect(actual[0], newItem);
    });
  });
}
