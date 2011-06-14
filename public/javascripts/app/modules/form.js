var From = {
  initialize: function() {
    $("input[type=color]").jPicker({
    window: {
              expandable: true,
              position: { x: 'screenCenter', y: 'center'}
            },
    images: { clientPath: '/images/' }
    });
    $("input[type=color]").hide();
  }
};
