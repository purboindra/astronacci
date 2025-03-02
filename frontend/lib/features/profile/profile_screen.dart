import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/profile/bloc/profile_bloc.dart';
import 'package:frontend/features/profile/bloc/profile_event.dart';
import 'package:frontend/features/profile/bloc/profile_state.dart';
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

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    addressController.dispose();
    ageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: ListView(
            children: [
              BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, state) {
                  bool isAvatarLoading = state is UploadAvatarLoadingState;
                  String? avatarUrl =
                      (state is UploadAvatarSuccessState)
                          ? state.avatarUrl
                          : null;
                  return GestureDetector(
                    onTap: () async {
                      final result = await fileService.takePicture();
                      if (result != null) {
                        setState(() {
                          file = result;
                        });
                      }
                    },
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,

                        image:
                            file != null
                                ? DecorationImage(
                                  image: FileImage(File(file!.path)),
                                )
                                : isAvatarLoading || avatarUrl == null
                                ? null
                                : DecorationImage(
                                  image: NetworkImage(avatarUrl),
                                  fit: BoxFit.cover,
                                ),
                        color: Colors.grey[300],
                      ),
                      child:
                          isAvatarLoading
                              ? Center(child: CircularProgressIndicator())
                              : null,
                    ),
                  );
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

              AppFormField(readOnly: true, hintText: "Email"),
              SizedBox(height: 5),

              AppFormField(controller: nameController, hintText: "Name"),
              SizedBox(height: 5),

              AppFormField(controller: addressController, hintText: "Address"),
              SizedBox(height: 5),

              AppFormField(controller: ageController, hintText: "Age"),
              SizedBox(height: 20),

              BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, state) {
                  bool isUpdatingProfile = state is UpdateProfileLoadingState;

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
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text("Update Data"),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
