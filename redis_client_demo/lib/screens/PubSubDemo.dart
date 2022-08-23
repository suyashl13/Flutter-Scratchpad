import 'dart:math';

import 'package:flutter/material.dart';
import 'package:redis/redis.dart';

class PubSubDemo extends StatefulWidget {
  const PubSubDemo({Key? key}) : super(key: key);

  @override
  State<PubSubDemo> createState() => _PubSubDemoState();
}

class _PubSubDemoState extends State<PubSubDemo> {
  RedisConnection conn = RedisConnection();
  RedisConnection bConn = RedisConnection();

  bool isLoading = true;

  late PubSub pubsub;
  late Command cmd;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _init();
  }

  _init() async {
    try {
      cmd = await conn.connect(
          'redis-11558.c305.ap-south-1-1.ec2.cloud.redislabs.com', 11558);
      cmd.send_object(['AUTH', '3SSs9XBYAVP5vDOwXKGvDYs0XTq3a6Mh']);

      pubsub = PubSub(cmd);
      pubsub.subscribe(['message-channel']);
    } catch (e) {
      print(e);
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Redis DB Demo", style: TextStyle(fontSize: 16)),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : StreamBuilder(
              stream: pubsub.getStream(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text("ERROR"));
                }
                if (!snapshot.hasData) {
                  return const Center(child: Text("Loading..."));
                }
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Random: " + snapshot.data.toString(),
                        style: TextStyle(fontSize: 18),
                      ),
                      MaterialButton(
                          color: Colors.blue,
                          child: const Text("New Random"),
                          onPressed: () {
                            RedisConnection()
                                .connect(
                                    'redis-11558.c305.ap-south-1-1.ec2.cloud.redislabs.com',
                                    11558)
                                .then((value) {
                              value.send_object(
                                  ['AUTH', '3SSs9XBYAVP5vDOwXKGvDYs0XTq3a6Mh']);
                              value.send_object([
                                'PUBLISH',
                                'message-channel',
                                '${Random().nextInt(100)}'
                              ]);
                            });
                          })
                    ],
                  ),
                );
              },
            ),
    );
  }
}
