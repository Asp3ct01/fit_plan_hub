import 'package:fit_plan_hub/screens/login_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const FitPlanHubApp());
}

class FitPlanHubApp extends StatelessWidget {
  const FitPlanHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fit Plan Hub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginScreen(),
    );
  }
}
