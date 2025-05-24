import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

class GrokService {
  static const String _baseUrl = 'https://api.x.ai/v1/chat/completions';
  final String? _apiKey;

  GrokService(this._apiKey);

  Future<Map<String, dynamic>> analyzeFood(String foodDescription) async {
    if (_apiKey == null || _apiKey!.isEmpty) {
      return _estimateCalories(foodDescription);
    }

    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'messages': [
            {
              'role': 'system',
              'content': 'You are a nutrition expert. Analyze food descriptions and provide accurate calorie estimates with portion assumptions.'
            },
            {
              'role': 'user',
              'content': '''Analyze this food description and provide calorie information: "$foodDescription"

Please respond with ONLY a JSON object in this exact format:
{
    "calories": <number>,
    "details": "<brief description of the food and serving size assumed>"
}

Be specific about serving sizes. If the description is vague, assume reasonable portions.'''
            }
          ],
          'model': 'grok-beta',
          'temperature': 0.1,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'];
        
        try {
          return jsonDecode(content);
        } catch (e) {
          final calorieMatch = RegExp(r'(\d+)\s*calories?', caseSensitive: false)
              .firstMatch(content);
          final calories = calorieMatch != null 
              ? int.parse(calorieMatch.group(1)!) 
              : _estimateCalories(foodDescription)['calories'] as int;
          
          return {
            'calories': calories,
            'details': content.length > 100 
                ? '${content.substring(0, 100)}...' 
                : content,
          };
        }
      } else {
        throw Exception('API request failed: ${response.statusCode}');
      }
    } catch (e) {
      return _estimateCalories(foodDescription);
    }
  }

  Map<String, dynamic> _estimateCalories(String foodDescription) {
    final lowCalFoods = ['salad', 'vegetables', 'broccoli', 'spinach', 'cucumber'];
    final medCalFoods = ['chicken', 'fish', 'rice', 'bread', 'pasta'];
    final highCalFoods = ['pizza', 'burger', 'fries', 'ice cream', 'chocolate'];
    
    final desc = foodDescription.toLowerCase();
    final random = Random();
    
    int calories;
    if (lowCalFoods.any((food) => desc.contains(food))) {
      calories = random.nextInt(150) + 50;
    } else if (highCalFoods.any((food) => desc.contains(food))) {
      calories = random.nextInt(400) + 300;
    } else {
      calories = random.nextInt(250) + 150;
    }

    return {
      'calories': calories,
      'details': 'Estimated calories for: $foodDescription',
    };
  }
}