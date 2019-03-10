# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

filterUnitQuestion = (subject_id) ->
  $.ajax(
    url:"/portal/questions/new"
    data:
      subject_id: subject_id
    dataType: "script"
  ).success (response) ->
    $(".spinner").hide()
$ ->

  $("#question_subject_id").change ->
    $(".spinner").show()
    if $("#question_subject_id").val() is ""
      $("#unit_field_question").hide()
    else
      filterUnitQuestion $("#question_subject_id").val()
      $("#unit_field_question").show()