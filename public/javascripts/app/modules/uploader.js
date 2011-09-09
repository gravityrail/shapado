
var Uploader = {
  //only for ready
  initialize: function($body, refreshed) {
    Updater.initialize();
    Ui.initialize();
    Messages.initialize();
    Auth.initialize();
    AppConfig.initialize();
    Geo.initialize();
    LocalStorage.initialize();
    Notifier.initialize();
    LayoutEditor.initialize();
    Uploader.refresh($body, false);
  },
  //for Updater
  refresh: function($body, refreshed) {
    if(refreshed) {
      Ui.initialize();
      Messages.initialize();
    }

    if($body.hasClass("questions-controller")) {
      Questions.initialize($body);
    } else if($body.hasClass("widgets-controller")) {
      Widgets.initialize($body);
    } else if($body.hasClass("users-controller")) {
      Users.initialize($body);
    } else if($body.hasClass("announcements-controller")) {
      Editor.initialize($body);
    } else if($body.hasClass("tags-controller")) {
      Tags.initialize($body);
    } else if($body.hasClass("members-controller")) {
      Members.initialize($body);
    } else if($body.hasClass("groups-controller")) {
      Groups.initialize($body);
    }

    Invitations.initialize(); //FIXME: empty function
  }
}
