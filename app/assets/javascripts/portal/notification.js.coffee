# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

updateNotification = (notification_id)->
  $.ajax(
    url: "/portal/notification/marked"
    method: 'POST'
    data:
      id: notification_id
    dataType: "script"
  ).success (response) ->
    true
$ ->
  socket = new WebSocketRails(window.location.host + "/websocket")
  channel = socket.subscribe("notification")
  channel.bind "new", (data) ->
    msg = JSON.parse(data)
    console.log msg
    $(".notification_container").html('<li><a href="/portal/'+msg.event_name+'/'+msg.event_id.$oid+'" id="'+ msg.event_id.$oid+'">'+msg.message+'</a></li>')
    count = $("#notification_count").text()
    $(".notification_count").html($('<b>').text(+count+1))
  $('.notifications a').click ->
    updateNotification $(this).attr('id')