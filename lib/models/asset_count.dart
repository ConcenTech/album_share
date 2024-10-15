import '../core/utils/app_localisations.dart';

class AssetCount {
  AssetCount([this.photos = 0, this.videos = 0, this.others = 0]);

  int photos;
  int videos;
  int others;

  void describe(StringBuffer buf, String name, AppLocalizations locale) {
    buf.writeAll([
      if (photos > 0) locale.userUploadedImages(photos, name),
      if (videos > 0) locale.userUploadedVideos(videos, name),
      if (others > 0) locale.userUploadedOther(others, name),
    ], '\n');
  }
}
