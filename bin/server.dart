// 2 dependencies from Pub: redstone & shelf_static

import 'package:redstone/server.dart' as server;
import 'package:shelf_static/shelf_static.dart';

// database of dumb users
List<Map> users = [
    {
        "username":"Charles Nielson",
        "pin":[0,9,2,5],
        "email":"charles@lashbrookdesigns.com"
    },
    {
        "username":"Bryan Nock",
        "pin":[0,0,0],
        "email":"bryan@lashbrookdesigns.com"
    },
    {
        "username":"Steve Morton",
        "pin":[2,1,0,5],
        "email":"steve@lashbrookdesigns.com"
    },
    {
        "username":"Scott Scharffs",
        "pin":[2,1,3,6],
        "email":"scott@lashbrookdesigns.com"
    },
    {
        "username":"Traci Hulet",
        "pin":[2,4,3,0],
        "email":"traci@lashbrookdesigns.com"
    },
    {
        "username":"Stuart Schupler",
        "pin":[9,6,6,9],
        "email":"stuart@lashbrookdesigns.com"
    },
    {
        "username":"Doug Lantz",
        "pin":[1,1,1,8],
        "email":"doug@lashbrookdesigns.com"
    },
    {
        "username":"Debbie Arcabascio",
        "pin":[1,9,9,1],
        "email":"debbie@lashbrookdesigns.com"
    },
    {
        "username":"Martin Kemp",
        "pin":[7,7,7],
        "email":"martin@lashbrookdesigns.com"
    },
    {
        "username":"David Weekes",
        "pin":[4,4,5,3],
        "email":"david@lashbrookdesigns.com"
    },
    {
        "username":"Travis Isaacson",
        "pin":[3,1,3,1],
        "email":"travis@lashbrookdesigns.com"
    },
    {
        "username":"Eric Laker",
        "pin":[7,3,3,5],
        "email":"eric@lashbrookdesigns.com"
    },
    {
        "username":"Matt Isaacson",
        "pin":[4,2,2,8],
        "email":"matt@lashbrookdesigns.com"
    },
    {
        "username":"Megan Dorius",
        "pin":[8,6,9,9],
        "email":"megan@lashbrookdesigns.com"
    }
];

void main() {
  // to serve static files (add a "web" folder and an "index.html" file)
  server.setShelfHandler(createStaticHandler("../web", defaultDocument: "index.html"));

  // not strictly necessary -- sets up logger for Redstone functions
  server.setupConsoleLog();

  // defaults to 0.0.0.0:8080 (configurable)
  server.start();
}

Map success(String messageType, payload) {
  return {
    "messageType": messageType,
    "payload": payload
  };
}

Map error(String errorMessage) {
  print(errorMessage);

  return {
    "messageType": "error",
    "error": errorMessage
  };
}


/**
 * Path segment parameters
 */

// http://localhost:8080/hello
@server.Route("/hello")
String hello() {
  print("User soliciting greeting...");
  return "Hello, Browser!";
}

// http://localhost:8080/hi
@server.Route("/hi")
String hi() => "Hi, Browser!";

// http://localhost:8080/user/id/5
@server.Route("/user/id/:id")
Map getUserByID(String id) {
  print("Searching for user with ID: $id");

  // convert the ID from String to int
  int intID = int.parse(id, onError: (_) => null);

  // check for error
  if (intID == null || intID < 1 || intID > users.length) {
    return error("Invalid ID");
  }

  // get user
  Map foundUser = users[intID - 1];

  // return user
  return success("user", foundUser);
}

// http://localhost:8080/user/type/programmer
@server.Route("/user/type/:type")
Map getUsersByType(String type) {
  print("Searching for users with type: $type");

  // find qualifying users
  List<Map> foundUsers = users.where((Map user) => user['type'] == type).toList();

  // check for error
  if (foundUsers.isEmpty) {
    return error("Invalid type");
  }

  // return list of users
  return success("users", foundUsers);
}


/**
 * Query parameters
 */

// http://localhost:8080/user/param?id=2
@server.Route("/user/param")
Map getUserByIDParam(@server.QueryParam("id") String userID) {
  return getUserByID(userID);
}


/**
 * Request body
 * For requests that come in as POST instead of GET, you can access the request body.
 */

@server.Route("/adduser", methods: const [server.POST])
addUser(@server.Body(server.JSON) Map json) {

}

@server.Route("/adduser", methods: const [server.POST])
addUserByForm(@server.Body(server.FORM) Map form) {

}

/**
 * WebSockets
 * You need to add the redstone_web_socket dependency from Pub for this to work.
 */

//@WebSocketHandler("/ws")
//class ServerEndPoint {
//
//  @OnOpen()
//  void onOpen(WebSocketSession session) {
//    print("connection established");
//  }
//
//  @OnMessage()
//  void onMessage(String message, WebSocketSession session) {
//    print("message received: $message");
//    session.connection.add("echo $message");
//  }
//
//  @OnError()
//  void onError(error, WebSocketSession session) {
//    print("error: $error");
//  }
//
//  @OnClose()
//  void onClose(WebSocketSession session) {
//    print("connection closed");
//  }
//}

// http://redstonedart.org
