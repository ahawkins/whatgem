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

  $("#tags form :checkbox").change(function(){
    $(this).closest('form').submit();
  });
});
