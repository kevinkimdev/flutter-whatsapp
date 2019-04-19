import 'package:flutter/material.dart';
import 'package:flutter_whatsapp/src/helpers/dialogHelper.dart';
import 'package:flutter_whatsapp/src/models/chatList.dart';
import 'package:flutter_whatsapp/src/models/chat.dart';
import 'package:flutter_whatsapp/src/services/chatService.dart';
import 'package:flutter_whatsapp/src/values/colors.dart';
import 'package:flutter_whatsapp/src/widgets/chatItem.dart';

class ChatsTab extends StatefulWidget {
  TextEditingController _searchBarController;

  ChatsTab(this._searchBarController);

  @override
  _ChatsTab createState() => _ChatsTab();
}

class _ChatsTab extends State<ChatsTab>
    with AutomaticKeepAliveClientMixin<ChatsTab> {
  @override
  bool get wantKeepAlive => true;

  Future<ChatList> _chatList;
  ChatList _shownChatList;
  String _searchKeyword = "";

  @override
  void initState() {
    _shownChatList = new ChatList();
    _chatList = getChats();
    super.initState();
    widget._searchBarController.addListener(() {
      setState(() {
        _searchKeyword = widget._searchBarController.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return FutureBuilder<ChatList>(
      future: _chatList,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Center(
              child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.grey),
              ),
            );
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.grey),
              ),
            );
          case ConnectionState.done:
            if (snapshot.hasError) {
              return Center(
                child: Text('Couldn\'t connect to Internet.'),
              );
            }
            _shownChatList = snapshot.data;
            bool isFound = false;
            return ListView.builder(
                itemCount: _shownChatList.chats.length,
                itemBuilder: (context, i) {
                  if (_searchKeyword.isNotEmpty) {
                    if (!_shownChatList.chats[i].name
                        .toLowerCase()
                        .contains(_searchKeyword.toLowerCase())) {
                      if (!isFound && i >= _shownChatList.chats.length - 1) {
                        return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Center(
                              child: Text(
                                  'No results found for \'$_searchKeyword\''),
                            ));
                      }
                      return SizedBox(
                        height: 0.0,
                      );
                    }
                  }
                  isFound = true;
                  return _buildChatItem(
                      context, _searchKeyword, _shownChatList.chats[i]);
                });
        }
        return null; // unreachable
      },
    );
  }

  Widget _buildChatItem(BuildContext context, _searchKeyword, Chat chat) {
    return ChatItem(chat, _searchKeyword, () => onTapProfileChatItem(chat),() => onTapChatItem(context, chat));
  }

  void onTapChatItem(BuildContext context, Chat chat) {
    Scaffold.of(context)
        .showSnackBar(new SnackBar(content: Text("You clicked: ${chat.name}")));
  }

  void onTapProfileChatItem(Chat chat) {
    Dialog profileDialog = getProfileDialog(
      imageUrl: chat.avatarUrl,
      name: chat.name,
    );
    showDialog(
        context: context,
        builder: (BuildContext context) => profileDialog
    );
  }
}
