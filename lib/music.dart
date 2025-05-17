import 'package:flutter/material.dart';


class MusicScreen extends StatefulWidget {
  const MusicScreen({super.key});


  @override
  _MusicScreenState createState() => _MusicScreenState();
}


class _MusicScreenState extends State<MusicScreen> {
  double _currentPosition = 0.0;
  final double _totalDuration = 300.0; // Example duration (5 minutes)
  bool _isPlaying = false;


  void _playPause() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }


  void _seekTo(double value) {
    setState(() {
      _currentPosition = value;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Now Playing'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Song Artwork
            Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: const DecorationImage(
                  image: AssetImage('assets/song_cover.jpg'), // Placeholder image
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
           
            // Song Details
            const Text(
              'Song Title - Artist Name',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Composer/Artist',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 30),
           
            // Progress Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${_currentPosition.toStringAsFixed(0)}s'),
                Expanded(
                  child: Slider(
                    value: _currentPosition,
                    min: 0.0,
                    max: _totalDuration,
                    onChanged: _seekTo,
                    activeColor: Colors.deepPurple,
                    inactiveColor: Colors.grey,
                  ),
                ),
                Text('${(_totalDuration - _currentPosition).toStringAsFixed(0)}s'),
              ],
            ),
           
            // Play/Pause Button
            IconButton(
              icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow, size: 40),
              onPressed: _playPause,
              color: Colors.deepPurple,
            ),
           
            // Navigation Buttons (Previous/Next Song)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.skip_previous, size: 40),
                  onPressed: () {},
                  color: Colors.deepPurple,
                ),
                IconButton(
                  icon: const Icon(Icons.skip_next, size: 40),
                  onPressed: () {},
                  color: Colors.deepPurple,
                ),
              ],
            ),
           
            // Add to Playlist Button
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
              child: const Text('Add to Playlist'),


            ),
          ],
        ),
      ),
    );
  }
}