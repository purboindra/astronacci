import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Card(
        child: Container(
          height: 48,
          padding: EdgeInsets.symmetric(vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(onPressed: () {}, icon: Icon(Icons.chevron_left)),
              SizedBox(width: 8),
              Text("1"),
              SizedBox(width: 8),
              Text("of"),
              SizedBox(width: 8),
              Text("2"),
              IconButton(onPressed: () {}, icon: Icon(Icons.chevron_right)),
            ],
          ),
        ),
      ),
      appBar: AppBar(title: Text("Main Screen")),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            children: [
              Text("Users"),
              SizedBox(height: 5),
              Expanded(
                child: ListView.builder(
                  itemCount: 30,
                  itemBuilder: (context, index) {
                    return ListTile(title: Text("User $index"));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
