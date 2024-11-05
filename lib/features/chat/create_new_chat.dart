import 'package:amekopro/features/chat/chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateNewChat extends StatelessWidget {
  const CreateNewChat({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(builder: (controller) {
      if (controller.isSender.value == true) {
        return ElevatedButton(
          child: Text("Receiver"),
          onPressed: () {
            controller.isSender.value = false;
            controller.update();
          },
        );
      } else {
        return ElevatedButton(
          child: Text("Sender"),
          onPressed: () {
            controller.isSender.value = true;
            controller.update();
          },
        );
      }
    });
  }
}
