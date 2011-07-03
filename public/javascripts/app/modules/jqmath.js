var Jqmath = {
  initialize: function() {
    Modernizr.load([{
      test: $('meta[data-jqmath]').length > 0,
      yep: $.merge($.merge([],eval($('meta[data-jqmath]').attr('data-jsassets'))||[]),eval($('meta[data-jqmath]').attr('data-cssassets'))||[])
    }])
  }
};