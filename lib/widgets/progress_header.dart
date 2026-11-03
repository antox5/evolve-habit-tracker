
import 'package:flutter/material.dart';
import 'package:flutter_application_3/models/models.dart';
import 'package:flutter_application_3/styles.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_3/cubits.dart';


import 'package:flutter/material.dart';

class HabitProgressHeader extends StatelessWidget {
final List<Map<String, dynamic>> habits; // Pass your list of habit documents/maps

   HabitProgressHeader({Key? key, required this.habits}) : super(key: key);

  // Helper to check if a timestamp matches today's date (YYYY-MM-DD)
  bool _isCompletedToday(List<dynamic> timestamps) {
    final String todayStr = DateTime.now().toIso8601String().substring(0, 10); // e.g. "2026-10-30"
    
    for (var ts in timestamps) {
      // Assuming timestamps are stored as ISO strings or DateTime objects
      String tsDate = '';
      if (ts is String) {
        tsDate = ts.substring(0, 10);
      } else if (ts is DateTime) {
        tsDate = ts.toIso8601String().substring(0, 10);
      }
      
      if (tsDate == todayStr) {
        return true; // Completed at least once today
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    if (habits.isEmpty) {
      return const SizedBox.shrink(); // Don't show if no habits exist yet
    }

    // Count how many habits are completed today
    int completedCount = habits.where((habit) {
      List<dynamic> timestamps = habit['completedTimestamps'] ?? [];
      return _isCompletedToday(timestamps);
    }).length;

    int totalHabits = habits.length;
    double progressRatio = totalHabits > 0 ? completedCount / totalHabits : 0.0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Today's Flow",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                "$completedCount of $totalHabits completed",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.deepOrange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Linear Progress Indicator matching your high-contrast orange/white theme
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: LinearProgressIndicator(
              value: progressRatio,
              minHeight: 8,
              backgroundColor: Colors.orange.shade100,
              valueColor: const AlwaysStoppedAnimation<Color>(AppStyles.lpiColor),
            ),
          ),
        ],
      ),
    );
  }
}