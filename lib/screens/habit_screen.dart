import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_3/cubits.dart';
import 'package:flutter_application_3/main.dart';
import 'package:flutter_application_3/notifications.dart';
import 'package:flutter_application_3/screens/about_screen.dart';
import 'package:flutter_application_3/screens/add_habit_screen.dart';
import 'package:flutter_application_3/screens/habit_details.dart';
import 'package:flutter_application_3/screens/sign_in_page.dart';
import 'package:flutter_application_3/styles.dart';
import 'package:flutter_application_3/widgets/progress_header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_confetti/flutter_confetti.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:http/http.dart' as http;
import 'package:toastification/toastification.dart';
class HabitScreen extends StatefulWidget {
  const HabitScreen({super.key});

  @override
  State<HabitScreen> createState() => _HabitScreenState();
}

class _HabitScreenState extends State<HabitScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  void _triggerCompletionCelebration(BuildContext context) {
    Confetti.launch(
  context,
  options: const ConfettiOptions(
    particleCount: 60,
    spread: 70,
    y: 0.6,
  ),
);
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          "🎉 HOORAY!",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppStyles.primaryOrange, 
            fontWeight: FontWeight.bold, 
            fontSize: 24,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              "“Discipline is choosing between what you want now and what you want most.”",
              textAlign: TextAlign.center,
              style: TextStyle(fontStyle: FontStyle.italic, fontSize: 14, color: Colors.grey),
            ),
            SizedBox(height: 16),
            Text(
              "You've successfully hit your target frequency for today! Keep up the unstoppable momentum.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15),
            ),
          ],
        ),
        actions: [
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppStyles.buttonColor,
                shape: AppStyles.btnShape,
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text("Continue Evolving", style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      );

    },
  );
}
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final CollectionReference _userHabitsRef = FirebaseFirestore.instance
    .collection('users')
    .doc(user?.uid)
    .collection('habits');

 
    return  Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        backgroundColor: AppStyles.drawerBGColor,
        elevation: AppStyles.elevation,
        child: ListView(
      padding: EdgeInsets.zero,
      children: [
        UserAccountsDrawerHeader(
          decoration: const BoxDecoration(
            color: AppStyles.drawerHeaderColor,
          ),
          accountName: Text(
            FirebaseAuth.instance.currentUser?.displayName ?? 'Evolve User',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          accountEmail: Text(
            FirebaseAuth.instance.currentUser?.email ?? 'user@evolve.app',
          ),
          currentAccountPicture: CircleAvatar(
            backgroundColor: AppStyles.circleAvatarColor,
            backgroundImage: FirebaseAuth.instance.currentUser?.photoURL != null
                ? NetworkImage(FirebaseAuth.instance.currentUser!.photoURL!)
                : null,
            child: FirebaseAuth.instance.currentUser?.photoURL == null
                ? const Icon(Icons.person, color: AppStyles.primaryOrange, size: 30)
                : null,
          ),
        ),
        ListTile(
          leading: const Icon(Icons.local_fire_department, color: AppStyles.drawericonColor),
          title: const Text('My Habits', style: AppStyles.drawerTitleStyle,),
          onTap: () => Navigator.pop(context),
        ),
        ListTile(
          leading: const Icon(Icons.info, color: AppStyles.drawericonColor),
          title: const Text('About App',style: AppStyles.drawerTitleStyle,),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => AboutScreen()));
            // Add settings navigation if needed
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.logout, color: AppStyles.drawericonColor),
          title: const Text('Sign Out', style: AppStyles.drawerTitleStyle),
          onTap: () async {
            Navigator.pop(context);
           await FirebaseAuth.instance.signOut();
             Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const SignInPage()),
              );
          },
        ),
      ],
    ),
  ),
      
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        actions: [
         TextButton(
          onPressed: ()async {
            try {
        final response = await http.get(Uri.parse('https://zenquotes.io/api/random'));
        if (response.statusCode == 200) {
          final List<dynamic> decodedList = jsonDecode(response.body);
  final data = decodedList[0]; //
          
          if (!context.mounted) return;
          
          // 2. Show Toastification notification
          toastification.show(
            context: context,
            type: ToastificationType.info,
            style: ToastificationStyle.flatColored,
            title: Text(
            data['a'] ?? 'Motivation' ,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            description: Text(data['q'],maxLines: 4,overflow: TextOverflow.ellipsis,
            ),
            
            alignment: Alignment.topCenter,
            autoCloseDuration: const Duration(seconds: 4),
            icon: const Icon(Icons.format_quote, color: Colors.orange),
            borderRadius: BorderRadius.circular(12),
          );
        }
      } catch (e) {
        if (!context.mounted) return;
        toastification.show(
          context: context,
          type: ToastificationType.error,
          title: const Text('Network Error'),
          description: const Text('Could not load motivation quote.'),
          alignment: Alignment.topCenter,
          autoCloseDuration: const Duration(seconds: 3),
        );
      }

          }, child: Text('Motivate Me!', style: TextStyle(color: Colors.white),))
        ],
        leading : Padding(
    padding: const EdgeInsets.all(8.0), // Adds breathing room inside the AppBar
    child: InkWell(
      onTap: () {
        _scaffoldKey.currentState?.openDrawer();
      },
      child: CircleAvatar(
        backgroundColor: AppStyles.circleAvatarColor,
        backgroundImage: FirebaseAuth.instance.currentUser?.photoURL != null
            ? NetworkImage(FirebaseAuth.instance.currentUser!.photoURL!)
            : null,
        child: FirebaseAuth.instance.currentUser?.photoURL == null
            ? const Icon(Icons.person, color: Colors.white, size: 20)
            : null,
      ),
    ),
  ),
        
        title: const Text('Evolve!', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),),
        centerTitle: true,
        backgroundColor: AppStyles.appBarColor,
        elevation: 0,
      ),
      
      floatingActionButton: FloatingActionButton(
        shape: AppStyles.btnShape,
        tooltip: 'Add Habit',
        focusColor: Colors.deepOrange,
        
        
        onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const AddHabitPage()));
        
      },backgroundColor: AppStyles.buttonColor, child: const Icon(Icons.add, color: Colors.white,size: 30),),
      

      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: AppStyles.backgroundGradient,
        ),
        child: BlocBuilder<HabitCubit, HabitState>(
  builder: (context, state) {
    if (state is HabitLoading || state is HabitInitial) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state is HabitError) {
      return Center(
        child: Text(
          'Error loading habits: ${state.message}',
          style: const TextStyle(color: Colors.red),
        ),
      );
    }
    if (state is HabitLoaded) {
      final habits = state.habits;

      // Convert Habit models to Map list for HabitProgressHeader
      final habitsList = habits.map((h) => {
        'id': h.id,
        'name': h.name,
        'category': h.category,
        'streakCount': h.streakCount,
        'lastCheckedDate': h.lastCheckedDate,
        'completedTimestamps': h.completedTimestamps,
      }).toList();

      if (habits.isEmpty) {
        return const Center(
          child: Text('No habits in motion yet.'),
        );
      }
            return Column(
              children: [
                HabitProgressHeader(habits: habitsList),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    itemCount: habits.length,
                    itemBuilder: (context, index) {
                     final habit = habits[index];
          
                      return Dismissible(
                        
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        key: Key(habit.id),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) async {
                        context.read<HabitCubit>().deleteHabit(habit.id);
                        },
                        confirmDismiss: (direction) async {
                          return await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Confirm Delete'),
                              content: const Text('Are you sure you want to delete this habit?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(false),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(true),
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );
                        },
                        
                        child: Card(
                          
                          shape: AppStyles.cardShape,
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: ExpansionTile(
                            
                            title: Text(
                              habit.name,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                            ),
                            subtitle: Text(
                              habit.description,
                              style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                            ),
                            trailing: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () {
                            context.read<HabitCubit>().logCompletion(habit);
                    _triggerCompletionCelebration(context);
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.local_fire_department, color: Colors.deepOrange,size: 20,),
                                  SizedBox(width: 4),
                                  Text('${habit.streakCount}', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepOrange,fontSize: 18),),
                        
                              ],)
                            ),
                            childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            children: [
                  
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Category: ${habit.category}', style: TextStyle(fontSize: 14, color: Colors.grey.shade700),),
                                     Text('Streak: ${habit.streakCount}', style: TextStyle(fontSize: 14, color: Colors.grey.shade700),),
                                     Row(
                                       children: [
                                         Text('Last Checked: ${habit.lastCheckedDate}', style: TextStyle(fontSize: 14, color: Colors.grey.shade700),),
                                         SizedBox(width: 8),
                                         TextButton(onPressed: () {
                                          Navigator.push(context, MaterialPageRoute(builder: (context) =>  BlocProvider.value(
                                            value: context.read<HabitCubit>(),
                                            child: HabitDetails(habitId: habit.id,
                                             ),
                                          )));
                                         }, child: Text('know more', style: TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold),))
                                       ],
                                     ),
                                  ],
                                ),
                              ),
                             
                              
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
  },
      
      ),
    ));
  }
  
}