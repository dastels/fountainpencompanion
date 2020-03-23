// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require select2
//= require bootstrap-sprockets
//= require_tree .

$(function() {
  $('[data-toggle="tooltip"]').tooltip();
});

$(function() {
  $("#new-public-inks").each(function() {
    renderPublicInks(this);
  });
});

// $(function() {
//   $(".friend-button").each(function() {
//     renderFriendButton(this);
//   });
// });

$(function() {
  $(".admin-macro-cluster-row").on("ajax:success", function() {
    location.href = location.href;
  });
});
