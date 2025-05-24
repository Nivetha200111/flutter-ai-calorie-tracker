import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../models/food_entry.dart';
import '../services/grok_service.dart';

class CalorieProvider with ChangeNotifier {
  List<FoodEntry> _foodEntries = [];
  int _totalCalories = 0;
  final int _dailyGoal = 2000;
  bool _isLoading = false;
  String? _apiKey;
  late GrokService _grokService;

  List<FoodEntry> get foodEntries => _foodEntries;
  int get totalCalories => _totalCalories;
  int get dailyGoal => _dailyGoal;
  int get remainingCalories => _dailyGoal - _totalCalories;
  double get progress => (_totalCalories / _dailyGoal).clamp(0.0, 1.0);
  bool get isLoading => _isLoading;
  String? get apiKey => _apiKey;

  CalorieProvider() {
    _grokService = GrokService(_apiKey);
    _loadStoredData();
  }

  void setApiKey(String key) {
    _apiKey = key;
    _grokService = GrokService(_apiKey);
    _saveApiKey();
    notifyListeners();
  }

  Future<void> _saveApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('grokApiKey', _apiKey ?? '');
  }

  Future<void> _loadApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    _apiKey = prefs.getString('grokApiKey');
    _grokService = GrokService(_apiKey);
  }

  Future<void> analyzeFood(String foodDescription) async {
    if (foodDescription.trim().isEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      final result = await _grokService.analyzeFood(foodDescription);
      final entry = FoodEntry(
        id: DateTime.now().millisecondsSinceEpoch,
        description: foodDescription,
        calories: result['calories'],
        details: result['details'],
        timestamp: DateTime.now(),
      );

      _foodEntries.insert(0, entry);
      _totalCalories += entry.calories;
      await _saveData();
      notifyListeners();
    } catch (e) {
      debugPrint('Error analyzing food: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void removeFoodEntry(int id) {
    final entry = _foodEntries.firstWhere((e) => e.id == id);
    _foodEntries.removeWhere((e) => e.id == id);
    _totalCalories -= entry.calories;
    _saveData();
    notifyListeners();
  }

  Future<void> _loadStoredData() async {
    await _loadApiKey();
    
    final prefs = await SharedPreferences.getInstance();
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final storedDate = prefs.getString('lastDate');

    if (storedDate != today) {
      _foodEntries = [];
      _totalCalories = 0;
      await prefs.setString('lastDate', today);
      await _saveData();
    } else {
      final entriesJson = prefs.getStringList('foodEntries') ?? [];
      _foodEntries = entriesJson
          .map((json) => FoodEntry.fromJson(jsonDecode(json)))
          .toList();
      _totalCalories = _foodEntries.fold(0, (sum, entry) => sum + entry.calories);
    }
    notifyListeners();
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    final entriesJson = _foodEntries
        .map((entry) => jsonEncode(entry.toJson()))
        .toList();
    await prefs.setStringList('foodEntries', entriesJson);
  }
}