import "dart:async";
import "dart:io";

import "package:nyxx/nyxx.dart";
import "package:nyxx_commander/commander.dart";

void main() {
  final bot = Nyxx(Platform.environment["DISCORD_TOKEN"]!, ignoreExceptions: false);

  bot.onMessageReceived.listen((event) async {
    if (event.message.content == "Test 1") {
      event.message.delete(); // ignore: unawaited_futures
    }

    if (event.message.content == "Test 2") {
      event.message.delete(); // ignore: unawaited_futures
    }

    if (event.message.content == "Test 10") {
      event.message.delete(); // ignore: unawaited_futures
    }

    if (event.message.content == "Test 11") {
      await event.message.delete();

      await event.message.channel.send(content: "Commander tests completed sucessfuly!");
      exit(0);
    }
  });

  bot.onReady.listen((e) async {
    final channel = bot.channels[Snowflake("422285619952222208")] as GuildTextChannel;

    await channel.send(content: "Testing Commander");

    final msg1 = await channel.send(content: "test>test1");
    msg1.delete(); // ignore: unawaited_futures

    final msg2 = await channel.send(content: "test>test2 arg1");
    msg2.delete(); // ignore: unawaited_futures

    final msg3 = await channel.send(content: "test>test3");
    msg3.delete(); // ignore: unawaited_futures

    final msg4 = await channel.send(content: "test>test4");
    msg4.delete(); // ignore: unawaited_futures
  });

  Commander(bot, prefix: "test>", beforeCommandHandler: (context) async {
    if (context.message.content.endsWith("test3")) {
      await context.channel.send(content: "Test 10");
      return true;
    }

    return true;
  })
    ..registerCommand("test1", (context, message) async {
      await context.channel.send(content: "Test 1");
    })
    ..registerCommand("test2", (context, message) async {
      final args = message.split(" ");

      if (args.length == 2 && args.last == "arg1") {
        await context.channel.send(content: "Test 2");
      }
    })
    ..registerCommand("test3", (context, message) async {
      await context.message.delete();
    })
    ..registerCommandGroup(CommandGroup(name: "test4")
      ..registerDefaultCommand((context, message) async => await context.channel.send(content: "Test 11")));

  Timer(const Duration(seconds: 60), () {
    print("Timed out waiting for messages");
    exit(1);
  });
}
