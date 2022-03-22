import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:communication_app/layout/cubit/home_layout_states.dart';
import 'package:communication_app/model/message_model.dart';
import 'package:communication_app/model/post_model.dart';
import 'package:communication_app/model/social_user_model.dart';
import 'package:communication_app/modules/chats_screen.dart';
import 'package:communication_app/modules/home_screen.dart';
import 'package:communication_app/modules/post_screen.dart';
import 'package:communication_app/modules/settings_screen.dart';
import 'package:communication_app/shared/end_points.dart';
import 'package:communication_app/shared/network/local/cache_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(SocialInitialStates());

  static SocialCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> bottomScreens = [
    HomeScreen(),
    ChatsScreen(),
    NewPostScreen(),
    SettingsScreen()
  ];

  List<String> titles = [
    'Home',
    'Chats',
    'Post',
    'Settings',
  ];

  void changeBottom(int index) {
    if (index == 1) getUsers();
    if (index == 2)
      emit(NewPostStates());
    else {
      currentIndex = index;
      emit(ShopChangeBottomNavState());
    }
  }

  SocialUserModel? userModel;
  Future<void> getUserData() async {
    if (uId != null) {
      emit(SocialGetUserLoadingStates());
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uId)
          .get()
          .then((value) {
        userModel = SocialUserModel.fromJson(value.data()!);
        emit(SocialGetUserSuccessStates());
      }).catchError((error) {
        print(error.toString());
        emit(SocialGetUserErrorStates());
      });
    }
  }

  File? profileImage;
  var picker = ImagePicker();
  Future<void> getProfileImage() async {
    final PickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (PickedFile != null) {
      profileImage = File(PickedFile.path);
      emit(SocialProfileImagePickerSuccessStates());
    } else {
      print('no image selected');
      emit(SocialProfileImagePickerErrorStates());
    }
  }

  File? coverImage;

  Future<void> getCoverImage() async {
    final PickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (PickedFile != null) {
      coverImage = File(PickedFile.path);
      emit(SocialCoverImagePickerSuccessStates());
    } else {
      print('no image selected');
      emit(SocialCoverImagePickerErrorStates());
    }
  }

  void uploadProfileImage(
      {required String name,
      required String email,
      required String bio}) async {
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then((r0) {
      r0.ref.getDownloadURL().then((value) {
        update(name: name, email: email, bio: bio, image: value);
        print(value);
        emit(SocialUploadProfileImageSuccessStates());
      }).catchError((error) {
        emit(SocialUploadProfileImageErrorStates());
        print(error.toString());
      });
    }).catchError((error) {
      emit(SocialUploadProfileImageErrorStates());
    });
  }

  String coverURL = '';

  void uploadCoverImage(
      {required String name, required String email, required String bio}) {
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(coverImage!.path).pathSegments.last}')
        .putFile(coverImage!)
        .then((r0) {
      print(coverImage!.path);
      r0.ref.getDownloadURL().then((value) {
        emit(SocialUploadCoverImageSuccessStates());
        update(name: name, email: email, bio: bio, cover: value);
      }).catchError((error) {
        emit(SocialUploadCoverImageErrorStates());
      });
    }).catchError((error) {
      emit(SocialUploadCoverImageErrorStates());
    });
  }

  void update({
    required String name,
    required String email,
    required String bio,
    String? cover,
    String? image,
  }) {
    SocialUserModel model = SocialUserModel(
      name: name,
      email: email,
      image: image ?? userModel!.image,
      cover: cover ?? userModel!.cover,
      phone: userModel!.phone,
      bio: bio,
      uId: uId,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(model.uId)
        .update(model.toMap())
        .then((value) {
      getUserData();
      emit(SocialUpdateUserSuccessStates());
    }).catchError((error) {
      emit(SocialUpdateUserErrorStates());
    });
  }

  File? postImage;

  Future<void> getPostImage() async {
    final PickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (PickedFile != null) {
      postImage = File(PickedFile.path);
      emit(SocialPostImagePickerSuccessStates());
    } else {
      print('no image selected');
      emit(SocialPostImagePickerErrorStates());
    }
  }

  void removePostImage() {
    postImage = null;
    emit(SocialRemovePostImageStates());
  }

  void uploadPostImage({
    required String dateTime,
    required String text,
  }) {
    emit(SocialCreatePostLoadingStates());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(postImage!.path).pathSegments.last}')
        .putFile(postImage!)
        .then((r0) {
      r0.ref.getDownloadURL().then((value) {
        emit(SocialCreatePostSuccessStates());

        createPost(dateTime: dateTime, text: text, postImage: value);
      }).catchError((error) {
        emit(SocialCreatePostErrorStates());
      });
    }).catchError((error) {
      emit(SocialCreatePostErrorStates());
    });
  }

  void createPost({
    required String dateTime,
    required String text,
    String? postImage,
  }) {
    emit(SocialCreatePostLoadingStates());

    PostModel model = PostModel(
      name: userModel!.name,
      image: userModel!.image,
      uId: userModel!.uId,
      dateTime: dateTime,
      postImage: postImage ?? '',
      text: text,
    );
    FirebaseFirestore.instance
        .collection('posts')
        .add(model.toMap())
        .then((value) {
      emit(SocialCreatePostSuccessStates());
    }).catchError((error) {
      SocialCreatePostErrorStates();
    });
  }

  List<PostModel> posts = [];
  List<String> postsId = [];
  List<int> likes = [];

  void getPosts() async {
    await FirebaseFirestore.instance.collection('posts').get().then((value) {
      value.docs.forEach((element) {
        element.reference.collection('likes').get().then((value) {
          likes.add(value.docs.length);
          postsId.add(element.id);
          posts.add(PostModel.fromJson(element.data()));

          emit(SocialGetPostSuccessStates());
        }).catchError((error) {});
      });
      emit(SocialGetPostSuccessStates());
    }).catchError((error) {
      emit(SocialGetPostErrorStates(error.toString()));
    });
  }

  void likePost(String postId) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(userModel!.uId)
        .set({'like': true}).then((value) {
      emit(SocialLikePostSuccessStates());
    }).catchError((error) {
      emit(SocialLikePostErrorStates(error.toString()));
    });
  }

  List<SocialUserModel> users = [];
  void getUsers() {
    if (users.length == 0)
      FirebaseFirestore.instance.collection('users').get().then((value) {
        value.docs.forEach((element) {
          if (element.data()['uId'] != userModel!.uId)
            users.add(SocialUserModel.fromJson(element.data()));
          emit(SocialGetAllUserSuccessStates());
        });
      }).catchError((error) {
        emit(SocialGetAllUserErrorStates());
      });
  }

  void SendMessage({
    required String receiverId,
    required String dateTime,
    required String text,
  }) {
    MessageModel model = MessageModel(
        senderId: userModel!.uId,
        text: text,
        dateTime: dateTime,
        receiverId: receiverId);
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      emit(SocialSendMessageSuccessStates());
    }).catchError((error) {
      emit(SocialSendMessageErrorStates());
    });
    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(userModel!.uId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      emit(SocialReceiveMessageSuccessStates());
    }).catchError((error) {
      emit(SocialReceiveMessageErrorStates());
    });
  }

  List<MessageModel> messages = [];

  void getMessage({required String receiverId}) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      messages = [];
      event.docs.forEach((element) {
        messages.add(MessageModel.fromJson(element.data()));
      });
      emit(SocialGetAllUserSuccessStates());
    });
  }

  SignOut() {
    CacheHelper.removeData(key: "uId").then((value) {
      emit(SocialRemoveUidStates());
    });
  }
}
