import 'package:flutter/material.dart';

enum SyncStatus { unsynced, sync, draft }

extension ColorSync on SyncStatus? {
  Color color(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    switch (this) {
      case SyncStatus.unsynced:
        return Colors.amber.shade100;
      case SyncStatus.sync:
        return Colors.greenAccent.shade100;
      default:
        return isDark ? Colors.grey.shade700 : Colors.grey.shade400;
    }
  }

  Color textColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    switch (this) {
      case SyncStatus.unsynced:
        return Colors.amber.shade900;
      case SyncStatus.sync:
        return Colors.green.shade700;
      default:
        return isDark ? Colors.white : Colors.black87;
    }
  }
}

extension ParseToString on SyncStatus {
  String toShortString() {
    switch (this) {
      case SyncStatus.unsynced:
        return 'Unsynced';
      case SyncStatus.sync:
        return 'Synced';
      default:
        return 'Draft';
    }
  }
}
