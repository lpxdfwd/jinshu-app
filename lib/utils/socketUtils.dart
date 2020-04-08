import 'package:adhara_socket_io/adhara_socket_io.dart';
import 'package:jinshu_app/utils/eventUtils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;

int maxConnectCount = 5;

class SocketUtils {
  String socketUri;

  bool connectStatus = false;

  int reconnectCount = 0;

  SocketUtils(this.socketUri);

  Event event = new Event();

  Map user;

  SharedPreferences prefs;

  static String sessionKey;

  static int sessionId;

  static bool joinSuccess = false;

  static SocketIOManager manager;

  static SocketIO socket;

  static Map chatInfo;

  static int sendMsgId = 0;

  void prefsInit () async {
    prefs = await SharedPreferences.getInstance();
    String userString = prefs.getString('userInfo');
    if (userString != null) {
      user  = convert.jsonDecode(userString);
    }
  }

  connect() async {
    manager = SocketIOManager();
    SocketOptions socketOptions = new SocketOptions(socketUri);
    socket = await manager.createInstance(socketOptions);
    socket.connect();
    _initEvent();
    prefsInit();
  }

  _initEvent() {
    socket.onConnect(_handleConnect);
    socket.onConnectError(_handleConnectError);
    socket.onReconnectError(_handleReconnectError);
    socket.onReconnectFailed(_handleReconnectError);
    socket.onError(_handleError);
    socket.on('PuMsg', _handleDataEvent);
    socket.on('ConnectActionApp', _handleConnectBack);
    socket.on('OnMsgAckApp', _handleSendMsgBack);
    socket.on('PuHisMsgApp', __handlePuHisMsgBack);
  }

  _handleDataEvent(data) {
    if (data['needLogin'] != true) {
      if (data['lastMsgId'] != null) _handleFeedbackMsg(data['lastMsgId']);
      data['sessionMsgList'].forEach((msgItem) {
        //过滤无效消息
        if (msgItem['sessionKey'] == null && ((msgItem['msgList'] == null) || msgItem['msgList'].length == 0)) return;
        print('收到消息：$msgItem');
        if (msgItem['msgCate'] == 'text') {
          if (sessionKey == msgItem['sessionKey']) {
            event.emit('current', {'msgList': msgItem['msgList'], 'eventType': msgItem['eventType'], 'sessionKey': msgItem['sessionKey']});
          } else {
            event.emit('other', {'msgList': msgItem['msgList'], 'sessionKey': msgItem['sessionKey']});
          }
        } else {

          handleEvent(msgItem['msgCate'], msgItem['msgList'][0]);
          event.emit(msgItem['msgCate'], {'msgItem': msgItem['msgList'][0], 'eventType': msgItem['eventType'], sessionKey: msgItem['sessionKey']});
        }
        if (msgItem['eventType']) event.emit(msgItem['eventType'], {'msgList': msgItem['msgList']});
      });
    }
  }

  static joinChat(chat, isSug) {
    chatInfo = chat;
    socket.emit(isSug == true ? 'CnnSugUser' : 'CnnUser', [chat]);
  }

  static int getSendMsgId() {
    sendMsgId = sendMsgId + 1;
    return sendMsgId;
  }

  static sendMessage(data) {
    if (joinSuccess == false) {
      print('正在加入聊天室，请稍后再试！');
    } else {
      try {
        data['sessionKey'] = sessionKey;
        data['sessionId'] = sessionId;
        socket.emit('OnMsgApp', [data]);
      } catch (e) {
        print('error: $e');
      }
    }
  }

  static queryHistoryMsg(data) {
    if (joinSuccess == false) {
      print('正在加入聊天室，请稍后再试！');
    } else {
      try {
        socket.emit('PullHisMsgApp', [data]);
      } catch (e) {
        print('error: $e');
      }
    }
  }

  static handleEvent(String type, Map msg) {
    switch (type) {
      case 'join':
        sessionId = msg['sessionId'];
        sessionKey = msg['sessionKey'];
        joinSuccess = true;
        break;
    }
  }

  static handleConnect(Map data) {
    socket.emit('OnConnectApp', [data]);
  }

  __handlePuHisMsgBack(data) {
    print('PuHisMsgResult:$data');
  }

  _handleConnectBack(data) {
    print('result:$data');
    if(data['action'] == 'connect_success')  {
      event.emit('connectSuccess');
    } else {
      event.emit('connectError');
    }
  }

  _handleSendMsgBack(data) {
    print('sendMsgResult:$data');
    event.emit('sendSuccess', data);
  }

  _handleFeedbackMsg(lastMsgId) {
    Map data = {'msgSyncId': lastMsgId, 'userId': user['id']};
    socket.emit('AcceptAck', [data]);
  }

  static handlePullNewMsg(Map data) {
    socket.emit('PullMsg', [data]);
  }

  _handleConnectFactory() {
    if (reconnectCount < maxConnectCount) socket.onReconnect(_handleReconnect);
    //TODO 此处可以报出链接失败事件 退出用户登陆
  }

  _handleConnect(res) {
    print('------------socket链接成功--------------');
    event.emit('connectSuccess');
    connectStatus = true;
  }

  _handleConnectError(res) {
    print('------------socket链接错误--------------');
    connectStatus = false;
    _handleConnectFactory();
  }

  _handleReconnect(res) {
    print('------------socket重连成功--------------');
    event.emit('connectSuccess');
    connectStatus = true;
    reconnectCount += 1;
  }

  _handleReconnectError(res) {
    print('------------socket重连错误--------------');
    this._handleConnectFactory();
    reconnectCount += 1;
  }

  _handleError(res) {
    print('------------socket错误--------------');
    socket = null;
    connect();
  }
}