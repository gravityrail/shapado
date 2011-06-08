// Efects

// Open and show a panel
$(document).ready(function(){
  $(".btn-answer").click(function(){
    $("#panel-answer").slideToggle("slow");
    $(this).toggleClass("active"); return false;
  });
});

// Navs, drop down menus
jQuery(function(){
  jQuery('ul.drop-menu').superfish({
    hoverClass:    'dropHover',
    autoArrows:    false
  });
});

