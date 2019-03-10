// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require jquery.ui.all
//= require jquery.ui.datepicker
//= require rails-timeago
//= require jquery.slimscroll
//= require ckeditor/override
//= require ckeditor/init
//= require fullcalendar
//= require highcharts/highcharts                                                           
//= require highcharts/highcharts-more
//= require websocket_rails/main
//= require fullcalendar
//= require angular
//= require angular-bootstrap
//= require angular-resource
//= require app
//= require_tree ./angular                                                      
//= require_tree .


$(function() {
  //date picker
  $( ".datepicker" ).datepicker({
    changeMonth: true,
    changeYear: true,
    dateFormat: "yy-mm-dd",
    yearRange: '1940: _ '
  });

  $('.calendar').fullCalendar({
      events: '/portal/exam/event_performance',
      backgroundColor: '',
      eventRender: function (event, element, view) {          
      var dateString = $.fullCalendar.formatDate(event.start, 'yyyy-MM-dd');
      if((event.mark_ratio) < (event.day_parameter + event.least_mark_ratio)) {
        color = "#C7E6F2";
      }
      else if ((event.mark_ratio) > (((2*event.day_parameter) + event.least_mark_ratio))) {
        color = " #44bbdf";
      }
      else {
        color = "#70c9e5";
      }
      element.find('.fc-event-title').html(event.rank+"/"+event.total).text();
      $('.fc-event').css('background-color', 'transparent');
      view.element.find('.fc-day[data-date="' + dateString + '"]').css('background-color', color);
    },
    eventMouseover: function(event, jsEvent, view) {
      $('#total_performance').hide();
      $('#individual_performance').show();
      $('#total_question_performance').html(+event.l1_attended +event.l2_attended+event.l3_attended +"/" + (+event.l1_total +event.l2_total+event.l3_total));
      $('#l1_event_performance').html(event.l1_attended+"/"+ event.l1_total);
      $('#l2_event_performance').html(event.l2_attended+"/"+ event.l2_total);
      $('#l3_event_performance').html(event.l3_attended+"/"+ event.l3_total);
      $('#event_perf_accuracy').html(Math.round(event.accuracy*100)/100);
    },
    eventMouseout: function(event, jsEvent, view) {
      $('#total_performance').show();
      $('#individual_performance').hide();
    }});

  $('.school_calendar').fullCalendar({
      events: '/portal/exam/event_performance',
      defaultView: 'basicWeek',
      eventRender: function(event, element) {
            element.find('.fc-event-title').html(event.rank+"/"+event.total).text();
        },
    eventMouseover: function(event, jsEvent, view) {
      $('#l1_event_performance').html(event.l1_attended);
      $('#l2_event_performance').html(event.l2_attended);
      $('#l3_event_performance').html(event.l3_attended);
      $('#event_perf_accuracy').html(Math.round(event.accuracy*100)/100);
    },
    eventMouseout: function(event, jsEvent, view) {
      $('#l1_event_performance').html("N/A");
      $('#l2_event_performance').html("N/A");
      $('#l3_event_performance').html("N/A");
      $('#event_perf_accuracy').html("N/A");
    }});

  //navbar
  var sticky_offset_top =($('.subnav-bar').offset().top - $('.navbar').outerHeight());
  var sticky_navigation = function(){
    if ($(window).scrollTop() > sticky_offset_top || !($(".profile-bar").is(":visible"))) {
      $('.main-wrap').css({'margin-top':$('.subnav-bar').height()+10});                   
        $('.subnav-bar').css({'position': 'fixed','top':$('.navbar').outerHeight(), 'left':0 });
    } else {    
          $('.subnav-bar').css({'top':0, 'left':0, 'position': 'relative'});
          $('.main-wrap').css({'margin-top':0});
    }  
  };
    
  // $('div.fc-event.fc-event-hori.fc-event-start.fc-event-end').css("position: absolute;left: 2px;background-color: rgb(68, 238, 238);width: 77px;top: 22px; height: 64px;");
  sticky_navigation();     
  $(window).scroll(sticky_navigation);
    
  //slimscroll in notfications
  $('.notifications').slimScroll({
    height:150,
    alwaysVisible: true,
    railVisible: true
  }); 

});

$(function() {
    $( "#dialog" ).dialog({
      autoOpen: false,
      show: {
        effect: "fadeIn",
        duration: 500
      },
      hide: {
        effect: "explode",
        duration: 600
      }
    });
 
    $( "#opener" ).click(function() {
      $( "#dialog" ).dialog( "open" );
    });
  });