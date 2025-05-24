import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/calorie_provider.dart';

class CalorieDisplayWidget extends StatelessWidget {
  const CalorieDisplayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CalorieProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Today\'s Calories',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 20),
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 600) {
                  return Row(
                    children: [
                      Expanded(
                        child: _buildCalorieItem(
                          'Total Calories:',
                          provider.totalCalories.toString(),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _buildCalorieItem(
                          'Goal:',
                          provider.dailyGoal.toString(),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _buildCalorieItem(
                          'Remaining:',
                          provider.remainingCalories.toString(),
                        ),
                      ),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      _buildCalorieItem(
                        'Total Calories:',
                        provider.totalCalories.toString(),
                      ),
                      const SizedBox(height: 20),
                      _buildCalorieItem(
                        'Goal:',
                        provider.dailyGoal.toString(),
                      ),
                      const SizedBox(height: 20),
                      _buildCalorieItem(
                        'Remaining:',
                        provider.remainingCalories.toString(),
                      ),
                    ],
                  );
                }
              },
            ),
            const SizedBox(height: 20),
            Container(
              height: 20,
              decoration: BoxDecoration(
                color: const Color(0xFFe0e0e0),
                borderRadius: BorderRadius.circular(10),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: provider.progress,
                child: Container(
                  decoration: BoxDecoration(
                    color: _getProgressColor(provider.progress),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCalorieItem(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFf8f9fa),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF666666),
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4CAF50),
            ),
          ),
        ],
      ),
    );
  }

  Color _getProgressColor(double progress) {
    if (progress > 1.0) {
      return const Color(0xFFff4444);
    } else if (progress > 0.8) {
      return const Color(0xFFffa500);
    } else {
      return const Color(0xFF4CAF50);
    }
  }
}