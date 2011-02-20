var Flash = {
  error: function(msg) {
    $("#container").prepend("<div id='flash_error'>"+msg+"</div>");
  },
  notice: function(msg) {
    $("#container").prepend("<div id='flash_notice'>"+msg+"</div>");
  }
};


$(function(){
  // add a class to the forms so they can be manipulated
  // on the server
  $("#import-gems form").live('submit', function(){
    $(this).addClass('submitted');
  });

  // changing tags automatically updates the gem
  $("#tags form :checkbox").change(function(){
    $(this).closest('form').submit();
  });

  // make comment box on gem page elastic
  $('#comment_text').elastic();

  $('#toggle-tag-form').click(function(){
    $('#tag-form').slideToggle('fast');
    return false;
  });
});
