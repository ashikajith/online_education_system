# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
  
loadPrevExams = (exam_type, subject) ->
  $('.spinner').show()
  $('.result-box').fadeOut()
  $.ajax(
    url: "/portal/exam/load_prev_exams"
    data:
      exam_type: exam_type, subject_id: subject
  ).success (e) ->
    $(".spinner").hide()
    $('.result-box').fadeIn()
loadNextQuestion = (exam_id, current, next, answer='', marked='') ->
  $(".spinner").show()
  $('.acontent').fadeOut()  
  $.ajax(
    url: "/portal/exam/load_question"
    data:
      exam_id: exam_id, current: current, next: next, answer: answer, marked: marked
  ).success (e) ->
    $(".spinner").hide()
    $('.acontent').fadeIn()
changeQuestionStatus = (question_number, status) ->
  $("#qno-" + question_number).removeClass()
  $("#qno-" + question_number).addClass status
sendSchoolDataPerformance = (school_id) ->
  $.ajax(
    url:"/portal/exam/event_performance"
    data:
      school_id: school_id
    dataType: "script"
  ).success (response) ->
    $(".spinner").hide()

$ ->
  if channel?
    MathJax.Hub.Queue(["Typeset",MathJax.Hub])
    channel.bind "timer", (timer) ->
      data = JSON.parse(timer)
      secs = parseInt(data)
      hrs = Math.floor(secs / 3600)
      mins = Math.floor((secs - (hrs * 3600)) / 60)
      secs = secs - (hrs * 3600) - (mins * 60)
      $("#timer-hr").text hrs
      $("#timer-min").text mins
      $("#timer-sec").text secs
      window.location = window.location if data is 0
    channel.bind "question", (response) ->
      data = JSON.parse(response)
      $("#quest-no").text data.index
      if data.index is 1
        $("#prev").hide()
      else
        $("#prev").show()
      if data.last is "true"
        $("#next").hide()
      else
        $("#next").show()
      question = JSON.parse(data.question)
      options = JSON.parse(data.options)
      answer = data.answer
      question_no = data.index
      $("#quest-txt").html question.questions
      $.each options, (option_index, value) ->
        if data.answer
          disabled = "disabled"
        else
          disabled = ""
        option_index = option_index + 1
        $("#ans" + option_index).html "<input type=\"radio\" name=\"answer\"  value=\"" + value._id.$oid + "\"" + disabled + (if `value._id.$oid == data.answer` then " checked" else "" ) + ">" + value.answer_key
      changeQuestionStatus question_no, data.status
      $("input:radio[name=answer]").change ->
        $("input:radio[name=answer]").prop("disabled", true)
        changeQuestionStatus $('#quest-no').text(), "answered"
        loadNextQuestion $('#qcode p').text(), question_no, +question_no+1, $(this).val()
  $('#next').click ->
    loadNextQuestion $('#qcode p').text(), $('#quest-no').text(), +$('#quest-no').text()+1, $('input[name="answer"]:checked').val()
    false
  $('#prev').click ->
    loadNextQuestion $('#qcode p').text(), $('#quest-no').text(), +$('#quest-no').text()-1, $('input[name="answer"]:checked').val()
    false
  $('#mark').click ->
    changeQuestionStatus $('#quest-no').text(), "marked"
    loadNextQuestion $('#qcode p').text(), $('#quest-no').text(), +$('#quest-no').text()+1, '', "marked"
    false
  $('#exam-status a').click ->
    loadNextQuestion $('#qcode p').text(), $('#quest-no').text(), +$(this).text()
    false
  $("input:radio[name=answer]").change ->
    $("input:radio[name=answer]").prop("disabled", true)
    changeQuestionStatus $('#quest-no').text(), "answered"
    loadNextQuestion $('#qcode p').text(), $('#quest-no').text(), +$('#quest-no').text()+1, $(this).val()
  $("#events-today").click ->
    $(".sidebar-menu a.active").removeClass "active"
    $(".prev-only").hide()
    $(this).addClass "active"
    false
  $("#events-prev").click ->
    $(".sidebar-menu a.active").removeClass "active"
    $(".prev-only").fadeIn()
    $(this).addClass "active"
    false
  $('#sel-event').change ->
    loadPrevExams $(this).val(), $('#sel-subj :selected').val()
  $('#sel-subj').change ->
    loadPrevExams $('#sel-event :selected').val(), $(this).val()
  $(".rq-list").on "click", ".rq-showans", ->
    unless $(this).hasClass("expanded")

      $(".rq-showans.expanded").click()
      $(this).parents("li").find(".answer").slideDown()
      $(this).addClass "expanded"
    else
      $(this).parents("li").find(".answer").slideUp()
      $(this).removeClass "expanded"
    false
  $('#exam-status').slimScroll({
    height:120,
    alwaysVisible: true,
    railVisible: true
  }); 
  $('#school_filter_performance').change ->
    sendSchoolDataPerformance $('#school_filter_performance').val()