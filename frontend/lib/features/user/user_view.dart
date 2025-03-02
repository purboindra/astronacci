import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/user/bloc/user_bloc.dart';
import 'package:frontend/features/user/bloc/user_event.dart';
import 'package:frontend/features/user/user_screen.dart';
import 'package:frontend/repositories/user_repository.dart';

class UserView extends StatelessWidget {
  const UserView({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              UserBloc(UserRepository())..add(FetchDetailUserEvent(id: userId)),
      child: UserScreen(id: userId),
    );
  }
}
