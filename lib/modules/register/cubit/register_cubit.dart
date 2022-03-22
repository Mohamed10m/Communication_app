import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:communication_app/model/social_user_model.dart';
import 'package:communication_app/modules/register/cubit/register_states.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SocialRegisterCubit extends Cubit<SocialRegisterStates> {
  SocialRegisterCubit() : super(SocialRegisterInitialStates());

  static SocialRegisterCubit get(context) => BlocProvider.of(context);

  void userRegister(
      {required String name,
      required String email,
      required String password,
      required String phone}) {
    emit(SocialRegisterLoadingStates());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      userCreate(name: name, email: email, phone: phone, uId: value.user!.uid);
      print(value.credential);
      emit(SocialRegisterSuccessStates(value.user!.uid));
    }).catchError((error) {
      emit(SocialRegisterErrorStates(error.toString()));
    });
  }

  void userCreate(
      {required String name,
      required String email,
      required String phone,
      required String uId}) {
    SocialUserModel model = SocialUserModel(
      name: name,
      email: email,
      phone: phone,
      image:
          'https://tse4.mm.bing.net/th?id=OIP.PYipJ_hSncugM2SwnZitvgHaEK&pid=Api&P=0&w=280&h=157',
      cover:
          'https://tse4.mm.bing.net/th?id=OIP.Dn92YJxy3ROAUsHMi0U2ogHaE8&pid=Api&P=0&w=255&h=170',
      bio: 'write your bio ...',
      uId: uId,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(model.toMap())
        .then((value) {
      userCreate(name: name, email: email, phone: phone, uId: uId);
      print(uId);
    }).catchError((error) {
      emit(SocialCreateUserErrorStates(error.toString()));
    });
  }

  bool isPassword = true;
  IconData suffix = Icons.visibility_outlined;
  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined;
    emit(SocialRegisterChangePasswordStates());
  }
}
