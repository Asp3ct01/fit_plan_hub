// import 'dart:convert';
import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
import '../services/api_service.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  bool loading = true;

  List<dynamic> plans = [];

  Future<void> loadPlans() async {
    setState(() => loading = true);

    final result = await ApiService.getUserPlans();

    setState(() {
      plans = result;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Available Plans")),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: plans.length,
              itemBuilder: (context, index) {
                final plan = plans[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          plan["title"],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(plan["p_description"]),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "₹${plan["price"]}",
                              style: const TextStyle(fontSize: 16),
                            ),
                            if (plan["p_description"] ==
                                "Subscribe to view full details")
                              ElevatedButton(
                                onPressed: () async {
                                  final success =
                                      await ApiService.subscribeToPlan(
                                        plan["id"],
                                      );

                                  if (success) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Subscribed successfully",
                                        ),
                                      ),
                                    );
                                    loadPlans();
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Subscription failed"),
                                      ),
                                    );
                                  }
                                },
                                child: const Text("Subscribe"),
                              )
                            else
                              const Text(
                                "Subscribed",
                                style: TextStyle(color: Colors.green),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
