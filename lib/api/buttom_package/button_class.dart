import 'package:flutter/material.dart';

import '../../multimedia/page_manager.dart';
import '../../service/service.dart';
import 'play_button.dart';
import 'reapete_button.dart';

class AudioControlButtons extends StatelessWidget {
  const AudioControlButtons({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          //  RepeatButton()
          SizedBox(width: 150, child: CurrentSongTitle()),
          PreviousSongButton(),
          PlayButton(),
          NextSongButton(),
          // ShuffleButton(),
        ],
      ),
    );
  }
}

class RepeatButton extends StatelessWidget {
  const RepeatButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<PageManager>();
    return ValueListenableBuilder<RepeatState>(
      valueListenable: pageManager.repeatButtonNotifier,
      builder: (context, value, child) {
        Icon icon;
        switch (value) {
          case RepeatState.off:
            icon = Icon(Icons.repeat, size: 30, color: Colors.blue.shade800);
            break;
          case RepeatState.repeatSong:
            icon =
                Icon(Icons.repeat_one, size: 30, color: Colors.blue.shade800);
            break;
          case RepeatState.repeatPlaylist:
            icon = const Icon(
              Icons.repeat,
              size: 30,
              color: Colors.red,
            );
            break;
        }
        return IconButton(
          iconSize: 20.0,
          icon: icon,
          onPressed: pageManager.repeat,
        );
      },
    );
  }
}

class PreviousSongButton extends StatelessWidget {
  const PreviousSongButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<PageManager>();
    return ValueListenableBuilder<bool>(
      valueListenable: pageManager.isFirstSongNotifier,
      builder: (_, isFirst, __) {
        return IconButton(
          iconSize: 32.0,
          color: Colors.amber[100],
          icon: const Icon(Icons.skip_previous),
          onPressed: (isFirst) ? null : pageManager.previous,
        );
      },
    );
  }
}

class PlayButton extends StatelessWidget {
  const PlayButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<PageManager>();
    return ValueListenableBuilder<ButtonState>(
      valueListenable: pageManager.playButtonNotifier,
      builder: (_, value, __) {
        switch (value) {
          case ButtonState.loading:
            return Container(
              margin: const EdgeInsets.all(8.0),
              width: 32.0,
              height: 32.0,
              child: const CircularProgressIndicator(),
            );
          case ButtonState.paused:
            return IconButton(
              color: Colors.tealAccent,
              icon: const Icon(Icons.play_arrow),
              iconSize: 32.0,
              onPressed: pageManager.play,
            );
          case ButtonState.playing:
            return IconButton(
              color: Colors.amber[100],
              icon: const Icon(Icons.pause),
              iconSize: 32.0,
              onPressed: pageManager.pause,
            );
        }
      },
    );
  }
}

class NextSongButton extends StatelessWidget {
  const NextSongButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<PageManager>();
    return ValueListenableBuilder<bool>(
      valueListenable: pageManager.isLastSongNotifier,
      builder: (_, isLast, __) {
        return IconButton(
          iconSize: 32.0,
          color: Colors.amber[100],
          icon: const Icon(Icons.skip_next),
          onPressed: (isLast) ? null : pageManager.next,
        );
      },
    );
  }
}

class ShuffleButton extends StatelessWidget {
  const ShuffleButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<PageManager>();
    return ValueListenableBuilder<bool>(
      valueListenable: pageManager.isShuffleModeEnabledNotifier,
      builder: (context, isEnabled, child) {
        return IconButton(
          iconSize: 20.0,
          icon: (isEnabled)
              ? const Icon(
                  Icons.shuffle,
                  color: Colors.black,
                  size: 30,
                )
              : Icon(
                  Icons.shuffle,
                  size: 30,
                  color: Colors.blue.shade800,
                ),
          onPressed: pageManager.shuffle,
        );
      },
    );
  }
}

class CurrentSongTitle extends StatelessWidget {
  const CurrentSongTitle({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<PageManager>();
    return ValueListenableBuilder<String>(
      valueListenable: pageManager.currentSongTitleNotifier,
      builder: (_, title, __) {
        return SingleChildScrollView(
            child: Text(title,
                maxLines: 1,
                overflow: TextOverflow.fade,
                style: const TextStyle(fontSize: 24)));
      },
    );
  }
}
