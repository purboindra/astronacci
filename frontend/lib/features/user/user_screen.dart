import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/user/bloc/user_bloc.dart';
import 'package:frontend/features/user/bloc/user_event.dart';
import 'package:frontend/features/user/bloc/user_state.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key, required this.id});

  final String id;

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  void initState() {
    super.initState();
    context.read<UserBloc>().add(FetchDetailUserEvent(id: widget.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              if (state is FetchDetailSuccessState) {
                final user = (state).userModel;
                return ListTile(
                  title: Text(user.name),
                  subtitle: Text(user.email),
                  isThreeLine: true,
                  leading:
                      user.avatar == null
                          ? SizedBox()
                          : CircleAvatar(
                            backgroundImage: NetworkImage(user.avatar ?? ""),
                          ),
                );
              } else if (state is FetchDetailErrorState) {
                return Center(child: Text(state.message));
              }

              return Center(child: CircularProgressIndicator.adaptive());
            },
          ),
        ),
      ),
    );
  }
}
