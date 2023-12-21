import 'package:get/get.dart';
import 'package:wallpaper/api/api.dart';

class PhotosController extends GetxController {
  RxList photos = [].obs;

  getTrendingPhotos() async {
    photos.value = await ApiOperations().getTrendingWallpapers();
  }

  getSearchPhotos(String query) async {
    photos.value = await ApiOperations().getSearchResults(query);
  }
}
