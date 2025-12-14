import 'package:flutter/material.dart';
import '../services/api_service.dart';

class TrainerDashboard extends StatefulWidget {
  const TrainerDashboard({super.key});

  @override
  State<TrainerDashboard> createState() => _TrainerDashboardState();
}

class _TrainerDashboardState extends State<TrainerDashboard> {
  List<dynamic> plans = [];
  bool loading = true;

  final titleCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final priceCtrl = TextEditingController();
  final durationCtrl = TextEditingController();

  Future<void> loadPlans() async {
    plans = await ApiService.getTrainerPlans();
    setState(() => loading = false);
  }

  Future<void> createPlan() async {
    final success = await ApiService.createPlan(
      titleCtrl.text,
      descCtrl.text,
      double.parse(priceCtrl.text),
      int.parse(durationCtrl.text),
    );

    if (success) {
      titleCtrl.clear();
      descCtrl.clear();
      priceCtrl.clear();
      durationCtrl.clear();
      loadPlans();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Plan created")));
    }
  }

  @override
  void initState() {
    super.initState();
    loadPlans();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Trainer Dashboard")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Create New Plan",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: titleCtrl,
                    decoration: const InputDecoration(labelText: "Title"),
                  ),
                  TextField(
                    controller: descCtrl,
                    decoration: const InputDecoration(labelText: "Description"),
                  ),
                  TextField(
                    controller: priceCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: "Price"),
                  ),
                  TextField(
                    controller: durationCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Duration (days)",
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: createPlan,
                    child: const Text("Create Plan"),
                  ),
                  const Divider(height: 40),
                  const Text(
                    "My Plans",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ...plans.map((plan) {
                    return Card(
                      child: ListTile(
                        title: Text(plan["title"]),
                        subtitle: Text(plan["p_description"]),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            await ApiService.deletePlan(plan["id"]);
                            loadPlans();
                          },
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
    );
  }
}
