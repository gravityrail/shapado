var Form = {
  initialize: function() {
    $("input[type=color]").jPicker({
    window: {
              expandable: true,
              position: { x: 'screenCenter', y: 'center'}
            },
    images: { clientPath: '/images/jpicker/' }
    });
    $("input[type=color]").hide();
  }
};
