var Jqmath = {
  initialize: function() {
    Modernizr.load([{
      test: $('meta[data-jqmath]').length > 0 && $('.markdown').text().indexOf('$$')>-1,
      yep: $.merge($.merge([],eval($('meta[data-jqmath]').attr('data-jsassets'))||[]),eval($('meta[data-jqmath]').attr('data-cssassets'))||[])
    }])
  }
};