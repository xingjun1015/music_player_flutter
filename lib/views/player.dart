import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player_flutter/consts/colors.dart';
import 'package:music_player_flutter/consts/text_style.dart';
import 'package:music_player_flutter/controllers/player_controller.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Player extends StatelessWidget {
  final List<SongModel> data;
  const Player({super.key, required this.data});

  @override
  Widget build(BuildContext context) {

    var controller = Get.find<PlayerController>();

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Obx(
              () => Expanded(
                  child: Container(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                height: 300,
                width: 300,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.red),
                alignment: Alignment.center,
                child: QueryArtworkWidget(
                  id: data[controller.playIndex.value].id,
                  type: ArtworkType.AUDIO,
                  artworkHeight: double.infinity,
                  artworkWidth: double.infinity,
                  nullArtworkWidget: const Icon(Icons.music_note),
                ),
              )),
            ),
            const SizedBox(
              height: 12,
            ),
            Expanded(
                child: Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                  color: whiteColor,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(16))),
              child: Obx(
                () => Column(
                  children: [
                    Text(
                      data[controller.playIndex.value].displayNameWOExt,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: ourStyle(
                          color: bgDarkColor,
                          fontweight: FontWeight.bold,
                          size: 18),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      data[controller.playIndex.value].artist.toString(),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: ourStyle(
                          color: bgDarkColor,
                          fontweight: FontWeight.normal,
                          size: 14),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Obx(
                      () => Row(
                        children: [
                          Text(
                            controller.position.value,
                            style: ourStyle(color: bgDarkColor),
                          ),
                          Expanded(
                              child: Slider(
                                  min: const Duration(seconds: 0).inSeconds.toDouble(),
                                  max: controller.max.value + 1,
                                  value: controller.value.value,
                                  thumbColor: sliderColor,
                                  activeColor: sliderColor,
                                  inactiveColor: bgColor,
                                  onChanged: (newValue) {
                                    controller.changeDurationToSeconds(newValue.toInt());
                                    newValue = newValue;
                                  })),
                          Text(
                            controller.duration.value,
                            style: ourStyle(color: bgDarkColor),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                            onPressed: () {
                              int previousIndex = controller.playIndex.value - 1;
                              if(previousIndex < 0){
                                previousIndex = data.length - 1;
                              }
                              controller.playSongByIndex(data, previousIndex);
                            },
                            icon: const Icon(
                              Icons.skip_previous_rounded,
                              size: 40,
                              color: bgDarkColor,
                            )),
                        Obx(
                          () => CircleAvatar(
                              radius: 35,
                              backgroundColor: bgDarkColor,
                              child: Transform.scale(
                                scale: 2.5,
                                child: IconButton(
                                    onPressed: () {
                                      if(controller.isPlaying.value){
                                        controller.pauseSong();
                                      }else{
                                        controller.playSong();
                                      }
                                    },
                                    icon: controller.isPlaying.value 
                                    ? const Icon(
                                      Icons.pause_rounded,
                                      color: whiteColor,
                                    )
                                    : const Icon(
                                      Icons.play_arrow_rounded,
                                      color: whiteColor,
                                    )),
                              )),
                        ),
                        IconButton(
                            onPressed: () {
                              int nextIndex = controller.playIndex.value + 1;
                              if(nextIndex >= data.length){
                                nextIndex = 0;
                              }
                              controller.playSongByIndex(data, nextIndex);
                            },
                            icon: const Icon(
                              Icons.skip_next_rounded,
                              size: 40,
                              color: bgDarkColor,
                            )),
                      ],
                    )
                  ],
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
