import 'package:flutter_riverpod/flutter_riverpod.dart';

class IncomeRecord {
  final String id;
  final String sourceName;
  final double amount;
  final String category;
  final DateTime date;
  final String paymentMode;
  final String? notes;
  final bool isRecurring;

  const IncomeRecord({
    required this.id,
    required this.sourceName,
    required this.amount,
    required this.category,
    required this.date,
    required this.paymentMode,
    this.notes,
    this.isRecurring = false,
  });

  IncomeRecord copyWith({
    String? id,
    String? sourceName,
    double? amount,
    String? category,
    DateTime? date,
    String? paymentMode,
    String? notes,
    bool? isRecurring,
  }) {
    return IncomeRecord(
      id: id ?? this.id,
      sourceName: sourceName ?? this.sourceName,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      date: date ?? this.date,
      paymentMode: paymentMode ?? this.paymentMode,
      notes: notes ?? this.notes,
      isRecurring: isRecurring ?? this.isRecurring,
    );
  }
}

class IncomeEntriesNotifier extends StateNotifier<List<IncomeRecord>> {
  IncomeEntriesNotifier() : super([]);

  void addRecord(IncomeRecord record) {
    state = [record, ...state];
  }

  void removeRecord(String id) {
    state = state.where((item) => item.id != id).toList();
  }

  void clear() {
    state = [];
  }
}

final incomeEntriesProvider =
    StateNotifierProvider<IncomeEntriesNotifier, List<IncomeRecord>>((ref) {
  return IncomeEntriesNotifier();
});
