import 'package:flutter/material.dart';

class AppStyles {
  // Brand Colors (Matching your high-contrast orange/white/black theme)
  static const Color primaryOrange = Colors.deepOrange;
  static const Color backgroundYellow = Color(0xFFFFB300); // or your gradient tone
  static const Color cardBackground = Colors.white;
  static const Color textDark = Colors.black87;
  static const Color appBarColor = Colors.amber;
  static const Color buttonColor = Colors.amber;
  static const Color iconColor = Colors.white;
  static const Color drawericonColor = Colors.white;
  static const Color circleAvatarColor = Colors.deepOrangeAccent;
  static const Color drawerHeaderColor = Colors.deepOrangeAccent;
  static const Color drawerBGColor = Colors.orangeAccent;
  static const Color lpiColor = Colors.deepOrangeAccent;
  static const double elevation = 2;

  
  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Colors.amber, Colors.orange, Colors.redAccent],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  static const TextStyle buttonTextStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );
  static const TextStyle appBarTitleStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white

  );
  static const TextStyle drawerTitleStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white

  );

  static OutlineInputBorder txtFieldborder = OutlineInputBorder(borderRadius: BorderRadius.circular(6));
  static const bool centreTitle = true;
  static const double iconSize = 30;
  static  RoundedRectangleBorder btnShape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(20));
  static RoundedRectangleBorder cardShape = RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(20));


  
  // Reusable Text Styles
  static const TextStyle titleStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: textDark,
  );

  static const TextStyle subtitleStyle = TextStyle(
    fontSize: 14,
    color: Colors.black54,
  );

  // Common Card Decoration
  static BoxDecoration cardDecoration = BoxDecoration(
    color: cardBackground,
    borderRadius: BorderRadius.circular(16.0),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
  );
}