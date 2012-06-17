var Apolloh = (function($) {

  var nudgeArticle = function () {
    var height  = $('header').height();
    $('#nudger').height(height);      
  };

  $(function() {

    $(window).resize( function () {
      nudgeArticle();
    });

    nudgeArticle();
  });    
})(jQuery);
