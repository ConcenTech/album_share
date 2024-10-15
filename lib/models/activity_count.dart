import '../core/utils/app_localisations.dart';

class ActivityCount {
  ActivityCount();

  int imageLikes = 0;
  int videoLikes = 0;
  int otherLikes = 0;

  int imageComments = 0;
  int videoComments = 0;
  int otherComments = 0;

  void describe(StringBuffer buf, String name, AppLocalizations locale) {
    buf.writeAll([
      if (imageLikes > 0) locale.userLikedImages(imageLikes, name),
      if (imageComments > 0) locale.userCommentedImages(imageComments, name),
      if (videoLikes > 0) locale.userLikedVideos(videoLikes, name),
      if (videoComments > 0) locale.userCommentedVideos(videoComments, name),
      if (otherLikes > 0) locale.userLikedOther(otherLikes, name),
      if (otherComments > 0) locale.userCommentedOther(otherComments, name),
    ], '\n');
  }
}
