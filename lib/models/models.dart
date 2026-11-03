import 'package:cloud_firestore/cloud_firestore.dart';
class Habit {
  final String id;
  final String name;
  final String description;
  final String category;
  final int streakCount;
  final String lastCheckedDate;
  final List<String> completedTimestamps;

  Habit({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.streakCount,
    required this.lastCheckedDate,
    required this.completedTimestamps,
  });
  factory Habit.fromMap(Map<String, dynamic> map, String id) {
  return Habit(
    id: id,
    name: map['name'] ?? map['title'] ?? '',
    description: map['description'] ?? '',
    category: map['category'] ?? '',
    
    // Safely parse streakCount whether it's stored as int, double, or String in Firestore
    streakCount: map['streakCount'] != null
        ? int.tryParse(map['streakCount'].toString()) ?? (map['streakCount'] as num).toInt()
        : (map['streak_count'] != null 
            ? int.tryParse(map['streak_count'].toString()) ?? (map['streak_count'] as num).toInt() 
            : 0),
            
    // Safely parse lastCheckedDate
    lastCheckedDate: map['lastCheckedDate'] ?? map['last_checked_date'] ?? map['date'] ?? 'Never',
    
    // Safely parse completed timestamps
    completedTimestamps: map['completedTimestamps'] != null
        ? List<String>.from(map['completedTimestamps'])
        : (map['completed_timestamps'] != null 
            ? List<String>.from(map['completed_timestamps']) 
            : []),
  );
}


}