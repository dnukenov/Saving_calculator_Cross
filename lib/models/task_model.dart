class Task {
  final String id;
  final String title;
  final double savedMoney;

  Task({
    required this.id,
    required this.title,
    this.savedMoney = 0.0,
  });

  /// Создание копии с изменёнными полями
  Task copyWith({
    String? id,
    String? title,
    double? savedMoney,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      savedMoney: savedMoney ?? this.savedMoney,
    );
  }

  /// Для загрузки из Firebase/Map
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      savedMoney: (json['savedMoney'] ?? 0).toDouble(),
    );
  }

  /// Для сохранения в Firebase/Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'savedMoney': savedMoney,
    };
  }
}
