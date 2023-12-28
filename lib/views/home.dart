import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player_flutter/consts/colors.dart';
import 'package:music_player_flutter/consts/text_style.dart';
import 'package:music_player_flutter/controllers/player_controller.dart';
import 'package:music_player_flutter/views/player.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(PlayerController());

    return Scaffold(
        backgroundColor: bgDarkColor,
        appBar: AppBar(
          backgroundColor: bgDarkColor,
          actions: [
            IconButton(
                onPressed: () {},
                icon: const Icon(Icons.search, color: whiteColor))
          ],
          leading: const Icon(Icons.sort_rounded, color: whiteColor),
          centerTitle: true,
          title: Text("Vibes",
              style: ourStyle(fontweight: FontWeight.bold, size: 18)),
        ),
        body: FutureBuilder<List<SongModel>>(
          future: controller.audioQuery.querySongs(
              ignoreCase: true,
              orderType: OrderType.ASC_OR_SMALLER,
              sortType: null,
              uriType: UriType.EXTERNAL),
          builder: (context, snapshot) {
            // Remove file that's not mp3
            snapshot.data
                ?.removeWhere((element) => element.fileExtension != 'mp3');

            if (snapshot.data == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.data!.isEmpty) {
              return Center(
                  child: Text(
                "No song found",
                style: ourStyle(),
              ));
            } else {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 4),
                        child: Obx(
                          () => ListTile(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            tileColor: bgColor,
                            title: Text(
                              snapshot.data![index].displayName,
                              style: ourStyle(
                                  fontweight: FontWeight.bold, size: 15),
                            ),
                            subtitle: Text(
                              "${snapshot.data![index].artist}",
                              style: ourStyle(
                                  fontweight: FontWeight.normal, size: 12),
                            ),
                            leading: QueryArtworkWidget(
                              id: snapshot.data![index].id,
                              type: ArtworkType.AUDIO,
                              nullArtworkWidget: const Icon(Icons.music_note,
                                  color: whiteColor, size: 32),
                            ),
                            trailing: controller.playIndex.value == index &&
                                    controller.isPlaying.value
                                ? const Icon(
                                    Icons.play_arrow,
                                    color: whiteColor,
                                    size: 26,
                                  )
                                : const SizedBox(
                                  width: 26,
                                ),
                                  
                            onTap: () {
                              Get.to(() => Player(data: snapshot.data!));
                              if(controller.playIndex.value != index){
                                controller.playSongByIndex(
                                    snapshot.data, index);
                              }

                            },
                          ),
                        ),
                      );
                    }),
              );
            }
          },
        ));
  }
}
