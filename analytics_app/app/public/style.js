$(document).ready(function() {


$(function() {
    $('a[href*=#]').click(function() {
      if (location.pathname.replace(/^\//,'') == this.pathname.replace(/^\//,'') && location.hostname == this.hostname) {

        var target = $(this.hash);
        target = target.length ? target : $('[name=' + this.hash.slice(1) +']');
        if (target.length) {
          $('html,body').animate({
            scrollTop: target.offset().top
          }, 1500);
          return false;
        }
      }
    });
  });

// ConstantQuery

// User total
$(getData); function getData(){ 
  $("#usertotaldata").load("/usertotaldata"); 
  $("#usernotossdata").load("/usernotossdata");
  $("#averagemoneyspent").load("/averagemoneyspent");

  $("#totalswipes").load("/totalswipes");
  $("#averageswipes").load("/averageswipes");
  $("#swipetime").load("/swipetime");


  $("#leaderboard").load("/leaderboard");

setTimeout(getData,10000);
 }

// // Non-contributing users
// $(getUserNoToss); function getUserNoToss(){ 
//   $("#usernotossdata").load("/usernotossdata"); 

// setTimeout(getUserNoToss,20000); }

});