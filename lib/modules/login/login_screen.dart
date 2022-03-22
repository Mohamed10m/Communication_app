import 'dart:ui';

import 'package:communication_app/layout/home_layout.dart';
import 'package:communication_app/modules/login/cubit/login_cubit.dart';
import 'package:communication_app/modules/login/cubit/login_states.dart';
import 'package:communication_app/modules/register/register_screen.dart';
import 'package:communication_app/shared/componants/componants.dart';
import 'package:communication_app/shared/network/local/cache_helper.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SocialLoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    var emailController = TextEditingController();
    var passwordController = TextEditingController();

    return BlocProvider(
      create: (BuildContext context) => SocialLoginCubit(),
      child: BlocConsumer<SocialLoginCubit, SocialLoginStates>(
          listener: (context, state) {
        if (state is SocialLoginErrorStates) {
          showToast(text: state.error, state: ToastStates.ERROR);
        }
        if (state is SocialLoginSuccessStates) {
          CacheHelper.saveData('uId', state.uId).then((value) {
            showToast(
                text: 'Login Done Successfully', state: ToastStates.SUCCESS);

            navigateAndFinish(context, HomeLayout());
          });
        }
        ;
      }, builder: (context, state) {
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
                        'Login',
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 18,
                      ),
                      Text(
                        'login now to communicate with friends',
                        style: TextStyle(color: Colors.grey),
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
                        controller: passwordController,
                        validate: (String? value) {
                          if (value!.isEmpty) {
                            return 'password must not be empty';
                          }
                          return null;
                        },
                        onFieldSubmitted: (String value) {
                          if (formKey.currentState!.validate()) {
                            SocialLoginCubit.get(context).userLogin(
                                email: emailController.text,
                                password: passwordController.text);
                          }
                        },
                        prefix: Icons.lock,
                        suffix: SocialLoginCubit.get(context).suffix,
                        suffixPressed: () {
                          SocialLoginCubit.get(context)
                              .changePasswordVisibility();
                        },
                        obSecureText: SocialLoginCubit.get(context).isPassword,
                        label: 'Password',
                        type: TextInputType.visiblePassword,
                      ),
                      SizedBox(
                        height: 18,
                      ),
                      ConditionalBuilder(
                          condition: state is! SocialLoginLoadingStates,
                          builder: (context) => defaultMaterialButton(
                              text: 'login',
                              isUpperCase: true,
                              color: Colors.blue,
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  SocialLoginCubit.get(context).userLogin(
                                      email: emailController.text,
                                      password: passwordController.text);
                                }
                              }),
                          fallback: (context) =>
                              Center(child: CircularProgressIndicator())),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Don\'t have an account',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextButton(
                              onPressed: () {
                                navigateTo(context, SocialRegisterScreen());
                              },
                              child: Text(
                                'Register',
                                style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold,),
                              ))
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
