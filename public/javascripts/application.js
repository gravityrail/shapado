Ui.fix_html5_on_ie();
$(document).ready(function() {
  Ui.initialize();
  Auth.initialize();
  Geo.initialize();
  LocalStorage.initialize();
  Tags.initialize();
  Messages.initialize();
  Effects.initialize();
  Votes.initialize();
  Notifier.initialize();
});
