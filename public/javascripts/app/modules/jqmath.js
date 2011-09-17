var Jqmath = {
  initialize: function() {
    Modernizr.load([{
      test: $('meta[data-jqmath]').length > 0 && $('.markdown').text().indexOf('$$')>-1,
      yep: '//cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML'
    }])
  }
};