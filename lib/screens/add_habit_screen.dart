import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_3/styles.dart';

class AddHabitPage extends StatefulWidget {
  const AddHabitPage({super.key});

  @override
  State<AddHabitPage> createState() => _AddHabitPageState();
}

class _AddHabitPageState extends State<AddHabitPage> {
  final TextEditingController _habitNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedCategory = 'Building a good habit';
  @override
  void dispose() {
    _habitNameController.dispose();
    _descriptionController.dispose();
    super.dispose(); 
  }
  void _saveHabit() {
   final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('habits')
      .add({
    'name': _habitNameController.text.trim(),
    'description': _descriptionController.text.trim(),
    'category': _selectedCategory,
    'streakCount': 0,
    'lastCheckedDate': '',
    'completedTimestamps': [], 
    'createdAt': FieldValue.serverTimestamp(),
  });

  Navigator.pop(context);
    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        leading: IconButton(onPressed: () {
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back, size: AppStyles.iconSize,color: AppStyles.iconColor,)),
        title:  Text('Add Habit',style: AppStyles.appBarTitleStyle,),
        centerTitle: AppStyles.centreTitle,
        backgroundColor: AppStyles.appBarColor,
      ),
      body:  
        Container(
          decoration: BoxDecoration(
            gradient: AppStyles.backgroundGradient,
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _habitNameController,
                  decoration: InputDecoration(
                    labelText: 'Habit Name',
                    hintText: 'Enter habit name',
                    border: AppStyles.txtFieldborder,
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    hintText: 'Enter description',
                    border: AppStyles.txtFieldborder,
                  ),
                ),
              
                SizedBox(height: 16),
               DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: InputDecoration(
                    labelText: 'Category',
                    border: AppStyles.txtFieldborder,
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'Building a good habit',
                      child: Text('Building a good habit'),
                    ),
                    DropdownMenuItem(
                      value: 'Quitting a bad habit',
                      child: Text('Quitting a bad habit'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    }
                  },
                ),
                 SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: AppStyles.buttonColor, shape: AppStyles.btnShape),
                    onPressed: _saveHabit,
                    child: const Text(
                      'Save Habit',
                      style: AppStyles.buttonTextStyle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      
    );
  }
}