import 'package:flutter/material.dart';
import 'package:media_player_app/models/channel_model.dart';
import 'package:media_player_app/models/video_model.dart';
import 'package:media_player_app/screens/pdf_screen.dart';
import 'package:media_player_app/screens/video_player_screen.dart';
import 'package:media_player_app/services/api_services.dart';

import 'package:svg_flutter/svg.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Channel _channel;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initChannel();
  }

  _initChannel() async {
    Channel channel = await APIService.instance
        .fetchChannel(channelId: 'UC6Dy0rQ6zDnQuHQ1EeErGUA');
    setState(() {
      _channel = channel;
    });
  }

  _buildVideo(Video video) {
    // ignore: unnecessary_null_comparison
    if (_channel == null) {
      return const CircularProgressIndicator();
    }
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VideoScreen(id: video.id),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
        padding: const EdgeInsets.all(10.0),
        height: 140.0,
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 1),
              blurRadius: 6.0,
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            Image(
              width: 150.0,
              image: NetworkImage(video.thumbnailUrl),
            ),
            const SizedBox(width: 10.0),
            Expanded(
              child: Text(
                video.title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _loadMoreVideos() async {
    // ignore: unnecessary_null_comparison
    if (_channel == null) {
      return const CircularProgressIndicator();
    }
    _isLoading = true;
    List<Video> moreVideos = await APIService.instance
        .fetchVideosFromPlaylist(playlistId: _channel.uploadPlaylistId);
    List<Video> allVideos = _channel.videos..addAll(moreVideos);
    setState(() {
      _channel.videos = allVideos;
    });
    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: getAppBAr(), body: getVideo());
  }

  AppBar getAppBAr() {
    return AppBar(
      backgroundColor: const Color(0xFFF32509),
      leading: const DrawerButton(),
      toolbarHeight: 120,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: getPdfButton(),
        ),
      ],
    );
  }

  Widget getVideo() {
    // ignore: unnecessary_null_comparison
    return _channel != null
        ? NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollDetails) {
              if (!_isLoading &&
                  _channel.videos.length != int.parse(_channel.videoCount) &&
                  scrollDetails.metrics.pixels ==
                      scrollDetails.metrics.maxScrollExtent) {
                _loadMoreVideos();
              }
              return false;
            },
            child: ListView.builder(
              itemCount: _channel.videos.length,
              itemBuilder: (BuildContext context, int index) {
                // if (index == 0) {
                //   return _buildProfileInfo();
                // }
                Video video = _channel.videos[index - 0];
                return _buildVideo(video);
              },
            ),
          )
        : Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).primaryColor, // Red
              ),
            ),
          );
  }

  Widget getPdfButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const PdfScreen()));
        },
        child: Container(
          height: 60,
          width: 120,
          decoration: BoxDecoration(
            border: Border.all(width: 2, color: const Color(0xFF000000)),
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
            color: const Color(0xFFFEFEFE),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                "assets/icons/pdficon.svg",
                width: 30,
              ),
              const SizedBox(
                width: 5,
              ),
              RichText(
                text: const TextSpan(
                    text: 'PDF',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Roboto',
                      color: Color(0xFF2F86DE),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
