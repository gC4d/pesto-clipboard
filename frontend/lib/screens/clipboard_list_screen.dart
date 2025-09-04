
import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import '../widgets/clipboard_item_card.dart';
import '../models/clipboard_item.dart';

class ClipboardListScreen extends StatefulWidget {
  const ClipboardListScreen({super.key});

  @override
  State<ClipboardListScreen> createState() => _ClipboardListScreenState();
}

class _ClipboardListScreenState extends State<ClipboardListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              WindowTitleBarBox(
                child: Row(
                  children: [
                    Expanded(child: MoveWindow()),
                    CloseWindowButton(),
                  ],
                ),
              ),
              ClipboardItemCard(
                item: ClipboardItem(
                  id: '1',
                  content: 'Hello World',
                  contentType: ClipboardContentType.text,
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                  isCurrent: true,
                ),
                onTap: () {},
              ),
              ClipboardItemCard(
                item: ClipboardItem(
                  id: '1',
                  content: 'Hello World',
                  contentType: ClipboardContentType.image,
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                  isCurrent: false,
                ),
                onTap: () {},
              )
            ],
          ),
        ));
  }
}