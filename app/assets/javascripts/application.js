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
//= require dataTables/jquery.dataTables
// not turbolinks
//= require bootstrap-sprockets
//= require moment
//= require bootstrap-datetimepicker
//= require bootstrap-material-design
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

    
App.sortBy = function(options) {
/* options = {
    elTarget: [element to be sorted], 
    sort_key: [param to sort], 
    order: [1 or -1]}*/
  if (options.order == null) {options.order = 1;}
  options.elTarget.append(
      options.elTarget.children().sort(function (a,b) {
      aParam = $(a).attr(options.sort_key);
      bParam = $(b).attr(options.sort_key);
      return (aParam < bParam) ? -1*options.order : (bParam < aParam) ? 1*options.order : 0;
    })
  );
  return options.elTarget;
};

App.sortByName = function(elTarget) {
  return App.sortBy({elTarget: elTarget, sort_key: 'name'});
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

App.convertDateYearFirst = function (inputFormat) {
  function pad(s) { return (s < 10) ? '0' + s : s; }
  var d = new Date(inputFormat);
  if (inputFormat != null) {
    return [d.getFullYear(), pad(d.getMonth()+1), pad(d.getDate())].join('/');
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

App.displayQuantity = function (options) {
// options = {quantity: [integer],unit: ['ml' or 'g'] }
  var qu = options.quantity/100;
  var unit = options.unit;
  if (unit == undefined) {unit = '';}
  if (unit == 'ml') {
    var unitBig = 'L';
  } else {
    var unitBig = 'k' + unit;
  }
  if (qu!= null) {
    if (qu > 100000) {
      return Math.round(qu/1000) + ' ' + unitBig;
    } else if (qu > 10000 ) {
      return Math.round(qu/100)/10 + ' ' + unitBig;
    } else if (qu > 1000 ) {
      return Math.round(qu/10)/100 + ' ' + unitBig;
    } else if (qu > 100 ) {
      return Math.round(qu) + ' ' + unit;
    } else if (qu > 10 ) {
      return Math.round(qu*10)/10 + ' ' + unit;
    } else {
      return Math.round(qu*100)/100 + ' ' + unit;
    }
  } else {
    return null;
  }
};

var docReady = function() {
	$.material.init();
};


$(document).ready(docReady);