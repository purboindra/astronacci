import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/profile/bloc/profile_bloc.dart';
import 'package:frontend/features/profile/profile_screen.dart';
import 'package:frontend/repositories/auth_repository.dart';
import 'package:frontend/repositories/user_repository.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => UserRepository(),
      child: BlocProvider(
        create: (context) => ProfileBloc(UserRepository(), AuthRepository()),
        child: ProfileScreen(id: id),
      ),
    );
  }
}
