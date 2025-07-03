import 'package:flutter/material.dart';

class EventModel {
  final int? id; // ID do evento único
  final String title;
  final DateTime date;
  final TimeOfDay? time; // NOVO: horário (opcional)
  final bool isAllDay;   // NOVO: evento de dia inteiro
  final int? recurringRuleId;

  EventModel({
    this.id,
    required this.title,
    required this.date,
    this.time,
    this.isAllDay = false,
    this.recurringRuleId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': date.toIso8601String(),
      'time': time != null ? '${time!.hour}:${time!.minute}' : null, // Armazena como string "HH:mm"
      'isAllDay': isAllDay ? 1 : 0,
      'recurringRuleId': recurringRuleId,
    };
  }

  factory EventModel.fromMap(Map<String, dynamic> map) {
    final timeStr = map['time'] as String?;
    final time = timeStr != null
        ? TimeOfDay(
      hour: int.parse(timeStr.split(":")[0]),
      minute: int.parse(timeStr.split(":")[1]),
    )
        : null;

    return EventModel(
      id: map['id'],
      title: map['title'],
      date: DateTime.parse(map['date']),
      time: time,
      isAllDay: map['isAllDay'] == 1,
      recurringRuleId: map['recurringRuleId'],
    );
  }
}
