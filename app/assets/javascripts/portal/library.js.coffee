# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

sendData = (subject_id, year) ->
  $.ajax(
    url:"/portal/library/subject_library"
    data:
      subject_id: subject_id, year: year
    dataType: "script"
  ).success (response) ->
    $(".spinner").hide()
$ ->

  $('#year').change ->
    sendData $('#subject_id').val(), $(this).val()
