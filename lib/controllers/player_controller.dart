import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class PlayerController extends GetxController{
  final audioQuery = OnAudioQuery();
  final audioPlayer = AudioPlayer();

  List<SongModel> playlist = [];

  var playIndex = 0.obs;
  var isPlaying = false.obs;

  var position = "".obs;
  var duration = "".obs;

  var max = 0.0.obs;
  var value = 0.0.obs;

  @override
  void onInit() {
    super.onInit();

    checkStoragePermission();

    // should listen on the first play
    audioPlayer.playerStateStream.listen((event) {
      if(event.processingState == ProcessingState.completed){
        if(playIndex.value + 1 >= playlist.length){
          playSongByIndex(playlist, 0);
        }else{
          playSongByIndex(playlist, playIndex.value + 1);
        }

        return;
      }
    });
  }

  checkStoragePermission() async {
    var permissionStorage = await Permission.storage.request();

    if(permissionStorage.isGranted){
    }else{
      checkStoragePermission();
    }
  }

  playSongByIndex(data, index) async {
    try{
      playlist = data;
      playIndex.value = index;

      audioPlayer.setAudioSource(
        AudioSource.uri(Uri.parse(data[index].uri))
      );
      await playSong();
      
      updatePosition();

    } on Exception catch(e){
      print(e.toString());
    }
  }

  playSong(){
    audioPlayer.play();
    isPlaying(true);
  }

  testdebug(test){
    print("debugging: " + test.toString());
  }

  pauseSong(){
    audioPlayer.pause();
    isPlaying(false);
  }

  updatePosition(){
    audioPlayer.positionStream.listen((event) {
      position.value = event.toString().split('.')[0];
      value.value = event.inSeconds.toDouble();
    });
    audioPlayer.durationStream.listen((event) {
      duration.value = event.toString().split('.')[0];
      max.value = event!.inSeconds.toDouble();
    });
  }

  changeDurationToSeconds(seconds){
    var duration = Duration(seconds: seconds);
    audioPlayer.seek(duration);
  }
}