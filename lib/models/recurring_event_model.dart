import 'package:flutter/material.dart';

class RecurringEventModel {
  final int? id;
  final String title;
  final DateTime startDate;
  final DateTime endDate;
  final List<int> daysOfWeek; // 1 para Segunda, 7 para Domingo
  final TimeOfDay? time; // horário único opcional
  final bool isAllDay;   // evento de dia inteiro

  RecurringEventModel({
    this.id,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.daysOfWeek,
    this.time,
    this.isAllDay = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'daysOfWeek': daysOfWeek.join(','),
      'time': time != null ? '${time!.hour}:${time!.minute}' : null,
    };
  }


  static RecurringEventModel fromMap(Map<String, dynamic> map) {
    final timeStr = map['time'] as String?;
    final parsedTime = timeStr != null
        ? TimeOfDay(
      hour: int.parse(timeStr.split(":")[0]),
      minute: int.parse(timeStr.split(":")[1]),
    )
        : null;

    return RecurringEventModel(
      id: map['id'],
      title: map['title'],
      startDate: DateTime.parse(map['startDate']),
      endDate: DateTime.parse(map['endDate']),
      daysOfWeek: (map['daysOfWeek'] as String)
          .split(',')
          .map((day) => int.parse(day))
          .toList(),
      time: parsedTime,
    );
  }
  }
