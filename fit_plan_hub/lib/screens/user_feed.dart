import 'package:flutter/material.dart';
import '../services/api_service.dart';

class UserFeedScreen extends StatefulWidget {
  const UserFeedScreen({super.key});

  @override
  State<UserFeedScreen> createState() => _UserFeedScreenState();
}

class _UserFeedScreenState extends State<UserFeedScreen> {
  bool loading = true;
  List<dynamic> feedPlans = [];

  Future<void> loadFeed() async {
    feedPlans = await ApiService.getUserFeed();
    setState(() => loading = false);
  }

  @override
  void initState() {
    super.initState();
    loadFeed();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Feed")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : feedPlans.isEmpty
          ? const Center(
              child: Text(
                "You are not following any trainers yet",
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: feedPlans.length,
              itemBuilder: (context, index) {
                final plan = feedPlans[index];
                return Card(
                  margin: const EdgeInsets.all(10),
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
                        const SizedBox(height: 6),
                        Text(plan["p_description"]),
                        const SizedBox(height: 6),
                        Text(
                          "₹${plan["price"]} • ${plan["duration_days"]} days",
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 6),
                        if (plan["subscribed"] == true)
                          const Text(
                            "Subscribed",
                            style: TextStyle(color: Colors.green),
                          )
                        else
                          ElevatedButton(
                            onPressed: () async {
                              final success = await ApiService.subscribeToPlan(
                                plan["id"],
                              );
                              if (success) {
                                loadFeed();
                              }
                            },
                            child: const Text("Subscribe"),
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
