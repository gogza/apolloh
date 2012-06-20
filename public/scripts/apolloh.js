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

  checkForQuestionMark = function (text) {
    if (text.trim().slice(-1) !== "?") {
      return "Please put a question mark at the end.";
    }
    return null;
  };

  checkWordCount = function (text, count) {
    oneLine = text.replace(/[\s|?]/g,' ');
    words = oneLine.trim().split(' ');
    if (words.length < count) {
      return "Please enter at least 3 words.";
    }
    return null;    
  };

  $(function() {
    $('#question-text').bind('keypress paste input', function(){
      $('#errors').remove();

      var text = $(this).val();

      var validations = [
        {routine: checkWordCount, args:[text, 3]},
        {routine: checkForQuestionMark, args:[text]}
      ];

      // validation the text
      var messages = [];
      $.each(validations, function(index, value){
        var message = value.routine.apply(null, value.args);
        if (message)
          messages.push(message);       
      });

      // do we have any errors?
      if (messages.length === 0) {
        $('#create').removeAttr('disabled');
      } else {
        $('<div id="errors"></div>').insertBefore('#create');
        $.each(messages, function(index, value) {
          $('#errors').append('<p class="warning">'+value+'</p>');
        });
        $('#create').attr('disabled','disabled');
      }
      
    });
  });   


 
})(jQuery);
