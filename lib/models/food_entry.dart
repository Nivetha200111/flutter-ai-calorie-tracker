class FoodEntry {
  final int id;
  final String description;
  final int calories;
  final String details;
  final DateTime timestamp;

  FoodEntry({
    required this.id,
    required this.description,
    required this.calories,
    required this.details,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'calories': calories,
      'details': details,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory FoodEntry.fromJson(Map<String, dynamic> json) {
    return FoodEntry(
      id: json['id'],
      description: json['description'],
      calories: json['calories'],
      details: json['details'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}