import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/calorie_provider.dart';
import '../models/food_entry.dart';

class FoodLogWidget extends StatelessWidget {
  const FoodLogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CalorieProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Food Log',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 20),
            provider.foodEntries.isEmpty
                ? _buildEmptyState()
                : _buildFoodEntries(provider.foodEntries, provider),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: const Center(
        child: Text(
          'No food entries yet. Start by describing what you ate!',
          style: TextStyle(
            color: Color(0xFF999999),
            fontStyle: FontStyle.italic,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildFoodEntries(List<FoodEntry> entries, CalorieProvider provider) {
    return Column(
      children: entries.map((entry) => _buildFoodEntry(entry, provider)).toList(),
    );
  }

  Widget _buildFoodEntry(FoodEntry entry, CalorieProvider provider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFf8f9fa),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            return Row(
              children: [
                Expanded(child: _buildFoodInfo(entry)),
                _buildFoodCalories(entry, provider),
              ],
            );
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFoodInfo(entry),
                const SizedBox(height: 15),
                Align(
                  alignment: Alignment.centerRight,
                  child: _buildFoodCalories(entry, provider),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildFoodInfo(FoodEntry entry) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          entry.description,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF333333),
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          entry.details,
          style: const TextStyle(
            color: Color(0xFF666666),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          DateFormat('MMM dd, yyyy - HH:mm').format(entry.timestamp),
          style: const TextStyle(
            color: Color(0xFF999999),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildFoodCalories(FoodEntry entry, CalorieProvider provider) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              entry.calories.toString(),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4CAF50),
              ),
            ),
            const Text(
              'cal',
              style: TextStyle(
                color: Color(0xFF4CAF50),
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(width: 10),
        Container(
          width: 30,
          height: 30,
          decoration: const BoxDecoration(
            color: Color(0xFFff4444),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: () => provider.removeFoodEntry(entry.id),
            icon: const Icon(
              Icons.close,
              color: Colors.white,
              size: 16,
            ),
            padding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }
}