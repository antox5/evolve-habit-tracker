import 'package:flutter/material.dart';
import 'package:flutter_application_3/cubits.dart';
import 'package:flutter_application_3/models/models.dart';
import 'package:flutter_application_3/styles.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HabitDetails extends StatefulWidget {
   HabitDetails({super.key, required this.habitId});
   final String habitId;
    


  @override
  State<HabitDetails> createState() => _HabitDetailsState();
}

class _HabitDetailsState extends State<HabitDetails> {
  @override
  Widget build(BuildContext context) {
  
    return BlocBuilder<HabitCubit, HabitState>(
      builder: (BuildContext context, state) {  
        Habit? habit;
        if (state is HabitLoaded) {
          try {
            habit = state.habits.firstWhere((h) => h.id == widget.habitId);
          } catch (_) {
            habit = null;
          }
        }

        final timestamps = habit != null
            ? List<dynamic>.from(habit.completedTimestamps).reversed.toList()
            : [];
      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppStyles.appBarColor,
          centerTitle: AppStyles.centreTitle,
          elevation: 0,
          title:  Row(
            children: [
                          Icon(Icons.history, color: AppStyles.iconColor,size: AppStyles.iconSize,),
              SizedBox(width: 8),
      
              Text('Habit History', style: AppStyles.appBarTitleStyle),
            ],
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: AppStyles.backgroundGradient,
          ),
          child: timestamps.isEmpty
              ? const Center(
                  child: Text(
                    'No completions logged yet!',
                    style: AppStyles.titleStyle,
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: timestamps.length,
                  itemBuilder: (context, index) {
                    final String timeString = timestamps[index].toString();
                    final int streakNumber = timestamps.length - index;
      
                    return Card(
                      elevation: AppStyles.elevation,
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      shape: AppStyles.cardShape,
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: AppStyles.circleAvatarColor,
                          child: Icon(Icons.local_fire_department, color: AppStyles.iconColor),
                        ),
                        title: Text(
                          "Streak #$streakNumber",
                          style: AppStyles.titleStyle,
                        ),
                        subtitle: Text(
                          "Completed at: $timeString",
                          style: AppStyles.subtitleStyle,
                        ),
                      ),
                    );
                  },
                ) ,
        ),
      );}
    );
  }
}