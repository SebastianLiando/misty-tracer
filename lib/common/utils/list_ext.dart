extension ListExtension<T> on List<T> {
  List<T> updateOnSameId(List<T> updates, String Function(T) getId) {
    // Map item ids to its index
    final idsToIndex = <String, int>{};

    for (int i = 0; i < length; i++) {
      final id = getId(this[i]);
      idsToIndex[id] = i;
    }

    // Update
    final updated = List.of(this);
    for (final itemUpdate in updates) {
      final targetId = getId(itemUpdate);
      final targetIndex = idsToIndex[targetId];

      if (targetIndex != null) {
        // Update existing data
        updated[targetIndex] = itemUpdate;
      } else {
        // Insert new data
        updated.add(itemUpdate);
      }
    }

    return updated;
  }
}
