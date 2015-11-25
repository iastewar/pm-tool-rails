$(function() {
  $(document).on("click", ".clickable_html", function() {
    event.stopPropagation();
    var link = $(this).find("a").attr("href");
    window.location = link;
  })


  $(document).on("click", ".clickable_js", function() {
    event.stopPropagation();
    var link = $(this).find("a").attr("href");
    $.getScript(link);
  })
})
