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

    var dialogContainer = $('#edit-widget-dialog');

    widget.delegate('.edit_widget', 'click', function(event) {
      var link = $(this);
      var parent = link.parents('.widget-container');
      var display = parent.find('.widget-info');

      var preview = display.find('.widget');

      $.ajax( link.attr('href'), {
        dataType: 'json',
        data: {format: 'js'},
        success: function(data) {
          var form = $(data.html);
          Ui.initialize_lang_fields(form);

          dialogContainer.html(form);
          var dialog = dialogContainer.dialog({modal: true, minWidth: 620, title: link.data('title')});

          form.find('.cancel').bind('click', function(event) {
            dialogContainer.dialog("close");
            return false;
          });

          if(form.attr('id').match(/edit_group_networks_widget/)) {
            Networks.initialize(form);
          }
        }
      });
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
