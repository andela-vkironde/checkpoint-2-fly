// '.tbl-content' consumed little space for vertical scrollbar, scrollbar width depend on browser/os/platfrom. Here calculate the scollbar width .
$(window).on("load resize ", function() {
  var scrollWidth = $('.tbl-content').width() - $('.tbl-content').width();
  $('.tbl-header').css({'padding-right':scrollWidth});
}).resize();

//error fade
$(".alert").fadeTo(2000, 500).slideUp(500, function(){
    $(".alert").slideUp(500);
});
