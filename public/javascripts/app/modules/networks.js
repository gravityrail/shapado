var Networks = {
  initialize: function() {
    $("#network-config").hide();

    var $network_select = $("select#network_select");

    $("a.save_network").live('click', function(){
      var entry = $(this).parents(".network-config-entry");
      var network = entry.find("input.network_name").val();

      entry.find("input").hide();
      entry.find(".text").empty().append(network);
      entry.find(".buttons").empty();

      return false;
    });

    $("a.cancel_network").live('click', function(){
      var entry = $(this).parents(".network-config-entry");
      var network = entry.find("input.network_name").val();
      entry.remove();

      $.each($network_select.find('option[data-picked="true"]'), function(i, v) {
        var opt = $(v);
        if(opt.text() == network) {
          opt.attr("data-picked", false);
          opt.css("color", "black");
          return;
        }
      });

      return false;
    });

    $network_select.change(function() {
      var networks = $("#networks");

      var opt = $(this).find("option:selected");
      if( opt.val() == "")
        return false;

      if(opt.attr("data-picked") == "true")
        return false;

      opt.attr("data-picked", true);
      opt.css("color", "grey");

      var text = "enter the "+opt.val()+" for your "+opt.text()+ " account:";
      var config = $("#network-config").clone();
      config.attr("id", "#network-config-"+opt.text());
      config.find("input.network_name").val(opt.text());
      config.addClass("network-config-entry");
      config.find(".text").append(text);
      config.show();

      networks.append(config);

    });
  }
}
