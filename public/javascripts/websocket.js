var CahumaSocket = {
  initialize: function() {
    WEB_SOCKET_SWF_LOCATION = "/javascripts/web-socket-js/WebSocketMain.swf";

    var config = $("#websocket");
    this.error_count = 0;
    this.ws = new WebSocket("ws://"+config.attr("data-host")+":34567/");
    this.socket_key = null;


    this.ws.onmessage = function(evt) {
      CahumaSocket.parse(evt.data);
    };

    window.webSocketError = function(message) {
      console.error(decodeURIComponent(message));
      CahumaSocket.error_count += 1;
    }

    this.ws.onclose = function() {
      if(CahumaSocket.error_count < 3)
        setTimeout(CahumaSocket.initialize, 5000)
    };

    this.ws.onopen = function() {
      CahumaSocket.send({id: 'start', key: config.attr("data-key"), channel_id: config.attr("data-group")});
    };
  },
  add_chat_message: function(from, message) {
    $("#chat_div").chatbox("option", "boxManager").addMsg(from, message);
  },
  parse: function(data) {
    var data = jQuery.parseJSON(data);

    window.console && console.log("received: ");
    window.console && console.log(data);

    switch(data.id) {
      case 'chatmessage': {
        CahumaSocket.add_chat_message(data.from, data.message);
      }
      break;
      case 'newquestion': {
        alert("new question: "+data.name);
      }
      break;
      case 'newanswer': {
        alert(data.owner_name+" has answered the question "+data.question_title);
      }
      break;
    }
  },
  send: function(data) {
    this.ws.send($.toJSON(data))
  }
};

$(document).ready(function() {
  CahumaSocket.initialize();
});

