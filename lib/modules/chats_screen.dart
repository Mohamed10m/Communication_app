import 'package:communication_app/layout/cubit/home_layout_cubit.dart';
import 'package:communication_app/layout/cubit/home_layout_states.dart';
import 'package:communication_app/model/social_user_model.dart';
import 'package:communication_app/modules/chat_details.dart';
import 'package:communication_app/shared/componants/componants.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return ConditionalBuilder(
              condition: SocialCubit.get(context).users.length > 0,
              builder: (context) => ListView.separated(
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) => buildChatItems(
                      SocialCubit.get(context).users[index], context),
                  separatorBuilder: (context, index) => SizedBox(
                        height: 10.0,
                      ),
                  itemCount: SocialCubit.get(context).users.length),
              fallback: (context) =>
                  Center(child: CircularProgressIndicator()));
        });
  }

  Widget buildChatItems(SocialUserModel model, context) => InkWell(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage('${model.image}'),
              ),
              SizedBox(
                width: 20.0,
              ),
              Text(
                '${model.name}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        onTap: () {
          navigateTo(context, ChatDetailsScreen(userModel: model));
        },
      );
}
