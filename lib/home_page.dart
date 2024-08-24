import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int s = 0, m = 0, h = 0;
  String digsec = '00', digmin = '00', dighr = '00';
  Timer? timer;
  bool started = false;

  List<String> Laps = [];

  void stop() {
    timer?.cancel();
    setState(() {
      started = false;
    });
  }

  void reset() {
    timer?.cancel();
    setState(() {
      s = 0;
      h = 0;
      m = 0;
      digsec = "00";
      digmin = "00";
      dighr = "00";
      started = false;
      Laps.clear();
    });
  }

  void start() {
    setState(() {
      started = true;
    });
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        int localsec = s + 1;
        int localmin = m;
        int localhr = h;

        if (localsec > 59) {
          localsec = 0;
          localmin++;
          if (localmin > 59) {
            localmin = 0;
            localhr++;
          }
        }

        s = localsec;
        m = localmin;
        h = localhr;

        digsec = (s >= 10) ? "$s" : "0$s";
        digmin = (m >= 10) ? "$m" : "0$m";
        dighr = (h >= 10) ? "$h" : "0$h";
      });
    });
  }

  void addLaps() {
    String lap = "$dighr:$digmin:$digsec";
    setState(() {
      Laps.add(lap);
    });
  }

  Widget _build3DText(String text) {
    return Stack(
      children: [
        Positioned(
          top: 2,
          left: 2,
          child: Text(
            text,
            style: TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.bold,
              color: Colors.blue.withOpacity(0.5),
            ),
          ),
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 50,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                offset: Offset(4, 4),
                blurRadius: 4.0,
                color: Colors.blueAccent,
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1c2657),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  'Stopwatch',
                  style: TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    color: Color(0XFF313E66),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _build3DText(dighr),
                        _build3DText(":"),
                        _build3DText(digmin),
                        _build3DText(":"),
                        _build3DText(digsec),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: Laps.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Lap ${index + 1}',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          Text(
                            Laps[index],
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: RawMaterialButton(
                      onPressed: () {
                        (!started) ? start() : stop();
                      },
                      shape: StadiumBorder(
                        side: BorderSide(color: Colors.blue),
                      ),
                      child: Text(
                        (!started) ? 'Start' : 'Stop',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.0),
                  IconButton(
                    onPressed: addLaps,
                    icon: Icon(
                      Icons.flag,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: RawMaterialButton(
                      onPressed: reset,
                      fillColor: Colors.blue,
                      shape: StadiumBorder(),
                      child: Text(
                        'Reset',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
