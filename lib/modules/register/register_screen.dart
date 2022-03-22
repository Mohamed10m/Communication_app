import 'package:communication_app/layout/home_layout.dart';
import 'package:communication_app/modules/register/cubit/register_cubit.dart';
import 'package:communication_app/modules/register/cubit/register_states.dart';
import 'package:communication_app/shared/componants/componants.dart';
import 'package:communication_app/shared/network/local/cache_helper.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SocialRegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    var namedController = TextEditingController();
    var emailController = TextEditingController();
    var phoneController = TextEditingController();
    var passwordController = TextEditingController();
    return BlocProvider(
      create: (BuildContext context) => SocialRegisterCubit(),
      child: BlocConsumer<SocialRegisterCubit, SocialRegisterStates>(
        listener: (context, state) {
          if (state is SocialRegisterSuccessStates) {
            showToast(
                text: 'Register Done Successfully', state: ToastStates.SUCCESS);
            CacheHelper.saveData('uId', state.uId);
            navigateAndFinish(context, HomeLayout());
          } else if (state is SocialRegisterErrorStates) {
            showToast(text: state.error, state: ToastStates.ERROR);
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Register',
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 18,
                        ),
                        Text(
                          'register now to communicate with friends',
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(
                          height: 18,
                        ),
                        defaultFormField(
                          controller: namedController,
                          validate: (String? value) {
                            if (value!.isEmpty) {
                              return 'name must not be empty';
                            }
                            return null;
                          },
                          prefix: Icons.drive_file_rename_outline,
                          label: 'Name',
                          type: TextInputType.name,
                        ),
                        SizedBox(
                          height: 18,
                        ),
                        defaultFormField(
                          controller: emailController,
                          validate: (String? value) {
                            if (value!.isEmpty) {
                              return 'email address must not be empty';
                            }
                            return null;
                          },
                          prefix: Icons.email,
                          label: 'Email Address',
                          type: TextInputType.emailAddress,
                        ),
                        SizedBox(
                          height: 18,
                        ),
                        defaultFormField(
                          controller: phoneController,
                          validate: (String? value) {
                            if (value!.isEmpty) {
                              return 'phone address must not be empty';
                            }
                            return null;
                          },
                          prefix: Icons.phone,
                          label: 'Phone',
                          type: TextInputType.phone,
                        ),
                        SizedBox(
                          height: 18,
                        ),
                        defaultFormField(
                          controller: passwordController,
                          validate: (String? value) {
                            if (value!.isEmpty) {
                              return 'password must not be empty';
                            }
                            return null;
                          },
                          prefix: Icons.lock,
                          suffix: SocialRegisterCubit.get(context).suffix,
                          suffixPressed: () {
                            SocialRegisterCubit.get(context)
                                .changePasswordVisibility();
                          },
                          obSecureText:
                              SocialRegisterCubit.get(context).isPassword,
                          label: 'Password',
                          type: TextInputType.visiblePassword,
                        ),
                        SizedBox(
                          height: 18,
                        ),
                        ConditionalBuilder(
                          condition: state is! SocialRegisterLoadingStates,
                          builder: (context) => Container(
                            width: double.infinity,
                            color: Colors.blue,
                            child: defaultMaterialButton(
                                text: 'Register',
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    SocialRegisterCubit.get(context)
                                        .userRegister(
                                            name: namedController.text,
                                            email: emailController.text,
                                            password: passwordController.text,
                                            phone: phoneController.text);
                                  }
                                }),
                          ),
                          fallback: (context) =>
                              Center(child: CircularProgressIndicator()),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
