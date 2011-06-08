var Notifier = {
  initialize: function() {
    if (this.is_valid()) {
      this.update_checkbox();

      $("#desktop_notifs").click(function() {
        window.webkitNotifications.requestPermission();
        Notifier.update_checkbox();
      })
    }
  },
  send_message: function(title, message, icon) {
    if(!icon)
      icon = "/images/rails.png"
    if(this.is_valid() && this.is_allowed()) {
      window.webkitNotifications.createNotification(icon, title, message).show();
    }
  },
  is_valid: function() {
    return window.webkitNotifications != null;
  },
  is_allowed: function() {
    return window.webkitNotifications.checkPermission() == 0;
  },
  update_checkbox: function() {
    var cbox = $("#desktop_notifs");
    var v = window.webkitNotifications.checkPermission();
    if(v == 0) {
      cbox.attr("checked", true)
    } else {
      cbox.attr("checked", false)
    }
  }
};

$(document).ready(function() {
  Notifier.initialize();
});
