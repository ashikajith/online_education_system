# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $(".not-list, .not-view").slimScroll
    height: 400
    size: 8
    alwaysVisible: true
    railVisible: true
  $(".not-list").on "click", "li", ->
    $(".not-list li").removeClass "active"
    $(this).toggleClass "active" 