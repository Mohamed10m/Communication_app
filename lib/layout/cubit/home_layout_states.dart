abstract class SocialStates {}

class SocialInitialStates extends SocialStates {}

class ShopChangeBottomNavState extends SocialStates {}

class SocialGetUserLoadingStates extends SocialStates {}

class SocialGetUserSuccessStates extends SocialStates {}

class SocialGetUserErrorStates extends SocialStates {}

class SocialUpdateUserErrorStates extends SocialStates {}
class SocialUpdateUserSuccessStates extends SocialStates {}

class SocialProfileImagePickerSuccessStates extends SocialStates {}

class SocialProfileImagePickerErrorStates extends SocialStates {}

class SocialCoverImagePickerSuccessStates extends SocialStates {}

class SocialCoverImagePickerErrorStates extends SocialStates {}

class SocialUploadProfileImageSuccessStates extends SocialStates {}

class SocialUploadProfileImageErrorStates extends SocialStates {}

class SocialUploadCoverImageSuccessStates extends SocialStates {}

class SocialUploadCoverImageErrorStates extends SocialStates {}

class NewPostStates extends SocialStates {}

class SocialCreatePostLoadingStates extends SocialStates {}

class SocialCreatePostSuccessStates extends SocialStates {}

class SocialCreatePostErrorStates extends SocialStates {}

class SocialPostImagePickerSuccessStates extends SocialStates {}

class SocialPostImagePickerErrorStates extends SocialStates {}

class SocialRemovePostImageStates extends SocialStates {}

class SocialGetPostSuccessStates extends SocialStates {}

class SocialGetPostErrorStates extends SocialStates {
  final String error;

  SocialGetPostErrorStates(this.error);
}class SocialGetCommentSuccessStates extends SocialStates {}

class SocialGetCommentErrorStates extends SocialStates {
  final String error;

  SocialGetCommentErrorStates(this.error);
}

class SocialLikePostSuccessStates extends SocialStates {}

class SocialLikePostErrorStates extends SocialStates {
  final String error;

  SocialLikePostErrorStates(this.error);
}
class SocialCommentPostSuccessStates extends SocialStates {}

class SocialCommentPostErrorStates extends SocialStates {
  final String error;

  SocialCommentPostErrorStates(this.error);
}

class SocialGetAllUserSuccessStates extends SocialStates {}

class SocialGetAllUserErrorStates extends SocialStates {}

class SocialSendMessageSuccessStates extends SocialStates {}

class SocialSendMessageErrorStates extends SocialStates {}

class SocialReceiveMessageSuccessStates extends SocialStates {}

class SocialReceiveMessageErrorStates extends SocialStates {}

class SocialRemoveUidStates extends SocialStates {}
