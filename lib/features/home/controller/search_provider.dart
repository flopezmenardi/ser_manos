import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

final debouncedSearchQueryProvider =
    StateNotifierProvider<DebouncedSearchNotifier, String>((ref) {
      return DebouncedSearchNotifier(ref);
    });

class DebouncedSearchNotifier extends StateNotifier<String> {
  DebouncedSearchNotifier(this.ref) : super('');

  final Ref ref;
  Timer? _debounce;

  void updateQuery(String newQuery) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      state = newQuery.trim();
    });
  }

  void submitNow(String query) {
    _debounce?.cancel();
    state = query.trim();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
