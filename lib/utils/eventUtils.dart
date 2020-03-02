typedef void EventCallback(Map a);

class Event {
  Event._internal();

  static Event _singleton = new Event._internal();

  factory Event()=> _singleton;

  Map<String, EventCallback> __eventMap = new Map<String, EventCallback>();

  void on(String name, EventCallback callback) {
    if (name == null || callback == null) return;
    __eventMap[name] = callback;
  }

  void remove(String name) {
    if(name == null || __eventMap[name] == null) return;
    __eventMap[name] = null;
  }

  void emit(String name, [Map a]) {
    if (name == null || __eventMap[name] == null) return;
    Function fn = __eventMap[name];
    fn(a);
  }
}