import 'package:communication_app/layout/cubit/home_layout_cubit.dart';
import 'package:communication_app/layout/cubit/home_layout_states.dart';
import 'package:communication_app/modules/login/login_screen.dart';
import 'package:communication_app/shared/componants/componants.dart';
import 'package:communication_app/shared/network/local/cache_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfile extends StatelessWidget {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final bioController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var userModel = SocialCubit.get(context).userModel;
        var profileImage = SocialCubit.get(context).profileImage;
        var coverImage = SocialCubit.get(context).coverImage;
        var formKey = GlobalKey<FormState>();

        nameController.text = userModel!.name;
        emailController.text = userModel.email;
        bioController.text = userModel.bio;

        return Scaffold(
          appBar: AppBar(
            title: Text('Edit Profile'),
            titleSpacing: 4.0,
            actions: [
              TextButton(
                  onPressed: () {
                    SocialCubit.get(context).update(
                        name: nameController.text,
                        email: emailController.text,
                        bio: bioController.text);
                  },
                  child: Text(
                    'Update',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  )),
              SizedBox(
                width: 12,
              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(children: [
                  Container(
                    height: 180.0,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Align(
                          child: Stack(
                            alignment: AlignmentDirectional.topEnd,
                            children: [
                              Container(
                                height: 140.0,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(4.0),
                                        topLeft: Radius.circular(4.0)),
                                    image: DecorationImage(
                                        image: coverImage == null
                                            ? NetworkImage('${userModel.cover}')
                                            : FileImage(coverImage)
                                                as ImageProvider,
                                        fit: BoxFit.cover)),
                              ),
                              IconButton(
                                  onPressed: () {
                                    SocialCubit.get(context).getCoverImage();
                                  },
                                  icon: CircleAvatar(
                                      radius: 20.0,
                                      child: Icon(
                                        Icons.camera_alt_outlined,
                                        size: 16,
                                      )))
                            ],
                          ),
                          alignment: AlignmentDirectional.topStart,
                        ),
                        Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            CircleAvatar(
                              radius: 59,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                radius: 55.0,
                                backgroundImage: profileImage == null
                                    ? NetworkImage('${userModel.image}')
                                    : FileImage(profileImage) as ImageProvider,
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  SocialCubit.get(context).getProfileImage();
                                },
                                icon: CircleAvatar(
                                    radius: 18.0,
                                    child: Icon(
                                      Icons.camera_alt_outlined,
                                      size: 16,
                                    )))
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  if (SocialCubit.get(context).profileImage != null ||
                      SocialCubit.get(context).coverImage != null)
                    Row(
                      children: [
                        if (SocialCubit.get(context).profileImage != null)
                          Expanded(
                              child: defaultMaterialButton(
                                  text: 'upload profile',
                                  isUpperCase: true,
                                  onPressed: () {
                                    SocialCubit.get(context).uploadProfileImage(
                                        name: nameController.text,
                                        email: emailController.text,
                                        bio: bioController.text);
                                  })),
                        SizedBox(
                          width: 5,
                        ),
                        if (SocialCubit.get(context).coverImage != null)
                          Expanded(
                              child: defaultMaterialButton(
                                  text: 'upload Cover',
                                  isUpperCase: true,
                                  onPressed: () {
                                    SocialCubit.get(context).uploadCoverImage(
                                        name: nameController.text,
                                        email: emailController.text,
                                        bio: bioController.text);
                                  }))
                      ],
                    ),
                  SizedBox(
                    height: 20,
                  ),
                  defaultFormField(
                      controller: nameController,
                      label: 'name',
                      type: TextInputType.name,
                      validate: (String? value) {
                        if (value!.isEmpty) {
                          return 'name must not be empty';
                        }
                        return null;
                      },
                      prefix: Icons.account_circle_outlined),
                  SizedBox(
                    height: 10,
                  ),
                  defaultFormField(
                      controller: emailController,
                      label: 'email',
                      type: TextInputType.emailAddress,
                      validate: (String? value) {
                        if (value!.isEmpty) {
                          return 'email must not be empty';
                        }
                        return null;
                      },
                      prefix: Icons.email),
                  SizedBox(
                    height: 10,
                  ),
                  defaultFormField(
                      controller: bioController,
                      label: 'bio',
                      type: TextInputType.text,
                      validate: (String? value) {
                        if (value!.isEmpty) {
                          return 'bio must not be empty';
                        }
                        return null;
                      },
                      prefix: Icons.blur_circular_rounded),
                ]),

              ),
            ),

          ),
        );
      },
    );
  }
}
