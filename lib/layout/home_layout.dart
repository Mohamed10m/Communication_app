import 'package:communication_app/layout/cubit/home_layout_cubit.dart';
import 'package:communication_app/layout/cubit/home_layout_states.dart';
import 'package:communication_app/modules/post_screen.dart';
import 'package:communication_app/shared/componants/componants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {
          if (state is SocialInitialStates) {
          } else if (state is NewPostStates) {
            navigateTo(context, NewPostScreen());
          }
        },
        builder: (context, state) {
          var cubit = SocialCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title: Text(cubit.titles[cubit.currentIndex]),
              actions: [
                IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.notification_important_outlined)),
                IconButton(onPressed: () {}, icon: Icon(Icons.search)),
              ],
            ),
            body: cubit.bottomScreens[cubit.currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeBottom(index);
              },
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.chat_rounded), label: 'Chats'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.post_add), label: 'Post'),

                BottomNavigationBarItem(
                    icon: Icon(Icons.settings), label: 'Settings'),
              ],
            ),
          );
        },

    );
  }
}
