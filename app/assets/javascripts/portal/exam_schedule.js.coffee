# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

exam_schedule_school_filter = (school_id) ->
  $.ajax(
    url:"/portal/exam_schedule/new"
    data:
      school_id: school_id
    dataType: "script"
  ).success (response) ->
$ ->

  $('#school_list').change( ->
      exam_schedule_school_filter $('#school_list').val()
    )