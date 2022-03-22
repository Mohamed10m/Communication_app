import 'package:communication_app/layout/cubit/home_layout_cubit.dart';
import 'package:communication_app/layout/cubit/home_layout_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewPostScreen extends StatelessWidget {
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Add Post'),
            titleSpacing: 0.0,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios_rounded)),
            actions: [
              TextButton(
                  onPressed: () {
                    var now = DateTime.now();
                    if (SocialCubit.get(context).postImage == null) {
                      SocialCubit.get(context).createPost(
                          dateTime: now.toString(), text: textController.text);
                    } else {
                      SocialCubit.get(context).uploadPostImage(
                          dateTime: now.toString(), text: textController.text);
                    }
                  },
                  child: Text('Post'))
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(
                          '${SocialCubit.get(context).userModel!.image}'),
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    Expanded(
                      child: Text(
                        '${SocialCubit.get(context).userModel!.name}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: TextFormField(
                    controller: textController,
                    decoration: InputDecoration(
                        hintText: 'what is in your mind ...',
                        border: InputBorder.none),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                if (SocialCubit.get(context).postImage != null)
                  Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: [
                      Container(
                        height: 140.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.0),
                            image: DecorationImage(
                                image: FileImage(
                                    SocialCubit.get(context).postImage!),
                                fit: BoxFit.cover)),
                      ),
                      IconButton(
                          onPressed: () {
                            SocialCubit.get(context).removePostImage();
                          },
                          icon: CircleAvatar(
                              radius: 20.0,
                              child: Icon(
                                Icons.close,
                                size: 16,
                              )))
                    ],
                  ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                          onPressed: () {
                            SocialCubit.get(context).getPostImage();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.image),
                              SizedBox(
                                width: 5,
                              ),
                              Text('add photo')
                            ],
                          )),
                    ),
                    Expanded(
                      child:
                          TextButton(onPressed: () {}, child: Text('# Tags')),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
