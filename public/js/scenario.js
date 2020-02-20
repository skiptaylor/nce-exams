$(window).load(function() {
  var disable_question, paginate;
  $('input[type=checkbox]').click(function() {
    var id;
    id = $(this).attr('id');
    $("blockquote#response-" + id).show();
    $(this).attr('disabled', true);
    return $.post('/add-score', {
      answer: id
    }, function(data) {
      return paginate();
    });
  });
  $('a.question-link').click(function() {
    var question;
    if (!$(this).parent('li').hasClass('disabled')) {
      question = $(this).html();
      $('.pagination ul li').removeClass('active');
      $(this).parent('li').addClass('active');
      $('.question').hide();
      $("#question-" + question).show();
      disable_question(question - 1);
      $('html, body').scrollTop(0);
    }
    return false;
  });
  $('a#score-link').click(function() {
    if ($(this).parent('li').hasClass('disabled')) {
      return false;
    }
  });
  $('a.restart').click(function() {
    if (!confirm('This will reset your score! Continue?')) {
      return false;
    }
  });
  $('a#show-all').click(function() {
    $('a#show-all').parent('p').hide();
    $('div.pagination').hide();
    $('div.question').show();
    return false;
  });
  paginate = function() {
    return $('a.question-link').each(function() {
      var checked, checked_required, question, required;
      question = $(this).text();
      checked = $("#question-" + question + " input[type=checkbox]:checked").size();
      required = $("#question-" + question + " input[type=checkbox].required").size();
      checked_required = $("#question-" + question + " input[type=checkbox].required:checked").size();
      if (checked > 0) {
        disable_question(question - 1);
      }
      if (required > 0) {
        if (checked_required === required) {
          return $(this).parent().next('li').removeClass('disabled');
        }
      } else {
        if (checked > 0) {
          return $(this).parent().next('li').removeClass('disabled');
        }
      }
    });
  };
  disable_question = function(question) {
    return $("div#question-" + question + " form label input[type=checkbox]").each(function() {
		return $(this).attr('disabled', true)
    });
  }; 
  
  return paginate();
});