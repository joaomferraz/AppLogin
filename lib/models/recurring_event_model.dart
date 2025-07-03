class RecurringEventModel {
  final int? id;
  final String title;
  final DateTime startDate;
  final DateTime endDate;
  final List<int> daysOfWeek; // 1 para Segunda, 7 para Domingo

  RecurringEventModel({
    this.id,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.daysOfWeek,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      // Salvaremos a lista de inteiros como uma string separada por vírgulas
      'daysOfWeek': daysOfWeek.join(','),
    };
  }

  static RecurringEventModel fromMap(Map<String, dynamic> map) {
    return RecurringEventModel(
      id: map['id'],
      title: map['title'],
      startDate: DateTime.parse(map['startDate']),
      endDate: DateTime.parse(map['endDate']),
      // Convertemos a string de volta para uma lista de inteiros
      daysOfWeek: (map['daysOfWeek'] as String)
          .split(',')
          .map((day) => int.parse(day))
          .toList(),
    );
  }
}