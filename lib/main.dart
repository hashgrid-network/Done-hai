import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const DoneHaiApp());
}

class DoneHaiApp extends StatelessWidget {
  const DoneHaiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Done Hai',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F0F12),
        primaryColor: const Color(0xFF10B981),
      ),
      home: const HomeScreen(),
    );
  }
}

class GoalItem {
  String id;
  String title;
  String category;
  int streak;
  bool isDone;

  GoalItem({
    required this.id,
    required this.title,
    required this.category,
    required this.streak,
    this.isDone = false,
  });
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedFilter = 'All';

  final List<GoalItem> goals = [
    GoalItem(id: '1', title: 'Post 1 video daily', category: 'Calling Explorer', streak: 14),
    GoalItem(id: '2', title: 'Subah BP dawai (Papa)', category: 'Health', streak: 28),
    GoalItem(id: '3', title: 'Transfer ₹200 to savings', category: 'Money', streak: 8),
    GoalItem(id: '4', title: 'Work out 45 min', category: 'Routine', streak: 34),
    GoalItem(id: '5', title: '1 Coding lesson practice', category: 'Calling Explorer', streak: 12),
    GoalItem(id: '6', title: '1 Mala Jaap / Shukrana', category: 'Karma', streak: 19),
  ];

  final List<String> categories = ['All', 'Calling Explorer', 'Health', 'Money', 'Routine', 'Karma'];

  void toggleGoal(GoalItem goal) {
    HapticFeedback.lightImpact();
    setState(() {
      if (goal.isDone) {
        goal.isDone = false;
        goal.streak = goal.streak - 1;
      } else {
        goal.isDone = true;
        goal.streak = goal.streak + 1;
      }
    });
  }

  void addNewGoal(String title, String category) {
    setState(() {
      goals.insert(
        0,
        GoalItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: title,
          category: category,
          streak: 0,
          isDone: false,
        ),
      );
    });
  }

  void showAddDialog() {
    final titleController = TextEditingController();
    String category = 'Calling Explorer';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF18181D),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
            top: 24,
            left: 20,
            right: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Naya Goal Jodein',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: titleController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Goal ka naam (e.g. Roz 10k steps)',
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  filled: true,
                  fillColor: const Color(0xFF23232A),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: category,
                dropdownColor: const Color(0xFF23232A),
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF23232A),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
                items: categories
                    .where((c) => c != 'All')
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (val) => category = val ?? 'Calling Explorer',
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    if (titleController.text.trim().isNotEmpty) {
                      addNewGoal(titleController.text.trim(), category);
                      Navigator.pop(ctx);
                    }
                  },
                  child: const Text('Add to Grid', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredGoals = selectedFilter == 'All'
        ? goals
        : goals.where((g) => g.category == selectedFilter).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Done Hai', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -0.5)),
            Text('Data bolta hai, dimaag nahi.', style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle, color: Color(0xFF10B981), size: 28),
            onPressed: showAddDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 48,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: categories.length,
              itemBuilder: (context, i) {
                final cat = categories[i];
                final isSelected = selectedFilter == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (val) => setState(() => selectedFilter = cat),
                    backgroundColor: const Color(0xFF1E1E24),
                    selectedColor: const Color(0xFF10B981).withOpacity(0.2),
                    labelStyle: TextStyle(
                      color: isSelected ? const Color(0xFF10B981) : Colors.grey[400],
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide.none),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.88,
              ),
              itemCount: filteredGoals.length,
              itemBuilder: (context, index) {
                final goal = filteredGoals[index];
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: goal.isDone ? const Color(0xFF132A1C) : const Color(0xFF1E1E24),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: goal.isDone ? const Color(0xFF10B981) : Colors.transparent,
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        goal.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          height: 1.2,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${goal.streak}',
                            style: TextStyle(
                              fontSize: 38,
                              fontWeight: FontWeight.w900,
                              color: goal.isDone ? const Color(0xFF10B981) : Colors.white,
                              height: 1.0,
                            ),
                          ),
                          const Text(
                            'DAY STREAK',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 38,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: goal.isDone
                                ? const Color(0xFF10B981)
                                : const Color(0xFF2B2B36),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () => toggleGoal(goal),
                          child: Text(
                            goal.isDone ? '✓ Yes' : 'Pending',
                            style: TextStyle(
                              color: goal.isDone ? Colors.black : Colors.grey[300],
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
