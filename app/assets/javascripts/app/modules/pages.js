var Pages = {
  initialize: function($body) {
    if($body.hasClass("new") || $body.hasClass("edit") || $body.hasClass("create") || $body.hasClass("update") ) {
      Editor.initialize();
    }
  }
}