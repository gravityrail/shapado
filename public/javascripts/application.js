$(document).ready(function() {
  AppConfig.initialize();
  Geo.initialize();
  LocalStorage.initialize();
  Tags.initialize();
  Votes.initialize();
  Notifier.initialize();
  Networks.initialize();
  LayoutEditor.initialize();
  Widgets.initialize();
});

$(document).ready(function(){
	$(".advanced-search").click(function(){
		$(".advanced-form").toggleClass("open").slideToggle("slow");
		return false;
	});
});
