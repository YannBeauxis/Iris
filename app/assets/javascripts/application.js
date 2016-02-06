// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
// not turbolinks
//= require bootstrap-sprockets
//= require moment
//= require bootstrap-datetimepicker
//= require underscore
//= require backbone
//= require iris
//= require_self
//= require_tree ../templates
//= require_tree ./models
//= require_tree ./collections
//= require_tree ./views
//= require_tree ./routers

window.App = {
  Models: {},
  Collections: {},
  Views: {}
};

App.getParameterByName = function(name, url) {
    if (!url) url = window.location.href;
    name = name.replace(/[\[\]]/g, "\\$&");
    var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
        results = regex.exec(url);
    if (!results) return null;
    if (!results[2]) return '';
    return decodeURIComponent(results[2].replace(/\+/g, " "));
};

App.convertDate = function (inputFormat) {
  function pad(s) { return (s < 10) ? '0' + s : s; }
  var d = new Date(inputFormat);
  if (inputFormat != null) {
    return [pad(d.getDate()), pad(d.getMonth()+1), d.getFullYear()].join('/');
  } else {
    return null;
  }
};

App.invertDate = function (d) {
  if (d != null) {
    return [d.slice(6,10), d.slice(3,5), d.slice(0,2)].join('/');
  } else {
    return null;
  }
};

App.displayVolume = function (v) {
  if (v != null) {
    if (v<100000) {
      return v/100 + ' ml';
    }
    else {}
      return Math.round(v/1000)/100 + ' L';
  } else {
    return null;
  }
};