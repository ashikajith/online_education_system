# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

loadFees = (country, state, year, scheme, course_type) ->
  $(".spinner").slideDown()
  $.ajax(
    url: '/users/load_fees'
    dataType: "json"
    data:
      country: country, state: state, year: year, scheme_id: scheme, course_type: course_type
  ).success (response) ->
    $(".spinner").slideUp()
    if response is null
      $('#course_id').val('')
      $('#fees').html("Please select all options or select a course that is available in your area.").slideDown()
    else
      $('#course_id').val(response._id.$oid)
      $('#fees').html(response.fees).slideDown()
$ ->
  $('#country').change ->
    if $('#country option:selected').val() is 'india'
      $('#state').slideDown()
      $('#state').change ->
        if $('#state option:selected').val() is ''
          $('#scheme').slideUp()
          $('#course').slideUp()
          $('#user_year').slideUp()
        else
          $('#user_year').slideDown()
          loadFees  $('#country option:selected').val(), $('#state option:selected').val(), $('#user_year option:selected').val(), $('#scheme option:selected').val(), $('#course option:selected').val()
      $('#user_year').change ->
        if $('#user_year option:selected').val() is ''
          $('#scheme').slideUp()
          $('#course').slideUp()
        else
          $('#scheme').slideDown()
          loadFees  $('#country option:selected').val(), $('#state option:selected').val(), $('#user_year option:selected').val(), $('#scheme option:selected').val(), $('#course option:selected').val()
      $('#scheme').change ->
        if $('#scheme option:selected').val() is ''
          $('#course').slideUp()
        else
          $('#course').slideDown()
          $('#course').change ->
            loadFees  $('#country option:selected').val(), $('#state option:selected').val(), $('#user_year option:selected').val(), $('#scheme option:selected').val(), $('#course option:selected').val()
    else if $('#country option:selected').val() is ''
      $('#state').slideUp()
      $('#scheme').slideUp()
      $('#course').slideUp()
      $('#user_year').slideUp()
    else
      $('#state').slideUp()
      $('#user_year').slideDown()
      $('#user_year').change ->
        if $('#user_year option:selected').val() is ''
          $('#scheme').slideUp()
          $('#course').slideUp()
        else
          $('#scheme').slideDown()
          loadFees  $('#country option:selected').val(), $('#state option:selected').val(), $('#user_year option:selected').val(), $('#scheme option:selected').val(), $('#course option:selected').val()
      $('#scheme').change ->
        if $('#scheme option:selected').val() is ''
          $('#course').slideUp()
        else
          $('#course').slideDown()
          $('#course').change ->
            loadFees $('#country option:selected').val(), $('#state option:selected').val(), $('#user_year option:selected').val(), $('#scheme option:selected').val(), $('#course option:selected').val()
  $('#school_select').change ->
    if $('#school_select option:selected').val() is ''
      $('#school_form').slideDown()
    else
      $('#school_form').slideUp()