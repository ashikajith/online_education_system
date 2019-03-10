# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $("#user_role").change ->
    role = $('#user_role').val()
    if $("#user_role").val() is "student"
      $("#user_subject").hide()
      $("#user_school").fadeIn 1000
      $("#user_scheme").fadeIn 1000
      $("#guardian_detail").fadeIn 1000
      $("#user_year").fadeIn 1000
      $("#user_syllabus").fadeIn 1000
    else if role is "owner" or role is "iadmin" or role is "istaff"
      $("#user_subject").hide()
      $("#user_school").hide()
      $("#user_scheme").hide()
      $("#guardian_detail").hide()
      $("#user_year").hide()
      $("#user_syllabus").hide()
    else if role is "sadmin" or role is "sstaff"
      $("#user_subject").hide()
      $("#user_scheme").hide()
      $("#guardian_detail").hide()
      $("#user_year").hide()
      $("#user_syllabus").hide()
      $("#user_school").fadeIn 1000
    else if role is "mentor"
      $("#user_subject").fadeIn 1000
      $("#user_school").hide()
      $("#user_scheme").hide()
      $("#guardian_detail").hide()
      $("#user_year").hide()
      $("#user_syllabus").hide()
  $('#activate_account_btn').click ->
    $('#activate_account').show()
    