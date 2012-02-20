
var Loader = {
  //only for ready
  initialize: function($body, refreshed) {
    Updater.initialize($body);
    Ui.initialize();
    Messages.initialize();
    Auth.initialize();
    AppConfig.initialize();
    Geo.initialize();
    LocalStorage.initialize();
    Notifier.initialize();
    LayoutEditor.initialize();
    Loader.refresh($body, false);
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
    } else if($body.hasClass("pages-controller")) {
      Pages.initialize($body);
    } else if($body.hasClass("members-controller")) {
      Members.initialize($body);
    } else if($body.hasClass("groups-controller") ||
      $body.hasClass("admin-manage-controller")) {
      if($body.hasClass("content")) {
        Ui.initialize_lang_fields();
      }
      Groups.initialize($body);
    } else if($body.hasClass("themes-controller")) {
      Themes.initialize($body);
    } else if($body.hasClass("searches-controller")) {
      Searches.initialize($body);
    } else if($body.hasClass("answers-controller")) {
      Answers.initialize($body);
    }
    if($body.is(".users-controller.edit.application")) {
      Users.initialize_on_show($body);
    }
    if($body.is(".admin-manage-controller.properties.application.manage-layout") ||
      $body.is(".groups-controller.new.application") ||
      $body.is(".users-controller.edit.application")) {
      Groups.initialize_on_manage_properties($body);
    }
    Invitations.initialize(); //FIXME: empty function
  }
}
