# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
    $.ajax({
      type: "GET",
      url: "/ingredients/get_table",
      dataType: "json"
      success:(data) ->
        t = false
        #t = display_table(data, "TableContent")      
        return true
      error:(data) ->
        return false
    })