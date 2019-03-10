# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

filterUnitQuestionPaper = (subject_id) ->
  $.ajax(
    url:"/portal/question_papers/new"
    data:
      subject_id: subject_id
    dataType: "script"
  ).success (response) ->
    $(".spinner").hide()
$ ->

  $('#question_paper_subject_id').change ->
  	if $("#question_paper_subject_id").val() is ""
  		$("#unit_id_field").hide()
  		false
  	else	
    	filterUnitQuestionPaper $('#question_paper_subject_id').val()
    	$("#unit_id_field").show()
