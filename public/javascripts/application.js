var Flash = {
  error: function(msg) {
    $("#container").prepend("<div id='flash_error'>"+msg+"</div>");
  },
  notice: function(msg) {
    $("#container").prepend("<div id='flash_notice'>"+msg+"</div>");
  }
};
