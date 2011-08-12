var Widgets = {
  initialize: function(data) {
    Networks.initialize();
    var widget = $('.widget-container');
    widget.delegate('a.delete-widget', 'click', function(event) {
      var link = $(this);
      var parent = link.parents('.widget-container');
      var message = link.attr('data-confirm');
      if(confirm(message)) {
        parent.hide();
        $.ajax( link.attr('href'), {
          dataType: 'json',
          type: 'post',
          data: {'_method': 'delete', format: 'js'},
          success: function(data) {
            parent.remove();
          }
        });
      };
      return false;
    });

    widget.delegate('.edit_widget', 'click', function(event) {
      var link = $(this);
      link.hide();
      var parent = link.parents('.widget-container');
      var display = parent.find('.widget-info');
      var form = display.find('form');
      var preview = display.find('.widget');
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
            if(form.attr('id').match(/edit_group_networks_widget/)) {
              Networks.initialize(form);
            }
          }
        });
      } else {
        link.show();

        link.attr({'data-text': text });
        if(dataText && $.trim(dataText)!='')
          link.text(dataText);
        form.toggle();
        var preview = parent.find('.widget-info .widget');
        preview.toggle();
      }
      return false;
    });

    $('#widget_position').change(function() {
      var opt = $(this).find("option:selected");
      $('.select-widget .zone img').attr({src: '/images/zone-'+opt.val()+'.gif'});
      $('.zone .name').text(opt.text())

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
