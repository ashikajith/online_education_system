# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

sendFilters = (year,subject,duration) ->
  $('.spinner').show()
  $.ajax(
    url: location.pathname
    data:
      year: year, subject_id: subject, duration: duration
  ).success (e) ->
    $('.tab-content').html(e)
    $(".spinner").hide()

sendData = (subject_id) ->
  $.ajax(
    url: "/portal/analysis/proficiency"
    data: 
      subject_id: subject_id
    dataType: "script"
  ).success (response) ->
    $(".spinner").hide()

$ ->
  $('#filter-event').change ->
    sendFilters $(this).val(), $('#filter-subject :selected').val(), $('#filter-duration :selected').val()
  $('#filter-subject').change ->
    sendFilters $('#filter-event :selected').val(), $(this).val(), $('#filter-duration :selected').val()
  $('#filter-duration').change ->
    sendFilters $('#filter-event :selected').val(), $('#filter-subject :selected').val(), $(this).val()
  $('#subject_id').change ->
    sendData $('#subject_id').val()
