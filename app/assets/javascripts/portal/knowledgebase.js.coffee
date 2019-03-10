load_units = (subject_id) ->
  $.ajax(
    url:"/portal/knowledgebase/new"
    data:
      subject_id: subject_id
    dataType: "script"  
  ).success (response) ->
    $(".spinner").hide()
$ ->  

loadKb = (subject_id) ->
  $('.tab-content').slideUp()
  $.ajax(
    url: "/portal/knowledgebase"
    data:
      subject_id: subject_id
    dataType: "script"
  ).success (response) ->
    $('.tab-content').slideDown()
    $(".spinner").hide()
loadUnitTopics = (unit_id) ->
  $.ajax(
    url: "/portal/knowledgebase/load_unit_questions"
    data:
      unit_id: unit_id
    dataType: "script"
  ).success (response) ->
    $(".spinner").hide()
    $('#unit_questions').slideDown()
setActiveTopic = (id, topic) ->
  $("#selected-topic b").text topic
  $("#sel-topic").val id
  $('#knowledgebase_unit_id').val id
  if topic is ""
    $(".qa-topics").fadeIn()
    $("#selected-topic").fadeOut()
    $("#kb-askq").slideUp()
  else
    $("#selected-topic").fadeIn()
    $("#kb-askq").slideDown()
castVote = (id, type) ->
  if type is 'question'
    url = "/portal/knowledgebase/vote"
  else
    url = "/portal/knowledgebase/vote_answer"
  $(".spinner").show()
  $.ajax(
    url: url
    data:
      id: id
    dataType: "script"
  ).success (response) ->
    $(".spinner").hide()
$ ->
  $(".sidebar-menu a").click ->
    $(".overall").removeClass "overall"
    $(".sidebar-menu a.active").removeClass "active"
    $(this).addClass "active"
    $(".spinner").show()
    if location.pathname is "/portal/knowledgebase"
      loadKb $(this).attr("id")
      if $(this).attr("id") is undefined
        $('#choose_topic_tab').hide()
        $('#ask_question_tab').hide()
        $('#new_form_tab').hide()
        window.location="/portal/knowledgebase";
      else
        $('#choose_topic_tab').show()
        $('#ask_question_tab').show()
        $('#new_form_tab').show()    
      false
    else if location.pathname is "/portal/knowledgebase/new"
      load_units $(this).attr("id")
      false  
    else
      $(".spinner").hide(1000)
      setActiveTopic '', ''
  $("div.qa-topics a").click ->
    setActiveTopic $(this).attr("href"), $(this).text()
    $("div.qa-topics").slideUp()
    false
  $("div.ask_question_units a").click ->
    setActiveTopic $(this).attr("href"), $(this).text()
    $("div.ask_question_units").slideUp()
    false
  $('#selected-topic').click ->
    setActiveTopic '', ''
    $('#unit_questions').slideUp()
  $('div.unit_topics a').click ->
    $(".spinner").show()
    loadUnitTopics $(this).attr('href')
    false
  $('.votes a').click ->
    castVote $(this).attr('id'), 'question'
    false
  $('.vote_answer a').click ->
    castVote $(this).attr('id'), 'answer'