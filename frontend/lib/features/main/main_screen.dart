import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/main/bloc/main_bloc.dart';
import 'package:frontend/features/main/bloc/main_event.dart';
import 'package:frontend/features/main/bloc/main_state.dart';
import 'package:frontend/utils/extensions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final searchController = TextEditingController();

  Timer? _debounce;

  void searchUsers(String query) {
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }

    if (query.length < 3) return;

    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<MainBloc>().add(SearchUsersEvent(query: query));
    });
  }

  @override
  void initState() {
    super.initState();
    context.read<MainBloc>().add(FetchPaginationUsersEvent(1, 5));
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Card(
        child: Container(
          height: 84,
          padding: EdgeInsets.symmetric(vertical: 5),
          child: BlocBuilder<MainBloc, MainState>(
            builder: (context, state) {
              if (state is MainSuccess) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed:
                          state.currentPage > 1
                              ? () {
                                context.read<MainBloc>().add(
                                  FetchPaginationUsersEvent(
                                    state.currentPage - 1,
                                    5,
                                  ),
                                );
                              }
                              : null, // Disable if on first page
                      icon: Icon(Icons.chevron_left),
                    ),
                    SizedBox(width: 8),
                    Text("${state.currentPage}"),
                    SizedBox(width: 8),
                    Text("of"),
                    SizedBox(width: 8),
                    Text("${state.totalPages}"),
                    IconButton(
                      onPressed:
                          state.currentPage < state.totalPages
                              ? () {
                                context.read<MainBloc>().add(
                                  FetchPaginationUsersEvent(
                                    state.currentPage + 1,
                                    5,
                                  ),
                                );
                              }
                              : null, // Disable if on last page
                      icon: Icon(Icons.chevron_right),
                    ),
                  ],
                );
              }
              return SizedBox(); // Empty state
            },
          ),
        ),
      ),
      appBar: AppBar(
        title: Text("Main Screen"),
        actions: [
          IconButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              final token = prefs.getString("access_token");
              if (token != null) {
                final decodeToken = token.decodeToken();
                final dataToken = jsonDecode(decodeToken);
                if (!context.mounted) return;
                Navigator.pushNamed(
                  context,
                  "/profile",
                  arguments: dataToken["userId"],
                );
              }
            },
            icon: Icon(Icons.person),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            children: [
              TextFormField(
                controller: searchController,
                onChanged: searchUsers,
                decoration: InputDecoration(
                  hintText: "Search user",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 5),
              BlocConsumer<MainBloc, MainState>(
                builder: (context, state) {
                  if (state is AddBulkUsersError) {
                    final error = (state).message;
                    return Center(child: Text(error));
                  }

                  if (state is MainSuccess) {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: (state).users.length,
                        itemBuilder: (context, index) {
                          final user = (state).users[index];
                          return Dismissible(
                            key: ValueKey(user.id),
                            onDismissed: (direction) {},

                            child: ListTile(
                              onTap:
                                  () => Navigator.pushNamed(
                                    context,
                                    "/user-detail",
                                    arguments: user.id,
                                  ),
                              title: Text(user.name),
                              subtitle: Text(user.email),

                              leading:
                                  user.avatar == null
                                      ? SizedBox()
                                      : CircleAvatar(
                                        backgroundImage: NetworkImage(
                                          user.avatar ?? "",
                                        ),
                                      ),
                            ),
                          );
                        },
                      ),
                    );
                  } else if (state is MainError) {
                    final error = (state).message;
                    return Center(child: Text(error));
                  }
                  return Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  );
                },
                listener: (context, state) {
                  if (state is AddBulkUsersSuccess) {
                    context.read<MainBloc>().add(
                      FetchPaginationUsersEvent(1, 5),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await showDialog(
            context: context,
            builder: (context) {
              return StatefulBuilder(
                builder: (context, ststate) {
                  final userCountController = TextEditingController();

                  return AlertDialog(
                    title: Text("Add User"),
                    content: TextField(
                      controller: userCountController,
                      decoration: InputDecoration(labelText: "Count"),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("Cancel"),
                      ),
                      TextButton(
                        onPressed:
                            () => Navigator.pop(
                              context,
                              userCountController.text,
                            ),
                        child: Text("Add"),
                      ),
                    ],
                  );
                },
              );
            },
          );
          if (result != null) {
            if (context.mounted) {
              context.read<MainBloc>().add(AddBulkUserEvent(int.parse(result)));
            }
          }
        },
      ),
    );
  }
}
