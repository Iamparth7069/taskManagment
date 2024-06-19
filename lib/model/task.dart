import 'package:flutter/material.dart';

class Task {
  int? id;
  String? name;
  String? description;
  String? date;
  String? time;
  String? priority;

  Task(
      {this.id,
        this.name,
        this.description,
        this.date, this.time, this.priority});

  Map<String, dynamic> toMap() {
    return {
      'title': this.name,
      'description': this.description,
      'date': this.date,
      'time': this.time,
      'priority' : this.priority
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as int,
      name: map['title'] as String,
      description: map['description'] as String,
      date: map['date'] as String,
      time: map['time'] as String,
      priority: map['priority'] as String,
    );
  }
}
