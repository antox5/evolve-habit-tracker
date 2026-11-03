
import 'package:flutter_bloc/flutter_bloc.dart';
import 'models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// --- STATES ---
abstract class HabitState {}

class HabitInitial extends HabitState {}

class HabitLoading extends HabitState {}

class HabitLoaded extends HabitState {
  final List<Habit> habits;
  HabitLoaded(this.habits);
}

class HabitError extends HabitState {
  final String message;
  HabitError(this.message);
}


class HabitCubit extends Cubit<HabitState> {
  final String userId;

  HabitCubit({required this.userId}) : super(HabitInitial()) {
    loadHabits();
  }

  CollectionReference get _habitsRef => FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('habits');

  // Load / Stream Habits
  void loadHabits() {
    emit(HabitLoading());
    try {
      _habitsRef.snapshots().listen((snapshot) {
        final habits = snapshot.docs.map((doc) {
          return Habit.fromMap(doc.data() as Map<String, dynamic>, doc.id);
        }).toList();
        emit(HabitLoaded(habits));
      });
    } catch (e) {
      emit(HabitError(e.toString()));
    }
  }

  // Log completion (Non-punitive timestamp tracking)
 Future<void> logCompletion(Habit habit) async {
  final String nowIso = DateTime.now().toIso8601String();
  final String todayDate = nowIso.split('T')[0];
  List<dynamic> updatedTimestamps = List.from(habit.completedTimestamps)..add(nowIso);

  await _habitsRef.doc(habit.id).update({
    'streakCount': habit.streakCount + 1, // Increment the streak!
    'lastCheckedDate': todayDate,       // Update the last checked date
    'completedTimestamps': updatedTimestamps,
  });
}

  // Delete Habit
  Future<void> deleteHabit(String habitId) async {
    await _habitsRef.doc(habitId).delete();
  }
}