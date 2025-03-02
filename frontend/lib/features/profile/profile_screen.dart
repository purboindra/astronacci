import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/data/models/response_model.dart';
import 'package:frontend/data/models/user_model.dart';
import 'package:frontend/features/profile/bloc/profile_bloc.dart';
import 'package:frontend/features/profile/bloc/profile_event.dart';
import 'package:frontend/features/profile/bloc/profile_state.dart';
import 'package:frontend/features/profile/widgets/avatar_widget.dart';
import 'package:frontend/repositories/user_repository.dart';
import 'package:frontend/services/file_services.dart';
import 'package:frontend/widgets/app_form_field.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.id});

  final String id;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final fileService = FileServices.instance;

  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final ageController = TextEditingController();

  XFile? file;

  UserModel? userModel;

  bool isLoading = false;

  Future<void> fetchDetailUser() async {
    setState(() {
      isLoading = true;
    });
    final result = await context.read<UserRepository>().fetchUserById(
      id: widget.id,
    );

    if (result is Success) {
      final data = jsonDecode(result.data);
      userModel = UserModel.fromJson(data);
      nameController.text = userModel?.name ?? "";
      addressController.text = userModel?.address ?? "";
      ageController.text = (userModel?.age ?? 0).toString();
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    addressController.dispose();
    ageController.dispose();
  }

  @override
  void initState() {
    super.initState();
    fetchDetailUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          isLoading
              ? Center(child: CircularProgressIndicator.adaptive())
              : SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: ListView(
                    children: [
                      AvatarWidget(
                        file: file,
                        imageUrl: userModel?.avatar,
                        onTapAvatar: () async {
                          final result = await fileService.takePicture();
                          if (result != null) {
                            setState(() {
                              file = result;
                            });
                          }
                        },
                      ),

                      SizedBox(height: 5),
                      if (file != null)
                        ElevatedButton(
                          onPressed: () {
                            context.read<ProfileBloc>().add(
                              UploadAvatarEvent(userId: widget.id, file: file!),
                            );
                          },
                          child: Text("Upload Avatatar"),
                        ),

                      SizedBox(height: 10),

                      AppFormField(
                        readOnly: true,
                        hintText: userModel?.email ?? "Email",
                      ),
                      SizedBox(height: 5),

                      AppFormField(
                        controller: nameController,
                        hintText: "Name",
                      ),
                      SizedBox(height: 5),

                      AppFormField(
                        controller: addressController,
                        hintText: "Address",
                      ),
                      SizedBox(height: 5),

                      AppFormField(controller: ageController, hintText: "Age"),
                      SizedBox(height: 20),

                      BlocBuilder<ProfileBloc, ProfileState>(
                        builder: (context, state) {
                          bool isUpdatingProfile =
                              state is UpdateProfileLoadingState;

                          return ElevatedButton(
                            onPressed:
                                isUpdatingProfile
                                    ? null
                                    : () {
                                      context.read<ProfileBloc>().add(
                                        UpdateProfileEvent(
                                          name: nameController.text,
                                          address: addressController.text,
                                          age: ageController.text,
                                          id: widget.id,
                                        ),
                                      );
                                    },
                            child:
                                isUpdatingProfile
                                    ? CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                    : Text("Update Data"),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
      bottomNavigationBar: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is LogoutSuccessState) {
            Navigator.pushNamedAndRemoveUntil(context, "/login", (_) => false);
          } else if (state is LogoutErrorState) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return BottomAppBar(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed:
                      state is LogoutLoadingState
                          ? null
                          : () {
                            context.read<ProfileBloc>().add(LogoutEvent());
                          },
                  child: Text(
                    state is LogoutLoadingState ? "Loading..." : "Logout",
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
