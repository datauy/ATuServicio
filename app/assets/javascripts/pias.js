$(document).ready(function(){

  var activeFilter;
  $('.pias-filters').on('click', '.pias-filter a', function(e) {
    if(window.location.href === this.href){
      var url = location.origin + "/pias";
      $(location).attr('href',url);
      e.preventDefault();
    }
  });

  function toggleIcon() {
    $(this).find('.pias-link-icon')
      .toggleClass('fa-angle-up fa-angle-down');
  }
  $('.pias-content').on('click', '.card .pias-link', toggleIcon);


  // the input field
  var $input = $("input[type='search']"),
      // search button
      $searchBtn = $("button[data-search='search']"),
      // clear button
      $clearBtn = $("i[data-search='clear']"),
      // prev button
      $prevBtn = $("i[data-search='prev']"),
      // next button
      $nextBtn = $("i[data-search='next']"),
      // the context where to search
      $content = $(".pias-content"),
      // jQuery object to save <mark> elements
      $results,
      // the class that will be appended to the current
      // focused element
      currentClass = "current",
      // top offset for the jump (the search bar)
      offsetTop = 50,
      // the current index of the focused element
      currentIndex = 0,

      $searchControls = $('.search-controls'),
      $indexCounter = $('#index-counter'),
      $resultCounter = $('#results-counter'),
      $noResults = $('.no-results');

  /**
   * Jumps to the element matching the currentIndex
   */
  function jumpTo() {
    if ($results.length) {
      $indexCounter.text((currentIndex +1 ) + '/');
      $resultCounter.text($results.length);
      $searchControls.css('display','block');
      var position,
          $current = $results.eq(currentIndex);
      $results.removeClass(currentClass);
      collapseShowParents($current);

      if ($current.length) {
        $current.addClass(currentClass);
        position = $current.offset().top - offsetTop;
        window.scrollTo(0, position);
      }
    }else{
      $noResults.css('display','block');
    }
  }

  function collapseShowParents($element){
    var $collapseContainer=$element.closest('.collapse');
    if(!$collapseContainer.hasClass('show') && !$collapseContainer.hasClass('in')){
      $collapseContainer.toggleClass('show in');
      $collapseContainer.css('height', 'auto');
    }
    if($collapseContainer.hasClass('root')){
      return false;
    }
    collapseShowParents($collapseContainer.parent());
  }

  /**
   * Searches for the entered keyword in the
   * specified context on input
   */
  $searchBtn.on("click", triggerSearch);
  $input.keyup(function(e) {
    if (e.keyCode == 13) {
      $('.ui-autocomplete').css('display','none');
      triggerSearch();
    }
  });
  function triggerSearch(){
    var searchVal = $input.val();
    $content.unmark({
      done: function() {
        $content.mark(searchVal, {
          separateWordSearch: false,
          done: function() {
            $results = $content.find("mark");
            currentIndex = 0;
            jumpTo();
          }
        });
      }
    });
  }

  function clearSearch(){
    $content.unmark();
    $input.val("").focus();
    $searchControls.css('display','none');
    $noResults.css('display','none');
    $indexCounter.text('');
    $resultCounter.text('');
  }

  /**
   * Clears the search
   */
  $clearBtn.on("click", clearSearch);


  $input.on('input', function(){
    if($searchControls.css("display") === "block" || $noResults.css("display") === "block") {
      clearSearch();
    }
  });


  /**
   * Next and previous search jump to
   */
  $nextBtn.add($prevBtn).on("click", function() {
    if ($results.length) {
      currentIndex += $(this).is($prevBtn) ? -1 : 1;
      if (currentIndex < 0) {
        currentIndex = $results.length - 1;
      }
      if (currentIndex > $results.length - 1) {
        currentIndex = 0;
      }
      jumpTo();
    }
  });
});
