var Widgets = {
  initialize: function(data) {
    Networks.initialize();
    var widget = $(".widget_description");
    widget.delegate('.delete-widget', 'click', function(event) {
      var link = $(this);
      var parent = link.parents('li');
      var message = link.attr('data-confirm');
      if(confirm(message)) {
        parent.hide();
        $.ajax( link.attr('href'), {
          dataType: 'json',
          type: 'post',
          data: {'_method': 'delete', format: 'js'},
          success: function(data) {
            link.parents('li').remove();
          }
        });
      };
      return false;
    });

    widget.delegate('.edit_widget', 'click', function(event) {
      var link = $(this);
      link.hide();
      var parent = link.parents('li');
      var form = parent.find('.display form');
      var display = parent.find('.display ');
      var preview = display.find('.preview');
      var text = link.text();
      var dataText = link.attr("data-text");
      if(form.length < 1) {

        $.ajax( link.attr('href'), {
          dataType: 'json',
          data: {format: 'js'},
          success: function(data) {
            link.attr({'data-text': text });
            if(dataText && $.trim(dataText)!='')
              link.text(dataText);
            link.show();
            preview.hide();
            var form = $(data.html);
            form.find('.cancel').bind('click', function(event) {
              form.hide();
              preview.show();
              link.attr({'data-text': dataText });
              if(text && $.trim(text)!='')
                link.text(text);
              return false;
            });
            display.append(form);
          }
        });
      } else {
        link.show();

        link.attr({'data-text': text });
        if(dataText && $.trim(dataText)!='')
          link.text(dataText);
        form.toggle();
        var preview = parent.find('.display .preview');
        preview.toggle();
      }
      return false;
    });
  },
  create_on_index: function(data) {
  },
  create_on_show: function(data) {
  },
  update_on_index: function(data) {

  },
  update_on_show: function(data) {

  }
};
