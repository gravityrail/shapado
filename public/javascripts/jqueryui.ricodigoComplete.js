(function($) {
  $.fn.ricodigoComplete = function(){
    this.each(function(){
            function addTag(tag, input){
              var tag = $.trim(tag.replace(',',''));
              if(!input.parent().find('.added-tag[data-caption='+tag+']').length){
                input.val('');
                console.log(tag)
                var tag =  $('<ul style="margin-left:4px;margin-right:4px;margin-top:6px;" class="ui-menu ui-widget ui-widget-content ui-corner-all" role="listbox" aria-activedescendant="ui-active-menuitem"><li class="ui-menu-item" role="menuitem"><a class="ui-corner-all added-tag" tabindex="-1" id="ui-active-menuitem" data-caption="'+tag+'">'+tag+'&nbsp;<span style="font-weight:bold;cursor:pointer;" class="remove-tag">x</span></a></li></ul>');
                input.before(tag);
                input.css({width: '150px'});
                input.attr({placeholder: ''});
                var tags = [];
                input.parent().find('.added-tag').map(function(){tags.push($(this).attr('data-caption'))})
                input.parent().next('.ac-tags').val(tags.join(','));
                input.focus();
              }
            }
      $(".remove-tag").live('click',function(){$(this).parents('ul').remove();})
      $(".added-tag").live('mouseenter',function(){$(this).addClass('ui-state-hover')})
      $(".added-tag").live('mouseleave',function(){$(this).removeClass('ui-state-hover')})
      tagInput = $(this);
      var name = tagInput.attr('name');
      tagInput.attr('name','');
      tagInput.after('<input type="hidden" class="ac-tags" name="'+name+'">');
      var tagwrapper=$('<div class="tagwrapper" style="margin-top:15px;background:#FFF;"></div>');
      tagwrapper.css({border:'2px solid #CCCCCC', 'min-height': '40px'});
      tagInput.wrap(tagwrapper);
      var tagwrapper = tagInput.parent('.tagwrapper');
      tagwrapper.click(function (){tagwrapper.children('.autocomplete_for_tags').focus();});
      tagInput.css({outline: 'none', border: 0, padding: '10px', width: '90%'});
      tagInput.keydown(function(event){
        var key = event.keyCode;
          console.log(key)
        var tag = $(this).prev('ul');
        if($(this).val()==',') //empty the field it if it has a comma
          $(this).val('');
        if(key==8 && $(this).val()==''){
          if(tag.hasClass('ui-state-hover')){
            $(this).prev('ul').remove();
            var tags = [];
            $(this).parent().find('.added-tag').map(function(){tags.push($(this).attr('data-caption'))})
            $(this).parent().next('.ac-tags').val(tags.join(','));
          } else {
              tag.addClass('ui-state-hover');
          }
        } else if(key == 8 && $(this).val()!=''){
          tag.removeClass('ui-state-hover');
        } else if ((key == 9 || key == 32 || key == 188 || key == 13) && $.trim($(this).val().replace(',','')) != '') {
            addTag($(this).val(), $(this));
            $(this).focus();
            $(this).autocomplete( "close" );
            return false;
        }
      });
      var ac = $(this);
      var tags = $(this).val();
      if(tags!=''){
        tags = tags.split(',')
        $.each(tags,function(i, tag){
          console.log(tag)
          addTag(tag, ac);
        })
        $(this).val('');
      }
      var cache = {},
                  lastXhr;
      tagInput.autocomplete({
        select: function(event, ui) {
          addTag(ui.item.label, $(this))
          return false;
        },
        minLength: 1,
        source: function( request, response ) {
          var term = request.term;
            console.log(term)
          if( $.trim(term.replace(',','')) == '' )
            return;
          if ( term in cache ) {
            response( cache[ term ] );
            return;
          }
          lastXhr = $.getJSON( "/questions/tags_for_autocomplete.js", request, function( data, status, xhr ) {
            cache[ term ] = data;
            data.push({label:term.replace(',',''),caption:term.replace(',','')});
            if ( xhr === lastXhr ) {
              response( data );
            }
          });
        }
      }).data( "autocomplete" )._renderItem = function( ul, item ) {
          return $( "<li></li>" )
              .data( "item.autocomplete", item )
              .append( "<a>" + item.caption + "</a>" )
              .appendTo( ul );
      };
    })
  }
})(jQuery);