$(document).ready(function() {
  $('#retag').live('click',function(){
    var link = $(this);
    link.parent('.retag').hide();

    $.ajax({
      dataType: "json",
      type: "GET",
      url : link.attr('href'),
      extraParams : { 'format' : 'js'},
      success: function(data) {
        if(data.success){
          var form = $('<li>'+data.html+'</li>');
          link.parents("ul.tag-list").find('li a.tag').hide();
          link.parents(".tag-list").find('.title').after(data.html);
          link.parents(".tag-list").find('.autocomplete_for_tags').ricodigoComplete();
        } else {
            Messages.show(data.message, "error");
            if(data.status == "unauthenticate") {
              window.location="/users/login"
            }
        }
      }
    });
    return false;
  });

  $('.retag-form').live('submit', function() {
    form = $(this);
    var button = form.find('input[type=submit]');
    button.attr('disabled', true)
    $.ajax({url: form.attr("action")+'.js',
            dataType: "json",
            type: "POST",
            data: form.serialize()+"&format=js",
            beforeSend: function(jqXHR, settings){

            },
            success: function(data, textStatus) {
                if(data.success) {
                    var tags = $.map(data.tags, function(n){
                        return '<li><a class="tag" rel="tag" href="/questions/tags/'+n+'">'+n+'</a></li>'
                    })
                    form.parents('.tag-list').find('li a.tag').remove();
                    form.before($.unique(tags).join(''));
                    form.remove();
                    $('.retag').show();
                    Messages.show(data.message, "notice");
                } else {
                    Messages.show(data.message, "error")
                    if(data.status == "unauthenticate") {
                        window.location="/users/login";
                    }
                }
            },
            error: Messages.ajax_error_handler,
            complete: function(XMLHttpRequest, textStatus) {
                button.attr('disabled', false);
            }
    });
    return false;
  });

  $('.cancel-retag').live('click', function(){
      var link = $(this);
      var form = link.parents('form');
      link.parents('.tag-list').find('.tag').show();
      link.parents('.tag-list').find('.retag').show();
      link.parents('.tag-list').find('form').remove();
      return false;
  });
});
