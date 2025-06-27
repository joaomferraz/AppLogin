class EventModel {
  final int? id;
  final String title;
  final DateTime date;

  EventModel({
    this.id,
    required this.title,
    required this.date,
  });

  // Converte o evento para um mapa para salvar no banco de dados
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': date.toIso8601String(), // Armazena a data como string ISO8601
    };
  }

  // Cria um evento a partir de um mapa (do banco de dados)
  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      id: map['id'],
      title: map['title'],
      date: DateTime.parse(map['date']),
    );
  }
}